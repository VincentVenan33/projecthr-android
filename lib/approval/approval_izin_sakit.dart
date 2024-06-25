import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/detail/log/log_izin_sakit.dart';
import 'package:project/detail/need_aprrove/need_confirm_Izin_sakit.dart';
import 'package:project/services/approval/izin_sakit_services/izin_sakit_approve_list_services.dart';
import 'package:project/util/navhr.dart';

import '../../util/customappbar.dart';
import '../color.dart';

String judulIzinSakit = '';
String tanggalAwalizin = '';
String tanggalAkhirizin = '';
String jumlahhariizin = '';

class ApprovalIzinSakit extends StatefulWidget {
  const ApprovalIzinSakit({super.key});

  @override
  State<ApprovalIzinSakit> createState() => _ApprovalIzinSakitState();
}

class _ApprovalIzinSakitState extends State<ApprovalIzinSakit> {
  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final TextEditingController judulSakit = TextEditingController();
  final formkey = GlobalKey<FormState>();

  DateTime? endData;
  DateTime? startDate;
  String tanggalAPIa = '';
  String tanggalAPIb = '';
  String? endDateValidator(value) {
    if (startDate != null && endData == null) {
      return "pilih tanggal!";
    }
    if (endData == null) return "pilih tanggal";
    if (endData!.isBefore(startDate!)) {
      return "tanggal akhir setelah tanggal awal";
    }

    return null;
  }

  var durasi = 0;
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    durasi = (to.difference(from).inHours / 24).round();
    return durasi;
  }

  var selectedItem = '';
  String chosevalue = 'All';
  String chosevaluedua = '10';
  String? tgllAwal;
  String? tgllAkhir;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;

  List<dynamic> izinSakitList = [];

  Future<void> fetchData() async {
    setState(() {
      isFetchingData = true;
    });
    final result = await IzinSakitApproveListServices().izinSakitApprovedList(
      page: page,
      tanggalAwal: tgllAwal,
      tanggalAkhir: tgllAkhir,
      filterStatus: chosevalue,
      size: pageSize,
    );
    if (result != null && result is List<dynamic>) {
      setState(() {
        izinSakitList = result;
      });
    } else {
      print('Error fetching data');
    }

    setState(() {
      isFetchingData = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((_) {
      setState(() {
        isFetchingData = false;
      });
    });
  }

  void onPageChange(int newPage) {
    setState(() {
      page = newPage;
    });
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const NavHr(),
      body: ListView(
        padding: const EdgeInsets.only(
          top: 20,
          right: 20,
          left: 20,
          bottom: 50,
        ),
        children: [
          const Text(
            'Approval Izin Sakit',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 0, left: 5),
            child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: normalblue,
                      fixedSize: const Size(147, 23)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const NeedConfirmIzinSakit()));
                  },
                  child: const Text(
                    'Need Confirm',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: normalblue,
                      fixedSize: const Size(147, 23)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LogIzinSakit(),
                      ),
                    );
                  },
                  child: const Text(
                    'Log',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 145,
                child: Column(
                  children: const [
                    SizedBox(
                      height: 55,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          'Tanggal Awal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 155,
                height: 55,
                child: TextFormField(
                  controller: tglAwalController,
                  keyboardType: TextInputType.none,
                  decoration: InputDecoration(
                    hintText: 'tanggal awal',
                    fillColor: Colors.white24,
                    filled: true,
                    suffixIcon: const Icon(Icons.date_range_outlined),
                    contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        width: 1,
                        color: black0,
                      ),
                    ),
                  ),
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then(
                      (value) {
                        try {
                          startDate = value;
                          var hari = DateFormat.d().format(value!);
                          var bulan = DateFormat.M().format(value);
                          var tahun = DateFormat.y().format(value);
                          tglAwalController.text = '$hari/$bulan/$tahun';
                          tgllAwal = '$tahun-$bulan-$hari';
                          fetchData();
                        } catch (e) {
                          null;
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 145,
                child: Column(
                  children: const [
                    SizedBox(
                      height: 55,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          'Tanggal akhir',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 155,
                height: 55,
                child: TextFormField(
                  controller: tglAkhirController,
                  keyboardType: TextInputType.none,
                  decoration: InputDecoration(
                    hintText: 'tanggal akhir',
                    fillColor: Colors.white24,
                    filled: true,
                    suffixIcon: const Icon(Icons.date_range_outlined),
                    contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        width: 1,
                        color: black0,
                      ),
                    ),
                  ),
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then(
                      (value) {
                        try {
                          endData = value;

                          var hari = DateFormat.d().format(value!);
                          var bulan = DateFormat.M().format(value);
                          var tahun = DateFormat.y().format(value);
                          tglAkhirController.text = '$hari/$bulan/$tahun';
                          tgllAkhir = '$tahun-$bulan-$hari';
                          fetchData();
                        } catch (e) {
                          null;
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: 149,
                  // height: 55,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: black0)),
                      hintText: 'Status',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: black0,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: black0,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: black0,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    value: chosevalue,
                    items: <String>[
                      'All',
                      'Draft',
                      'Confirmed',
                      'Approved',
                      'Refused',
                      'Cancelled',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(
                        () {
                          // chosevalue = value.toString();
                          chosevalue = value!;
                          fetchData();
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: SizedBox(
                  width: 149,
                  // height: 55,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: black0)),
                      hintText: 'Show',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: black0,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: black0,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: black0,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    value: chosevaluedua,
                    items: <String>[
                      '10',
                      '20',
                      '50',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(
                        () {
                          // chosevaluedua = value.toString();
                          chosevaluedua = value!;
                          pageSize = int.parse(chosevaluedua);
                          fetchData();
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateColor.resolveWith(
                  (states) => const Color(0xff12EEB9)),
              columns: const [
                DataColumn(
                    label: Text(
                  'No',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  'Nama Karyawan',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  'Judul Izin Sakit',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  'Tanggal Izin',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  'Status',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )),
              ],
              rows: isFetchingData
                  ? [
                      const DataRow(
                        cells: [
                          DataCell(CircularProgressIndicator()),
                          DataCell(Text('Loading...')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                        ],
                      ),
                    ]
                  : List<DataRow>.generate(
                      izinSakitList.length,
                      (int index) {
                        // print('TIPE: ${dataIzin3Jam[index]['waktu_awal'].runtimeType}');
                        int rowIndex = (page - 1) * pageSize + index + 1;
                        return DataRow(
                          onLongPress: () {
                            // Navigate to another page with the id obtained from the API
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => Ijin3JamDetail(
                            //       id: dataIzin3Jam[index]['id'],
                            //     ),
                            //   ),
                            // );
                          },
                          cells: [
                            DataCell(Text(rowIndex.toString())),
                            DataCell(
                                Text(izinSakitList[index]['nama_karyawan'])),
                            DataCell(Text(izinSakitList[index]['judul'])),
                            DataCell(Text(
                                '${izinSakitList[index]['tanggal_awal']} - ${izinSakitList[index]['tanggal_akhir']}')),
                            DataCell(Text(izinSakitList[index]['status'])),
                          ],
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_left),
                onPressed: page > 1 ? () => onPageChange(page - 1) : null,
                // onPressed: page > 1 ? () => onPageChange(page - 1) : null,
              ),
              Container(
                width: 30,
                height: 30,
                color: normalblue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$page',
                      style: const TextStyle(
                          fontSize: 14,
                          color: white0,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: izinSakitList.length >= pageSize
                    ? () => onPageChange(page + 1)
                    : null,
                icon: const Icon(Icons.keyboard_arrow_right),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
