import 'package:flutter/material.dart';
import 'package:new_not_sepeti/models/notlar.dart';
import 'package:new_not_sepeti/utils/database_helper.dart';
import 'package:new_not_sepeti/widgets/not_guncelle.dart';

class NotListesiDetay extends StatefulWidget {
  const NotListesiDetay({
    super.key,
  });

  @override
  State<NotListesiDetay> createState() => _NotListesiDetayState();
}

class _NotListesiDetayState extends State<NotListesiDetay> {
  final _databaseHelper = DatabaseHelper();
  List<Notlar> tumNotlar = <Notlar>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Listesi'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _databaseHelper.notListesiniGetir(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            tumNotlar = snapshot.data!;
            return ListView.builder(
              itemCount: tumNotlar.length,
              itemBuilder: (context, index) {
                var ezTumNotlar = tumNotlar[index];

                return ListTile(
                  title: Text(ezTumNotlar.notBaslik!),
                  trailing: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width / 2.4,
                    child: Row(
                      children: [
                        ButtonBar(
                          children: [
                            TextButton(
                              onPressed: () {
                                _databaseHelper
                                    .notSil(ezTumNotlar.notID!)
                                    .then((value) => setState(() {}));
                              },
                              child: const Text('Sil'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NotGuncelle(
                                      duzenlenecekNot: ezTumNotlar,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Güncelle'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
