import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'widgets/list_chat.widget.dart';
import 'widgets/list_open.widget.dart';

class HomeAtendentePage extends StatefulWidget {
  @override
  _HomeAtendentePageState createState() => _HomeAtendentePageState();
}

class _HomeAtendentePageState extends State<HomeAtendentePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Chat ",
              style: TextStyle(
                fontFamily: "Helvetica",
                fontSize: 24,
              ),
            ),
            Image.asset(
              'assets/images/logo-way-2.png',
              fit: BoxFit.contain,
              height: 24,
            ),
          ],
        ),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(
              text: "Atendidos",
            ),
            Tab(
              text: "Em aberto",
            ),
          ],
        ),
      ),
      body: TabBarView(
        dragStartBehavior: DragStartBehavior.down,
        controller: _tabController,
        children: <Widget>[
          ListChatWidget(),
          ListOpenWidget(),
        ],
      ),
    );
  }
}
