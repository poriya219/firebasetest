import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetest/consts.dart';
import 'package:flutter/material.dart';

class Chat_Box extends StatelessWidget {
  String text;
  Timestamp time;
  late Size size;

  Chat_Box({required this.text, required this.time});

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Container(
        // width: size.width,
        // height: size.height * 0.07,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          color: kChatcolor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomLeft: Radius.circular(25),
              topRight: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 15),
            Container(
              constraints: BoxConstraints(maxWidth: size.width * 0.55),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
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
                  time.toDate().minute >= 10
                      ? '${time.toDate().hour}:${time.toDate().minute}'
                      : '${time.toDate().hour}:0${time.toDate().minute}',
                  style: const TextStyle(
                    color: kTimecolor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }
}
