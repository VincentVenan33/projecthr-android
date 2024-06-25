import 'package:flutter/material.dart';
import 'package:project/color.dart';

import '../../../services/laporan/pilih_perusahaan/list_perusahaan_cuti_khusus_service.dart';
import '../../../util/customappbar.dart';
import '../../../util/navhr.dart';
import '../laporancutikhusus.dart';

class PerusahaanCutiKhusus extends StatefulWidget {
  const PerusahaanCutiKhusus({super.key});

  @override
  State<PerusahaanCutiKhusus> createState() => _PerusahaanCutiKhususState();
}

class _PerusahaanCutiKhususState extends State<PerusahaanCutiKhusus> {
  Future<List<dynamic>> fetchData() async {
    final result =
        await GetPerusahaanCutiKhususService().getPerusahaanCutiKhusus();
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
            final dataPerusahaanCutiKhusus = snapshot.data!;
            return ListView.builder(
              itemCount: dataPerusahaanCutiKhusus.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LaporanCutiKhusus(
                          id: dataPerusahaanCutiKhusus[index]['id'],
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
                            dataPerusahaanCutiKhusus[index]['nama_perusahaan'],
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
