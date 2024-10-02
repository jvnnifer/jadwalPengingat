import 'package:flutter/material.dart';
import 'sidebar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(activePage: 'home'),
      appBar: AppBar(
        title: Text('Beranda'),
      ),
    );
  }
}
