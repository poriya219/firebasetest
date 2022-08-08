import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasetest/consts.dart';
import 'package:firebasetest/screens/full_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'add_sell_item.dart';

class Fulldetail_Screen extends StatefulWidget {
  Map<String, dynamic> data;
  String postid;

  Fulldetail_Screen({required this.data, required this.postid});

  @override
  State<Fulldetail_Screen> createState() => _Fulldetail_ScreenState();
}

class _Fulldetail_ScreenState extends State<Fulldetail_Screen> {
  late Size size;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool modalhud = false;

  @override
  Widget build(BuildContext context) {
    String imagePath = widget.data['image'];
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Visibility(
            visible: widget.data['userid'] == auth.currentUser!.uid,
            child: IconButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Sell_Screen(type: 'Edit',data: widget.data,);
                      },
                    ),
                  );
                });
              },
              icon: Icon(Icons.edit),
            ),
          ),
          Visibility(
            visible: widget.data['userid'] == auth.currentUser!.uid,
            child: IconButton(
              onPressed: () {
                setState(() {
                  modalhud = true;
                });
                ondeletePressed();
              },
              icon: Icon(Icons.delete_forever),
            ),
          ),
        ],
        backgroundColor: kAppcolor,
        title: Text(widget.data['name']),
      ),
      body: ModalProgressHUD(
        inAsyncCall: modalhud,
        child: Container(
          width: size.width,
          height: size.height,
          color: kBackcolor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Fullsize_Image(widget.data['image']);
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: size.height * 0.35,
                    width: size.width,
                    child: (imagePath != '-1')
                        ? FadeInImage(
                            imageErrorBuilder: (context, error, stackTrace) {
                              return const Image(
                                image: AssetImage('assets/default2.png'),
                                width: 55,
                              );
                            },
                            width: 55,
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.data['image']),
                            placeholder: const AssetImage('assets/default2.png'),
                          )
                        : const Image(
                            image: AssetImage('assets/default2.png'),
                            width: 55,
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data['name'],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(thickness: 2, color: Colors.grey.shade600),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.data['description'],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Divider(thickness: 1, color: Colors.grey.shade600),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Available : ${widget.data['count']}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Price : ${widget.data['price']} \$",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      const Text(
                        'Category:',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: categoryCreator(),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> categoryCreator() {
    List category = widget.data['categorys'];
    List<Widget> widgetList = [];
    for (int i = 0; i < category.length; i++) {
      widgetList.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        margin: EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(category[i]),
      ));
    }
    return widgetList;
  }

  ondeletePressed() async {
    try {
      if (widget.data['imagename'] != '-1') {
        await storage
            .ref()
            .child('items/images/${widget.data['imagename']}')
            .delete();
      }
      await firestore.collection('items').doc(widget.postid).delete();
      modalhud = false;
      Navigator.pop(context);
    } //
    catch (e) {
      print(e);
    }
  }
}
