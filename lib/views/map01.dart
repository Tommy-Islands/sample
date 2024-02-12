import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/controllers/map_controller.dart';
import 'package:sample/models/point.dart';

class Map01 extends StatelessWidget {
  final String userId;

  const Map01({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapController(userId), permanent: true); // ここを修正

    return Point(imagePath: 'images/elpis.jpg'); // ここを修正
  }
}
