import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../consts.dart';
import '../screens/add_sell_item.dart';
import '../screens/chat_screen.dart';
import '../screens/signin_screen.dart';

class App_Drawer extends StatefulWidget {
  Size size;
  FirebaseAuth auth;

  App_Drawer({required this.size,required this.auth});


  @override
  State<App_Drawer> createState() => _App_DrawerState();
}

class _App_DrawerState extends State<App_Drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: kEditcolor,
            child: DrawerHeader(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: widget.size.width * 0.2,
                          height: widget.size.height * 0.1,
                          child: const CircleAvatar(),
                        ),
                        const Spacer(),
                        Text(
                          widget.auth.currentUser!.phoneNumber ?? '',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: kAppcolor,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.chat_outlined,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      'Chats',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Chat_Screen();
                            },
                          ),
                        );
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.sell_outlined,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      'Sell',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Sell_Screen(type: 'Add',data: const {},);
                            },
                          ),
                        );
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      'Log out',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () async{
                      await widget.auth.signOut();
                      setState(() {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Signin_Screen();
                            },
                          ),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
