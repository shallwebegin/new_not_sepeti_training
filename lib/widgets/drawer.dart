// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:new_not_sepeti/pages/kategoriler.dart';
import 'package:new_not_sepeti/pages/notlar.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5,
            decoration: BoxDecoration(color: Colors.red),
            child: DrawerHeader(
              child: Text(
                'Not Sepeti',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Kategoriler'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Kategoriler(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Notlar'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Notlar(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
