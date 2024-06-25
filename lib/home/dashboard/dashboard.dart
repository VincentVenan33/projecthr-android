import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/color.dart';
import 'package:project/home/dashboard/dashboard_saya.dart';
import 'package:project/util/navhr.dart';

import '../../services/dashboard/dashboard_sevices.dart';
import '../../services/user_service.dart';
import '../../util/customappbar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String formattedDate =
      DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.now());

  final jumlahKaryawanService = JumlahKaryawanService();
  final totalCutiKhususService = TotalCutiKhususService();
  final totalIzin3JamService = TotalIzin3JamService();
  final totalCutiTahunanService = TotalCutiTahunanService();
  final totalIzinSakitService = TotalIzinSakitService();

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
                left: 20,
                right: 20,
              ),
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardSaya(),
                          ),
                        );
                      },
                      child: const Text(
                        'Dashboard User',
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
                    color: normalblue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 19,
                          top: 20,
                          right: 25,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Selamat Datang,',
                                  style: TextStyle(
                                    color: white0,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '$namaKaryawan !',
                                  style: const TextStyle(
                                    color: white0,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            Image.asset(
                              'assets/admin.png',
                              width: 77,
                              height: 108,
                            )
                          ],
                        ),
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
                          width: 158,
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
                              future: jumlahKaryawanService.jumlahKaryawan(),
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
                                            'Total Karyawan',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'All Company',
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
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                          width: 158,
                          height: 73,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 38, 168, 0.48),
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
                                  TotalCutiKhususService().totalCutiKhusus(),
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
                                            'Total Cuti Khusus',
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
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                          width: 158,
                          height: 73,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(118, 24, 176, 0.39),
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
                              future: TotalIzin3JamService().totalIzin3Jam(),
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
                                            'Total Izin 3 Jam',
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
                    const Spacer(
                      flex: 1,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 158,
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
                                  TotalCutiTahunanService().totalCutiTahunan(),
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
                                            'Total Cuti Tahunan',
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
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                          width: 158,
                          height: 73,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(18, 80, 238, 0.37),
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
                              future: TotalIzinSakitService().totalIzinSakit(),
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
                                            'Total Izin Sakit',
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
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                          width: 158,
                          height: 73,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 129, 38, 0.64),
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
                              future: TotalDinasService().totalDinas(),
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
                                            'Total Dinas',
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
                  'Total Request Tahunan',
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
                              future: CutiTahunanService().cutiTahunan(),
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
                              future:
                                  CutiKhususTahunService().cutiKhususTahun(),
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
                            Text('Izin 3 jam'),
                          ),
                          DataCell(
                            FutureBuilder<int>(
                              future: Izin3JamTahunService().izin3JamTahun(),
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
                            Text('Izin sakit'),
                          ),
                          DataCell(
                            FutureBuilder<int>(
                              future: IzinSakitTahunService().izinSakitTahun(),
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
                              future: PerjalananDinasTahunService()
                                  .perjalananDinasTahun(),
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
