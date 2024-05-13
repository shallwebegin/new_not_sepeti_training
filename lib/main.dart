import 'package:flutter/material.dart';
import 'package:new_not_sepeti/models/kategori.dart';
import 'package:new_not_sepeti/utils/database_helper.dart';
import 'package:new_not_sepeti/widgets/custom_drawer.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: NotSepeti(),
    );
  }
}

class NotSepeti extends StatelessWidget {
  NotSepeti({super.key});
  final _databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Not Sepeti'),
        centerTitle: true,
        elevation: 4,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ButtonBar(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _kategoriEkle(context);
                  },
                  child: Text('Kategori Ekle'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Not Ekle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _kategoriEkle(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? eklenecekKategoriAdi;
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Kategori Ekle'),
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  onSaved: (newValue) {
                    eklenecekKategoriAdi = newValue!;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Kategori Adı Giriniz',
                      labelText: 'Kategori Adı'),
                ),
              ),
            ),
            ButtonBar(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Sil'),
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _databaseHelper
                          .kategoriEkle(Kategori(eklenecekKategoriAdi));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Kaydet'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
