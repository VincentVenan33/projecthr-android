import 'package:flutter/material.dart';
import 'package:project/color.dart';
import 'package:project/detail/laporan/laporan_ijin_3jam.dart';

import '../../../services/laporan/pilih_perusahaan/list_perusahaan_izin_3jam_service.dart';
import '../../../util/customappbar.dart';
import '../../../util/navhr.dart';
import '../laporancutikhusus.dart';

class PerusahaanIzin3Jam extends StatefulWidget {
  const PerusahaanIzin3Jam({super.key});

  @override
  State<PerusahaanIzin3Jam> createState() => _PerusahaanIzin3JamState();
}

class _PerusahaanIzin3JamState extends State<PerusahaanIzin3Jam> {
  Future<List<dynamic>> fetchData() async {
    final result = await GetPerusahaanIzin3JamService().getPerusahaanIzin3Jam();
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
            final dataPerusahaanIzin3Jam = snapshot.data!;
            return ListView.builder(
              itemCount: dataPerusahaanIzin3Jam.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LaporanIzin3Jam(
                          id: dataPerusahaanIzin3Jam[index]['id'],
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
                            dataPerusahaanIzin3Jam[index]['nama_perusahaan'],
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
