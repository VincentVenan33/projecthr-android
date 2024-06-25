import 'package:flutter/material.dart';
import 'package:project/color.dart';

import '../../../services/laporan/pilih_perusahaan/list_perusahaan_perjalanan_dinas_service.dart';
import '../../../util/customappbar.dart';
import '../../../util/navhr.dart';
import '../laporancutidinas.dart';

class PerusahaanPerjalananDinas extends StatefulWidget {
  const PerusahaanPerjalananDinas({super.key});

  @override
  State<PerusahaanPerjalananDinas> createState() =>
      _PerusahaanPerjalananDinasState();
}

class _PerusahaanPerjalananDinasState extends State<PerusahaanPerjalananDinas> {
  Future<List<dynamic>> fetchData() async {
    final result = await GetPerusahaanPerjalananDinasService()
        .getPerusahaanPerjalananDinas();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const NavHr(),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final dataPerusahaanPerjalananDinas = snapshot.data!;
            return ListView.builder(
              itemCount: dataPerusahaanPerjalananDinas.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LaporanCutiDinas(
                          id: dataPerusahaanPerjalananDinas[index]['id'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    height: 200,
                    color: normalblue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListTile(
                          title: Text(
                            dataPerusahaanPerjalananDinas[index]
                                ['nama_perusahaan'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: black0,
                            ),
                          ),
                        ),
                      ],
                    ),
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
