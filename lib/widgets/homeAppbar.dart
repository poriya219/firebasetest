import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetest/screens/bucket_screen.dart';
import 'package:flutter/material.dart';

import '../consts.dart';

class Home_AppBar extends StatefulWidget implements PreferredSizeWidget {
  Home_AppBar() : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  @override
  State<Home_AppBar> createState() => _Home_AppBarState();
}

class _Home_AppBarState extends State<Home_AppBar> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kAppcolor,
      title: const Text('Home'),
      actions: [
        StreamBuilder(
            stream: firestore.collection('shopping_basket').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Bucket_Screen();
                            },
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.shopping_basket_outlined,
                        size: 30,
                      ),
                    ),
                    Visibility(
                      visible: kBucketItem > 0,
                      child: Positioned(
                        left: -10,
                        top: 10,
                        child: SizedBox(
                          height: 18,
                          child: CircleAvatar(
                            child: Text('$kBucketItem'),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.shopping_basket_outlined),
                );
              }
            }),
      ],
    );
  }
}
