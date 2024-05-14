import 'package:flutter/material.dart';
import 'package:new_not_sepeti/models/kategori.dart';
import 'package:new_not_sepeti/utils/database_helper.dart';

class KategoriIslemleri extends StatefulWidget {
  const KategoriIslemleri({super.key});

  @override
  State<KategoriIslemleri> createState() => _KategoriIslemleriState();
}

class _KategoriIslemleriState extends State<KategoriIslemleri> {
  final _databaseHelper = DatabaseHelper();
  List<Kategori> tumKategoriler = <Kategori>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _databaseHelper.kategoriListesiniGetir(),
        builder: (context, AsyncSnapshot<List<Kategori>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Hata: ${snapshot.error}'),
            );
          } else {
            // Future tamamlandı, veriler alındı
            tumKategoriler = snapshot.data!;
            return ListView.builder(
              itemCount: tumKategoriler.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.category),
                    title: Text(tumKategoriler[index].kategoriBaslik!),
                    trailing: IconButton(
                        onPressed: () {
                          _databaseHelper
                              .kategoriSil(tumKategoriler[index].kategoriID!)
                              .then((value) => setState(() {}));
                        },
                        icon: const Icon(Icons.delete)),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
