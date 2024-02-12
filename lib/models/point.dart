import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/controllers/map_controller.dart';

class Point extends StatelessWidget {
  final String imagePath;
  const Point({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MapController>(); // ここを修正

    return Stack(
      children: [
        GestureDetector(
          onTapDown: (tapDownDetails) {
            controller.addWidget(tapDownDetails.localPosition);
          },
          child: Stack(
            children: [
              Container(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
                padding: EdgeInsets.all(10),
                color: Colors.blueGrey,
              ),
              Obx(() => Stack(children: controller.widgets.values.toList())),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: controller.clearWidgets,
            child: Icon(Icons.delete),
          ),
        ),
      ],
    );
  }
}
