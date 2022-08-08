import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetest/consts.dart';
import 'package:flutter/material.dart';

class Chat_Screen extends StatefulWidget {
  @override
  State<Chat_Screen> createState() => _Chat_ScreenState();
}

class _Chat_ScreenState extends State<Chat_Screen> {
  TextEditingController textcontroller = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference messageref;
  late Size size;
  bool iseditingMode = false;
  var tapposition = Offset(0.0, 0.0);
  late String editpostId;
  String editpostText = '';

  // late RenderBox overlay;

  @override
  void initState() {
    super.initState();
    messageref = firestore.collection('Messages');
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: const [
          Icon(Icons.more_vert),
          SizedBox(
            width: 15,
          )
        ],
        backgroundColor: kAppcolor,
        title: const Text('Chat'),
      ),
      body: Container(
        color: kBackcolor,
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                color: kBackcolor,
                // width: size.width * 0.5,
                // height: size.height * 0.79,
                child: StreamBuilder<QuerySnapshot>(
                    stream: messageref
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        // final temp = snapshot.data;
                        return ListView(
                          reverse: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            String id = document.id;
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return GestureDetector(
                              onTapUp: (TapUpDetails details) =>
                                  onTapUp(details),
                              onTap: () {
                                showPopUp(data, data['sender'], id);
                              },
                              child: Bubble(
                                color: (data['sender'] == auth.currentUser!.uid)
                                    ? kChatcolor
                                    : kAppcolor,
                                nip: (data['sender'] == auth.currentUser!.uid)
                                    ? BubbleNip.rightBottom
                                    : BubbleNip.leftBottom,
                                margin: BubbleEdges.only(
                                    top: 8,
                                    left: (data['sender'] ==
                                            auth.currentUser!.uid)
                                        ? 15
                                        : 0,
                                    right: (data['sender'] !=
                                            auth.currentUser!.uid)
                                        ? 15
                                        : 0),
                                alignment:
                                    (data['sender'] == auth.currentUser!.uid)
                                        ? Alignment.topRight
                                        : Alignment.bottomLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Visibility(
                                      visible: data['sender'] != auth.currentUser!.uid,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(data['senderphone'],style: TextStyle(color: Colors.blue),),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(width: 3),
                                        Container(
                                          constraints: BoxConstraints(
                                              maxWidth: size.width * 0.55),
                                          child: Text(
                                            data['text'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              data['time'].toDate().minute >= 10
                                                  ? '${data['time'].toDate().hour}:${data['time'].toDate().minute}'
                                                  : '${data['time'].toDate().hour}:0${data['time'].toDate().minute}',
                                              style: const TextStyle(
                                                color: kTimecolor,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 2),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } //
                      else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: iseditingMode,
              child: Container(
                color: kAppcolor,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.edit,
                      color: Colors.blue,
                      size: 27,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Edit Massage',
                            style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            editpostText,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        iseditingMode = false;
                        editpostId = '';
                        editpostText = '';
                        textcontroller.clear();
                        setState((){});
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.grey,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            // Spacer(),
            Container(
              color: kAppcolor,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 8, bottom: 5, top: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: textcontroller,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        hintText: 'Massage',
                      ),
                      minLines: 1,
                      maxLines: 4,
                      autofocus: false,
                    )),
                    sendoreditButton(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  sendoreditButton() {
    if (iseditingMode) {
      return IconButton(
        onPressed: () {
          edit();
          iseditingMode = false;
          textcontroller.clear();
          setState(() {});
        },
        icon: const Icon(Icons.check, color: Colors.blue),
      );
    } //
    else {
      return IconButton(
        onPressed: () {
          onsendPress();
        },
        icon: const Icon(Icons.send, color: Colors.blue),
      );
    }
  }

  onsendPress() {
    String text = textcontroller.text;
    String uid = auth.currentUser!.uid;
    String senderphone = auth.currentUser!.phoneNumber ?? '';
    if (text.isNotEmpty) {
      Map<String, dynamic> map = {};
      map['text'] = text;
      map['time'] = DateTime.now();
      map['sender'] = uid;
      map['senderphone'] = senderphone;

      messageref.add(map);
    }
    textcontroller.clear();
  }

  onTapUp(TapUpDetails details) {
    tapposition = details.globalPosition;
    setState(() {});
  }

  showPopUp(Map<String, dynamic> data, dynamic sender, String id) async {
    RelativeRect position;
    await showMenu(
        color: kEditcolor,
        context: context,
        position: RelativeRect.fromRect(
          tapposition & const Size(10, 10), // smaller rect, the touch area
          Offset.zero & size,
        ),
        items: [
          PopupMenuItem(
            child: TextButton.icon(
                onPressed: () {
                  ondeletePress(id);
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                ),
                label: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                )),
          ),
          showedit(sender, data, id),
          // PopupMenuItem(
          //   child: TextButton.icon(
          //       onPressed: () {
          //         ondeditPress(data, id);
          //         Navigator.pop(context);
          //       },
          //       icon: const Icon(
          //         Icons.edit,
          //         color: Colors.white,
          //       ),
          //       label: const Text(
          //         'Edit',
          //         style: TextStyle(color: Colors.white),
          //       )),
          // ),
        ]);
  }

  PopupMenuEntry<dynamic> showedit(dynamic sender,Map<String, dynamic> data, String id){
    if(sender == auth.currentUser!.uid){
      return PopupMenuItem(
        child: TextButton.icon(
            onPressed: () {
              ondeditPress(data, id);
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            label: const Text(
              'Edit',
              style: TextStyle(color: Colors.white),
            )),
      );
    }//
    else{
      return PopupMenuDivider();
    }
  }

  ondeletePress(String id) {
    messageref.doc(id).delete();
  }

  ondeditPress(Map<String, dynamic> data, String id) {
    textcontroller.text = data['text'];
    editpostText = data['text'];
    iseditingMode = true;
    editpostId = id;
    setState(() {});
    // Map<String, dynamic> body = json.decode(data);
  }

  edit() {
    String editedtext = textcontroller.text;
    Map<String, dynamic> map = {};
    map['text'] = editedtext;
    messageref.doc(editpostId).update(map);
    iseditingMode = false;
    editpostId = '';
    editpostText = '';
    setState(() {});
  }
}
