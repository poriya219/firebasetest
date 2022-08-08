import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:firebasetest/consts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Sell_Screen extends StatefulWidget {
  String type;
  Map<String, dynamic> data;

  Sell_Screen({required this.type,required this.data});
  @override
  State<Sell_Screen> createState() => _Sell_ScreenState();
}

class _Sell_ScreenState extends State<Sell_Screen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Size size;
  int itemCount = 0;
  File imageFile = File('-1');
  final ImagePicker picker = ImagePicker();
  List selectedCategory = [];
  bool modalhud = false;

  @override
  void initState(){
    super.initState();
    if(widget.type == 'Edit'){
      nameController.text = widget.data['name'];
      descriptionController.text = widget.data['description'];
      priceController.text = widget.data['price'].toString();
      itemCount = widget.data['count'];
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Visibility(
            visible: validate(),
            child: IconButton(
              onPressed: () {
                setState((){
                  modalhud = true;
                });
                onokPress();
              },
              icon: const Icon(
                Icons.check,
                size: 30,
              ),
            ),
          ),
        ],
        backgroundColor: kAppcolor,
        title: const Text('Sell'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: modalhud,
        child: Container(
          width: size.width,
          height: size.height,
          color: kBackcolor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: nameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(15)),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Name',
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: descriptionController,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(15)),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Description',
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(15)),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Price',
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              if (itemCount > 0) {
                                itemCount--;
                              }
                            });
                          },
                          child: const Icon(Icons.remove),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '$itemCount',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              itemCount++;
                            });
                          },
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                    InkWell(
                      onTap: () async {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != '-1') {
                          imageFile = File(image!.path);
                        }
                        setState(() {});
                      },
                      child: (imageFile.path == '-1')
                          ? const CircleAvatar(
                              minRadius: 35,
                              child: Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 30,
                              ),
                            )
                          : Stack(
                              children: [
                                CircleAvatar(
                                  maxRadius: 60,
                                  minRadius: 35,
                                  backgroundImage: FileImage(imageFile),
                                ),
                                const Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      minRadius: 20,
                                      child: Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 15,
                                      ),
                                    ))
                              ],
                            ),
                    ),
                    const SizedBox(
                      height: 90,
                    ),
                    MultiSelectDialogField(
                      buttonIcon: const Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                      ),
                      buttonText: const Text(
                        'Select Category',
                        style: TextStyle(color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: const Text('Select Category'),
                      items: kCategoryList,
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (values) {
                        selectedCategory = values;
                        setState((){});
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    if (nameController.text == '' ||
        descriptionController.text == '' ||
        priceController.text == '' ||
        selectedCategory.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

onokPress() async{
    String name = nameController.text;
    String description = descriptionController.text;
    int price = int.parse(priceController.text);
    int countItem = itemCount;
    List categorys = selectedCategory;
    String id = auth.currentUser!.uid;
    DateTime time = DateTime.now();
    String imagePath = '-1';
    if(imageFile.path != '-1') {
      imagePath = await uploadImage();
    };
    String filename = imageFile.path.split('/').last;
    Map<String, dynamic> map = Map();
    map['name'] = name;
    map['description'] = description;
    map['price'] = price;
    map['count'] = countItem;
    map['categorys'] = categorys;
    map['userid'] = id;
    map['time'] = time;
    map['image'] = imagePath;
    map['imagename'] = filename;
    await firestore.collection('items').add(map);
    setState((){
      modalhud = false;
    });
    Navigator.pop(context);
    Navigator.pop(context);

}

uploadImage() async{
try{
  String filename = imageFile.path.split('/').last;
  TaskSnapshot snapshot = await storage.ref().child('items/images/$filename').putFile(imageFile);
  String url = await snapshot.ref.getDownloadURL();
  return url;
}//
  catch(e){
  print(e);
  }
}

}
