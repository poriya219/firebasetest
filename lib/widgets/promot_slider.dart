import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetest/consts.dart';
import 'package:flutter/material.dart';

import '../screens/fulldetail_screen.dart';

class PromotSlider extends StatefulWidget {
  const PromotSlider({Key? key}) : super(key: key);

  @override
  State<PromotSlider> createState() => _PromotSliderState();
}

class _PromotSliderState extends State<PromotSlider> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestore.collection('items').orderBy('time', descending: true).limit(3).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<Map<String, dynamic>> maplist = [];
            List<QueryDocumentSnapshot> list = snapshot.data!.docs;
            for (QueryDocumentSnapshot each in list) {
              Map<String, dynamic> data = each.data() as Map<String, dynamic>;
              maplist.add(data);
            }
            return CarouselSlider(
              items: [
                for (int i = 0; i < list.length; i++) ...[
                  Builder(builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Fulldetail_Screen(
                                data: maplist[i],
                                postid: list[i].id,
                              );
                            },
                          ),
                        );
                      },
                      child: (maplist[i]['image'] != '-1')
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
                        image: NetworkImage(maplist[i]['image']),
                        placeholder: const AssetImage(
                            'assets/default2.png'),
                      )
                          : const Image(
                        image: AssetImage('assets/default2.png'),
                        width: 55,
                      ),
                    );
                  })
                ],
              ],
              options: CarouselOptions(
                height: 230,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                enableInfiniteScroll: true,
                disableCenter: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            );
          } else {
            return CarouselSlider(
              items: [],
              options: CarouselOptions(
                height: 230,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            );
          }
        });
  }
}
