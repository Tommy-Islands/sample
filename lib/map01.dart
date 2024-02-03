import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class map01 extends StatelessWidget {
  const map01({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Point();
  }
}

class Point extends StatefulWidget {
  const Point({Key? key});

  @override
  State<Point> createState() => _MapState();
}

class _MapState extends State<Point> with AutomaticKeepAliveClientMixin {
  late Color iconColor;
  late String userId;
  final CollectionReference iconsCollection01 =
      FirebaseFirestore.instance.collection('icons01');

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    userId = getUserId();
    iconColor = getRandomColor();
  }

  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<QuerySnapshot>(
      stream: iconsCollection01.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('エラー: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final List<DocumentSnapshot> documents = snapshot.data!.docs;

        return Stack(
          children: [
            GestureDetector(
              onTapDown: (tapDownDetails) {
                final key = UniqueKey();
                final newIcon = IconDataPoint(
                  key: key,
                  left: tapDownDetails.localPosition.dx - 12,
                  top: tapDownDetails.localPosition.dy - 12,
                  color: iconColor,
                  userId: userId,
                );

                iconsCollection01.add(newIcon.toMap());

                setState(() {});
              },
              child: Stack(
                children: [
                  Container(
                    child: Image.asset(
                      'images/elpis.jpg',
                      fit: BoxFit.contain,
                    ),
                    padding: EdgeInsets.all(10),
                    color: Colors.blueGrey,
                  ),
                  ...documents.map((doc) {
                    IconDataPoint iconDataPoint = IconDataPoint.fromMap(
                        doc.data() as Map<String, dynamic>);
                    return Positioned(
                      key: iconDataPoint.key,
                      left: iconDataPoint.left,
                      top: iconDataPoint.top,
                      child: GestureDetector(
                        onTap: () {
                          if (iconDataPoint.userId == getUserId()) {
                            iconsCollection01.doc(doc.id).delete();
                          }
                        },
                        child: Icon(
                          Icons.cruelty_free,
                          color: iconDataPoint.color,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  // 'icons01' コレクションからすべてのアイコンを削除
                  iconsCollection01.get().then((snapshot) {
                    for (DocumentSnapshot doc in snapshot.docs) {
                      doc.reference.delete();
                    }
                  });
                },
                child: Icon(Icons.delete),
              ),
            ),
          ],
        );
      },
    );
  }

  String getUserId() {
    String randomId = (1000 + Random().nextInt(9000)).toString();
    return randomId;
  }

  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    const Color.fromARGB(255, 72, 101, 105),
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

class IconDataPoint {
  final Key key;
  final double left;
  final double top;
  final Color color;
  final String userId;

  IconDataPoint({
    required this.key,
    required this.left,
    required this.top,
    required this.color,
    this.userId = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'key': key.toString(),
      'left': left,
      'top': top,
      'color': color.value,
      'userId': userId,
    };
  }

  factory IconDataPoint.fromMap(Map<String, dynamic> map) {
    return IconDataPoint(
      key: Key(map['key']),
      left: map['left'],
      top: map['top'],
      color: Color(map['color']),
      userId: map['userId'] ?? '', // nullチェックを追加
    );
  }
}
