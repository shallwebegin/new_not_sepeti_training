import 'package:flutter/material.dart';
import 'package:new_not_sepeti/pages/kategoriler.dart';
import 'package:new_not_sepeti/pages/not.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.redAccent),
            child: const DrawerHeader(
              child: Text(
                'Not Sepeti',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          ListTile(
            title: const Text('Kategoriler', style: TextStyle(fontSize: 24)),
            leading: const Icon(Icons.category),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const Kategoriler(),
              ));
            },
          ),
          ListTile(
            title: const Text('Notlar', style: TextStyle(fontSize: 24)),
            leading: const Icon(Icons.note),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NotListesiDetay(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
