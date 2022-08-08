
import 'dart:ui';

import 'package:multi_select_flutter/util/multi_select_item.dart';

const Color kAppcolor = Color(0xFF212d3b);
const Color kBackcolor = Color(0xFF16222e);
const Color kChatcolor = Color(0xFF3e6189);
const Color kTimecolor = Color(0xFF749abf);
const Color kEditcolor = Color.fromARGB(255, 40, 56, 72);

int kTotalPrice = 0;
int kBucketItem = 0;

List<MultiSelectItem> kCategoryList = [
  MultiSelectItem('Book', 'Book'),
  MultiSelectItem('Food', 'Food'),
  MultiSelectItem('Building', 'Building'),
  MultiSelectItem('Car', 'Car'),
  MultiSelectItem('Personal', 'Personal'),
];