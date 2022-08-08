import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetest/consts.dart';
import 'package:flutter/material.dart';

class Bucket_Screen extends StatefulWidget {
  @override
  State<Bucket_Screen> createState() => _Bucket_ScreenState();
}

class _Bucket_ScreenState extends State<Bucket_Screen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackcolor,
      appBar: AppBar(
        title: Text('Bucket Screen'),
        backgroundColor: kAppcolor,
      ),
      body: Stack(children: [
        StreamBuilder(
            stream: firestore
                .collection('bucket')
                .doc(auth.currentUser!.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.data() == null) {
                  return const Center(
                    child: Text('No Items'),
                  );
                } else {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  List keys = data.keys.toList();
                    kTotalPrice = data['total'];
                  return Column(
                    children: [
                      SizedBox(
                        height : size.height * 0.81,
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, index) {
                            if (keys[index] == 'total') {
                              return Container();
                            } else {
                              int itemCount = data[keys[index]];
                              return FutureBuilder(
                                future: loadEachItem(keys[index]),
                                builder: (BuildContext context,
                                    AsyncSnapshot<Map<String, dynamic>>
                                        snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.connectionState ==
                                          ConnectionState.done) {
                                    Map<String, dynamic> itemData =
                                        snapshot.data ?? {};
                                    return Card(
                                      child: ListTile(
                                        leading: (itemData['image'] != '-1')
                                            ? FadeInImage(
                                                imageErrorBuilder: (context,
                                                    error, stackTrace) {
                                                  return const Image(
                                                    image: AssetImage(
                                                        'assets/default2.png'),
                                                    width: 55,
                                                  );
                                                },
                                                width: 55,
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    itemData['image']),
                                                placeholder: const AssetImage(
                                                    'assets/default2.png'),
                                              )
                                            : const Image(
                                                image: AssetImage(
                                                    'assets/default2.png'),
                                                width: 55,
                                              ),
                                        title: Text(itemData['name']),
                                        subtitle:
                                            Text('${itemData['price']} \$'),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  onButtonPress(
                                                      key: keys[index],
                                                      count: itemCount,
                                                       type: 'Remove',
                                                    price: itemData['price'],
                                                    total: data['total'],
                                                       );
                                                });
                                              },
                                              child: Container(
                                                width: 35,
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text('$itemCount'),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  onButtonPress(
                                                    key: keys[index],
                                                    count: itemCount,
                                                    type: 'Add',
                                                    price: itemData['price'],
                                                    total: data['total'],
                                                  );
                                                });
                                              },
                                              child: Container(
                                                width: 35,
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return const Card(
                                    child: SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          itemCount: keys.length,
                        ),
                      ),
                    ],
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        Positioned(
          bottom: 0,
          child: Container(
            width: size.width,
            height: size.height * 0.08,
            color: kChatcolor,
            child: Row(
              children: [
                const SizedBox(width: 25,),
                const Text('total:'),
                const Spacer(),
                Text(kTotalPrice.toString()),
                SizedBox(width: 7,),
                Text('\$'),
                SizedBox(width: 25,),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Future<Map<String, dynamic>> loadEachItem(String id) async {
    DocumentSnapshot resault =
        await firestore.collection('items').doc(id).get();
    return resault.data() as Map<String, dynamic>;
  }

  onButtonPress({required String key, required int count,required int price,required int total, required String type}) async {
    String userid = auth.currentUser!.uid;
    CollectionReference bucketref = firestore.collection('bucket');
    DocumentReference doc = bucketref.doc(userid);
    DocumentSnapshot documentSnapshot = await doc.get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    if (type == 'Add') {
      count++;
      data[key] = count;
      data['total'] = total + price;
      doc.update(data);
    } else {
      if (count > 1) {
        count--;
        data[key] = count;
        data['total'] = total - price;
        doc.update(data);
      }
      else{
        kBucketItem--;
        data.remove(key);
        data['total'] = total - price;
        doc.set(data);
      }
    }
    setState((){
      kTotalPrice = data['total'];
    });
  }
}
