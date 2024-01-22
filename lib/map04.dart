import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class map04 extends StatelessWidget {
  const map04({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const point();
  }
}

class point extends StatefulWidget {
  const point({Key? key}) : super(key: key);

  @override
  State<point> createState() => _mapState();
}

class _mapState extends State<point> with AutomaticKeepAliveClientMixin {
  late Color iconColor;
  late CollectionReference<Map<String, dynamic>> iconsCollection;

  @override
  bool get wantKeepAlive => true;

  // 視認しやすい10色のリスト
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

  @override
  void initState() {
    super.initState();
    iconColor = getRandomColor();
    iconsCollection =
        FirebaseFirestore.instance.collection('icons').withConverter(
              fromFirestore: (snapshot, _) =>
                  Map<String, dynamic>.from(snapshot.data()!),
              toFirestore: (data, _) => data,
            );
  }

  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: iconsCollection.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // データの取得中はローディング表示など
        }

        final List<Widget> iconWidgets = [];

        snapshot.data!.docs.forEach((doc) {
          final id = doc.id;
          final left = doc['left'] as double;
          final top = doc['top'] as double;
          final color = Color(doc['color'] as int);

          final key = Key(id);
          iconWidgets.add(
            Positioned(
              key: key,
              left: left,
              top: top,
              child: GestureDetector(
                onDoubleTap: () {
                  _removeIconFromFirestore(id);
                },
                child: Icon(
                  Icons.cruelty_free,
                  color: color,
                ),
              ),
            ),
          );
        });

        return Stack(
          children: [
            GestureDetector(
              onTapDown: (tapDownDetails) {
                final key = UniqueKey();
                final left = tapDownDetails.localPosition.dx - 12;
                final top = tapDownDetails.localPosition.dy - 12;

                _addIconToFirestore(left, top, iconColor);

                setState(() {
                  iconWidgets.add(
                    Positioned(
                      key: key,
                      left: left,
                      top: top,
                      child: GestureDetector(
                        onDoubleTap: () {
                          _removeIconFromFirestore(key.toString());
                        },
                        child: Icon(
                          Icons.cruelty_free,
                          color: iconColor,
                        ),
                      ),
                    ),
                  );
                });
              },
              child: Stack(
                children: [
                  Container(
                    child: Image.asset(
                      'images/moon.webp',
                      fit: BoxFit.contain,
                    ),
                    padding: EdgeInsets.all(10),
                    color: Colors.blueGrey,
                  ),
                  ...iconWidgets,
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  _clearIconsInFirestore();
                },
                child: Icon(Icons.delete),
              ),
            ),
          ],
        );
      },
    );
  }

  // ランダムな視認しやすい色を生成する関数
  Color getRandomColor() {
    Random random = Random();
    int index = random.nextInt(colors.length); // 0 to 9
    return colors[index];
  }

  Future<void> _addIconToFirestore(double left, double top, Color color) async {
    await iconsCollection.add({
      'left': left,
      'top': top,
      'color': color.value,
    });
  }

  Future<void> _removeIconFromFirestore(String id) async {
    await iconsCollection.doc(id).delete();
  }

  Future<void> _clearIconsInFirestore() async {
    final userIcons =
        await iconsCollection.where('color', isEqualTo: iconColor.value).get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in userIcons.docs) {
      await doc.reference.delete();
    }
  }
}
