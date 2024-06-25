import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/color.dart';
import 'package:project/home/dashboard/dashboard.dart';
import 'package:project/util/navhr.dart';

import '../../pengajuan/pengajuan_cuti_khusus.dart';
import '../../pengajuan/pengajuan_cuti_tahunan.dart';
import '../../pengajuan/pengajuan_pembatalan_izin_3jam.dart';
import '../../pengajuan/pengajuan_pembatalan_izin_sakit.dart';
import '../../pengajuan/pengajuan_perjalanan_dinas.dart';
import '../../services/dashboard/dashboard_saya_services.dart';
import '../../services/user_service.dart';
import '../../util/customappbar.dart';

class DashboardSaya extends StatefulWidget {
  const DashboardSaya({super.key});

  @override
  State<DashboardSaya> createState() => _DashboardSayaState();
}

class _DashboardSayaState extends State<DashboardSaya> {
  String formattedDate =
      DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const NavHr(),
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
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Dashboard(),
                          ),
                        );
                      },
                      child: const Text(
                        'Dashboard HR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: black0,
                          decoration: TextDecoration.underline,
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
                              future: SisaCutiTahunanSayaService()
                                  .sisaCutiTahunanSaya(),
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
                              future: Izin3JamSayaService().izin3JamSaya(),
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
                              future: CutiTahunanSayaTahunService()
                                  .cutiTahunanSayaTahun(),
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
                              future: CutiKhususSayaTahunService()
                                  .cutiKhususSayaTahun(),
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
                              future: Izin3JamSayaTahunService()
                                  .izin3JamSayaTahun(),
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
                              future: IzinSakitSayaTahunService()
                                  .izinSakitSayaTahun(),
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
                              future: PerjalananDinasSayaTahunService()
                                  .perjalananDinasSayaTahun(),
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
