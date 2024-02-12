import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapController extends GetxController {
  final widgets = <Key, Widget>{}.obs;
  late Color iconColor;
  final _firestore = FirebaseFirestore.instance;
  final String userId;

  MapController(this.userId);

void addWidget(Offset position) {
  final key = DateTime.now().millisecondsSinceEpoch.toString();
  widgets[ValueKey(key)] = Positioned(
    key: ValueKey(key),
    left: position.dx - 12,
    top: position.dy - 12,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => removeWidget(key),
      child: Icon(
        Icons.cruelty_free,
        color: iconColor,
      ),
    ),
  );
  // Update Firestore
  _firestore.collection('maps').doc('shared').set({
    'widgets': {
      key: {
        'position': {
          'dx': position.dx,
          'dy': position.dy
        },
        'color': iconColor.value, // Save color as integer
        'userId': userId // Save user ID
      }
    }
  }, SetOptions(merge: true));
}


void removeWidget(String key) {
  // Get the widget data from Firestore
  _firestore.collection('maps').doc('shared').get().then((snapshot) {
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()!['widgets'] ?? {};
      if (data.containsKey(key) && data[key]['userId'] == userId) {
        // If the widget belongs to the current user, remove it
        widgets.removeWhere((widgetKey, _) => widgetKey.toString() == key);
        // Update Firestore
        _firestore.collection('maps').doc('shared').update({
          'widgets.$key': FieldValue.delete()
        }).catchError((error) {
          print("Failed to remove widget: $error");
        });
      }
    }
  });
}

void clearWidgets() {
  // Get the widget data from Firestore
  _firestore.collection('maps').doc('shared').get().then((snapshot) {
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()!['widgets'] ?? {};
      data.forEach((key, value) {
        if (value['userId'] == userId) {
          // If the widget belongs to the current user, remove it
          widgets.removeWhere((widgetKey, _) => widgetKey.toString() == key);
          // Update Firestore
          _firestore.collection('maps').doc('shared').update({
            'widgets.${key}': FieldValue.delete()
          }).catchError((error) {
            print("Failed to remove widget: $error");
          });
        }
      });
    }
  });
}

@override
void onInit() {
  super.onInit();
  iconColor = getRandomColor();
  _firestore.collection('maps').doc('shared').snapshots().listen((snapshot) {
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()!['widgets'] ?? {};
      widgets.clear();
      data.forEach((key, value) {
        Offset position = Offset(value['position']['dx'], value['position']['dy']);
        Color color = Color(value['color']); // Reconstruct color from integer
        final widgetKey = ValueKey(key);
        widgets[widgetKey] = Positioned(
          key: widgetKey,
          left: position.dx - 12,
          top: position.dy - 12,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: value['userId'] == userId ? () => removeWidget(key) : null, // Only allow removal if the widget belongs to the current user
            child: Icon(
              Icons.cruelty_free,
              color: color,
            ),
          ),
        );
      });
    }
  });
}




  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
    Colors.pink,
    Colors.indigo,
    Colors.black,
    Colors.white,
  ];

  Color getRandomColor() {
    Random random = Random();
    int index = random.nextInt(colors.length);
    return colors[index];
  }
}
