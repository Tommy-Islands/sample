import 'package:flutter/material.dart';
import 'package:sample/map01.dart';
import 'package:sample/map02.dart';
import 'package:sample/map03.dart';
import 'package:sample/map04.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  List<Tab> tabs = [
    Tab(
      child: Text(
        "エルピス",
        style: TextStyle(color: Colors.white70),
      ),
    ),
    Tab(
      child: Text(
        "サベネア島",
        style: TextStyle(color: Colors.white70),
      ),
    ),
    Tab(
      child: Text(
        "ガレマルド",
        style: TextStyle(color: Colors.white70),
      ),
    ),
    Tab(
      child: Text(
        "嘆きの海",
        style: TextStyle(color: Colors.white70),
      ),
    ),
  ];

  List<Widget> tabsContent = [
    Container(
      alignment: Alignment.center,
      child: (map01()),
      width: double.infinity,
    ),
    Container(
      alignment: Alignment.center,
      child: (map02()),
      width: double.infinity,
    ),
    Container(
      alignment: Alignment.center,
      child: (map03()),
      width: double.infinity,
    ),
    Container(
      alignment: Alignment.center,
      child: (map04()),
      width: double.infinity,
    ),
  ];

  void initializeFirestoreData() {
    List<String> collectionNames = ['icons01', 'icons02', 'icons03', 'icons04'];

    // 各コレクションのデータを初期化
    collectionNames.forEach((collectionName) {
      FirebaseFirestore.instance
          .collection(collectionName)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'マッピングウェイ',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
          actions: [
            // 初期化ボタン
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                initializeFirestoreData();
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: TabBar(
              indicatorColor: Colors.white,
              isScrollable: true,
              tabs: tabs,
            ),
          ),
        ),
        body: TabBarView(
          children: tabsContent,
        ),
      ),
    );
  }
}
