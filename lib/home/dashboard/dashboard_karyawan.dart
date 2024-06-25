import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/color.dart';
import 'package:project/util/navkaryawan.dart';

import '../../pengajuan/pengajuan_cuti_khusus.dart';
import '../../pengajuan/pengajuan_cuti_tahunan.dart';
import '../../pengajuan/pengajuan_pembatalan_izin_3jam.dart';
import '../../pengajuan/pengajuan_pembatalan_izin_sakit.dart';
import '../../pengajuan/pengajuan_perjalanan_dinas.dart';
import '../../services/dashboard/dashboard_karyawan_sevice.dart';
import '../../services/user_service.dart';
import '../../util/customappbar.dart';

class DashboarKaryawan extends StatefulWidget {
  const DashboarKaryawan({super.key});

  @override
  State<DashboarKaryawan> createState() => _DashboarKaryawanState();
}

class _DashboarKaryawanState extends State<DashboarKaryawan> {
  String formattedDate =
      DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const NavKaryawan(),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future:
              UserNameService().userName('') as Future<Map<String, dynamic>>?,
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            String namaKaryawan = "";
            if (snapshot.hasData) {
              namaKaryawan = snapshot.data!['nama_karyawan'];
            }
            print(namaKaryawan);
            return ListView(
              padding: const EdgeInsets.only(
                left: 16,
                right: 14,
              ),
              children: [
                Row(
                  children: [
                    const TextButton(
                      onPressed: null,
                      child: Text(
                        'Dashboard Karyawan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: black0,
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Text(
                      formattedDate.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: black0,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 152,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/background.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 11,
                              left: 20,
                            ),
                            child: Text(
                              'Selamat Datang, $namaKaryawan !',
                              style: const TextStyle(
                                color: white0,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          Wrap(
                            spacing: 10,
                            alignment: WrapAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      3,
                                    ),
                                    side: const BorderSide(
                                      width: 1,
                                      color: white0,
                                    ),
                                  ),
                                  fixedSize: const Size(
                                    100,
                                    26,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                    3,
                                    3,
                                    2,
                                    3.19,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PengajuanCutiTahunan(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Cuti Tahunan',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      3,
                                    ),
                                    side: const BorderSide(
                                      width: 1,
                                      color: white0,
                                    ),
                                  ),
                                  fixedSize: const Size(
                                    100,
                                    26,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                    3,
                                    3,
                                    2,
                                    3.19,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PengajuanCutiKhusus(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Cuti Khusus',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      3,
                                    ),
                                    side: const BorderSide(
                                      width: 1,
                                      color: white0,
                                    ),
                                  ),
                                  fixedSize: const Size(
                                    100,
                                    26,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                    3,
                                    3,
                                    2,
                                    3.19,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PengajuanIzin3Jam(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Izin 3 Jam',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      3,
                                    ),
                                    side: const BorderSide(
                                      width: 1,
                                      color: white0,
                                    ),
                                  ),
                                  fixedSize: const Size(
                                    110,
                                    26,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                    3,
                                    3,
                                    2,
                                    3.19,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PengajuanIzinSakit(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Izin Sakit',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      3,
                                    ),
                                    side: const BorderSide(
                                      width: 1,
                                      color: white0,
                                    ),
                                  ),
                                  fixedSize: const Size(
                                    110,
                                    26,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                    3,
                                    3,
                                    2,
                                    3.19,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PengajuanPerjalananDinas(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Perjalanan Dinas',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 160,
                          height: 73,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(18, 238, 185, 0.68),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 7,
                              top: 7,
                              bottom: 9,
                              right: 17,
                            ),
                            child: FutureBuilder<int>(
                              future: SisaCutiTahunanKaryawanService()
                                  .sisaCutiTahunanKaryawan(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Sisa Cuti Tahunan',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Tahun ini',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(
                                        flex: 1,
                                      ),
                                      Text(
                                        '${snapshot.data}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 160,
                          height: 73,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 194, 38, 0.58),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 7,
                              top: 7,
                              bottom: 9,
                              right: 17,
                            ),
                            child: FutureBuilder<int>(
                              future:
                                  Izin3JamKaryawanService().izin3JamKaryawan(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Izin 3 Jam',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Bulan ini',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(
                                        flex: 1,
                                      ),
                                      Text(
                                        '${snapshot.data}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  'Total Request Karyawan',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                      (states) => normalgreen,
                    ),
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Tahun ini',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(''),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(
                            Text('Cuti Tahunan'),
                          ),
                          DataCell(
                            FutureBuilder<int>(
                              future: CutiTahunanKaryawanTahunService()
                                  .cutiTahunanKaryawanTahun(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    '${snapshot.data}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(
                            Text('Cuti Khusus'),
                          ),
                          DataCell(
                            FutureBuilder<int>(
                              future: CutiKhususKaryawanTahunService()
                                  .cutiKhususKaryawanTahun(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    '${snapshot.data}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(
                            Text('Izin 3 Jam'),
                          ),
                          DataCell(
                            FutureBuilder<int>(
                              future: Izin3JamKaryawanTahunService()
                                  .izin3JamKaryawanTahun(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    '${snapshot.data}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(
                            Text('Izin Sakit'),
                          ),
                          DataCell(
                            FutureBuilder<int>(
                              future: IzinSakitKaryawanTahunService()
                                  .izinSakitKaryawanTahun(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    '${snapshot.data}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(
                            Text('Perjalanan Dinas'),
                          ),
                          DataCell(
                            FutureBuilder<int>(
                              future: PerjalananDinasKaryawanTahunService()
                                  .perjalananDinasKaryawanTahun(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    '${snapshot.data}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
