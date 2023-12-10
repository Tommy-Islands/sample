import 'package:flutter/material.dart';

class map04 extends StatelessWidget {
  const map04({super.key});

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

class _mapState extends State<point> {
  final widgets = [];

  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (tapDownDetails) {
        widgets.add(
          Positioned(
            left: tapDownDetails.localPosition.dx,
            top: tapDownDetails.localPosition.dy,
            child: Icon(
              Icons.cruelty_free,
              color: Colors.redAccent,
            ),
          ),
        );
        setState(() {});
      },
      child: Stack(
        // fit: StackFit.expand,
        children: [
          Container(
            child: Image.asset(
              'images/moon.webp',
              fit: BoxFit.contain,
            ),
            padding: EdgeInsets.all(10),
            color: Colors.blueGrey,
          ),
          ...widgets,
        ],
      ),
    );
  }
}
