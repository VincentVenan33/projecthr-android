import 'package:flutter/material.dart';
import 'package:project/color.dart';

import '../../../services/laporan/pilih_perusahaan/list_perusahaan_izin_sakit_service.dart';
import '../../../util/customappbar.dart';
import '../../../util/navhr.dart';
import '../laporan_izin_sakit.dart';
import '../laporancutikhusus.dart';

class PerusahaanIzinSakit extends StatefulWidget {
  const PerusahaanIzinSakit({super.key});

  @override
  State<PerusahaanIzinSakit> createState() => _PerusahaanIzinSakitState();
}

class _PerusahaanIzinSakitState extends State<PerusahaanIzinSakit> {
  Future<List<dynamic>> fetchData() async {
    final result =
        await GetPerusahaanIzinSakitService().getPerusahaanIzinSakit();
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
            final dataPerusahaanIzinSakit = snapshot.data!;
            return ListView.builder(
              itemCount: dataPerusahaanIzinSakit.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LaporanIzinSakit(
                          id: dataPerusahaanIzinSakit[index]['id'],
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
                            dataPerusahaanIzinSakit[index]['nama_perusahaan'],
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
