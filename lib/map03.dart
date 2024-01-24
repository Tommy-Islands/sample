import 'dart:math';
import 'package:flutter/material.dart';

class map03 extends StatelessWidget {
  const map03({super.key});

  @override
  Widget build(BuildContext context) {
    return const point();
  }
}

class point extends StatefulWidget {
  const point({super.key});

  @override
  State<point> createState() => _mapState();
}

class _mapState extends State<point> with AutomaticKeepAliveClientMixin {
  final widgets = <Key, Widget>{};
  late Color iconColor;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    iconColor = getRandomColor(); // initStateでランダムな視認しやすい色を生成
  }

  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        GestureDetector(
          onTapDown: (tapDownDetails) {
            final key = UniqueKey();
            widgets[key] = Positioned(
              key: key,
              left: tapDownDetails.localPosition.dx - 12,
              top: tapDownDetails.localPosition.dy - 12,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widgets.remove(key);
                  });
                },
                child: Icon(
                  Icons.cruelty_free,
                  color: iconColor,
                ),
              ),
            );
            setState(() {});
          },
          child: Stack(
            children: [
              Container(
                child: Image.asset(
                  'images/garemarudo.webp',
                  fit: BoxFit.contain,
                ),
                padding: EdgeInsets.all(10),
                color: Colors.blueGrey,
              ),
              ...widgets.values,
            ],
          ),
        ),
        // 全削除ボタンを追加
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                widgets.clear();
              });
            },
            child: Icon(Icons.delete),
          ),
        ),
      ],
    );
  }

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

// ランダムな視認しやすい色を生成する関数
  Color getRandomColor() {
    Random random = Random();
    int index = random.nextInt(colors.length); // 0 to 9
    return colors[index];
  }
}
