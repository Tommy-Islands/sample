import 'package:flutter/material.dart';
import 'package:sample/views/map01.dart'; // 他のビューもインポートしてください

class HomePage extends StatelessWidget {
  final String userId;
  final List<String> tabNames = ["エルピス", "サベネア島", "ガレマルド", "嘆きの海"];
  final List<Widget> maps; // ここを修正

  HomePage({required this.userId}) : maps = [Map01(userId: userId)]; // ここを修正

  Tab createTab(String name) {
    return Tab(
      child: Text(
        name,
        style: TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget createTabContent(Widget map) {
    return Container(
      alignment: Alignment.center,
      child: map,
      width: double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabNames.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'マッピングウェイ',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: TabBar(
              indicatorColor: Colors.white,
              isScrollable: true,
              tabs: tabNames.map((name) => createTab(name)).toList(),
            ),
          ),
        ),
        body: TabBarView(
          children: maps.map((map) => createTabContent(map)).toList(),
        ),
      ),
    );
  }
}
