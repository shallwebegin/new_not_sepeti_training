import 'package:flutter/material.dart';
import 'package:new_not_sepeti/models/not.dart';
import 'package:new_not_sepeti/utils/database_helper.dart';

class Notlar extends StatefulWidget {
  const Notlar({super.key});

  @override
  State<Notlar> createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  late DatabaseHelper databaseHelper;
  late List<Not> tumNotlar;
  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    tumNotlar = <Not>[];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Notlar'),
      ),
      body: FutureBuilder(
        future: databaseHelper.notListesiniGetir(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            tumNotlar = snapshot.data!;
            return ListView.builder(
              itemCount: tumNotlar.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  leading: CircleAvatar(
                    child: Text(tumNotlar[index].notOncelik.toString()),
                  ),
                  title: Text(tumNotlar[index].notBaslik!),
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                  'Oluşturulma Tarih : ${tumNotlar[index].notTarih!}'),
                            ],
                          ),
                          Text(tumNotlar[index].notIcerik!),
                        ],
                      ),
                    )
                  ],
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
