import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetest/widgets/promot_slider.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../consts.dart';
import '../screens/fulldetail_screen.dart';

class Home_Body extends StatefulWidget {
  @override
  State<Home_Body> createState() => _Home_BodyState();
}

class _Home_BodyState extends State<Home_Body> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late CollectionReference itemRef;
  List<MultiSelectItem> category = [];
  String selectedCategory = 'All';
  late Size size;

  @override
  void initState() {
    category = kCategoryList;
    super.initState();
    loadBucketData();

    itemRef = firestore.collection('items');
    category.insert(
      0,
      MultiSelectItem('All', 'All'),
    );
  }

  loadBucketData() async{
    DocumentSnapshot data = await firestore.collection('bucket').doc(auth.currentUser!.uid).get();
    Map<String, dynamic> dataMap = data.data() as Map<String, dynamic>;
    List keys = dataMap.keys.toList();
    setState((){
      kBucketItem = keys.length - 1;
      print('=============================================== $kBucketItem');
    });
  }


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      color: kBackcolor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PromotSlider(),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Categories',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: category
                  .map((MultiSelectItem categorymap) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = categorymap.label;
                            print(selectedCategory);
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 12),
                          decoration: BoxDecoration(
                            color: (selectedCategory == categorymap.label)
                                ? Colors.blueAccent
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(categorymap.label),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: loadData(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    // final temp = snapshot.data;
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        String id = document.id;
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        String imagePath = data['image'];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Fulldetail_Screen(
                                    data: data,
                                    postid: id,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: kChatcolor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 7),
                            child: ListTile(
                              leading: (imagePath != '-1')
                                  ? FadeInImage(
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return const Image(
                                          image:
                                              AssetImage('assets/default2.png'),
                                          width: 55,
                                        );
                                      },
                                      width: 55,
                                      fit: BoxFit.cover,
                                      image: NetworkImage(data['image']),
                                      placeholder: const AssetImage(
                                          'assets/default2.png'),
                                    )
                                  : const Image(
                                      image: AssetImage('assets/default2.png'),
                                      width: 55,
                                    ),
                              title: Text(
                                data['name'],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                data['description'],
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${data['price'].toString()} \$',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState((){
                                        onAddPress(id, data['price']);
                                      });
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
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
        ],
      ),
    );
  }

  Stream<QuerySnapshot> loadData() {
    if (selectedCategory == 'All') {
      return itemRef.orderBy('time', descending: true).snapshots();
    } else {
      return itemRef
          .orderBy('time', descending: true)
          .where('categorys', arrayContains: selectedCategory)
          .snapshots();
    }
  }

  onAddPress(String id, int price) async {
    String userid = auth.currentUser!.uid;
    CollectionReference bucketref = firestore.collection('bucket');
    DocumentReference doc = bucketref.doc(userid);
    DocumentSnapshot documentSnapshot = await doc.get();
    if (documentSnapshot.data() == null) {
      setState((){
        kBucketItem++;
      });
      doc.set({
        id: 1,
        'total': 1 * price,
      });
    } else {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      if (data[id] != null) {
          data[id] = data[id] + 1;
          data['total'] = data['total'] + price;
      } else {
        setState((){
          kBucketItem++;
        });
          data[id] = 1;
          data['total'] = data['total'] + price;
      }
      kTotalPrice = data['total'];
      print(kBucketItem);
      doc.update(data);
    }
  }
}
