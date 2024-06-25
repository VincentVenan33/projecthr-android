import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/detail/log/log_izin_3_jam.dart';
import 'package:project/detail/need_aprrove/need_confirm_izin_3_jam.dart';
import 'package:project/util/customappbar.dart';
import 'package:project/util/navhr.dart';

import '../color.dart';
import '../services/approval/izin_3_jam_service/hr_get_list_izin_3_jam_service.dart';

class ApprovalIzin3Jam extends StatefulWidget {
  const ApprovalIzin3Jam({super.key});

  @override
  State<ApprovalIzin3Jam> createState() => _ApprovalIzin3JamState();
}

class _ApprovalIzin3JamState extends State<ApprovalIzin3Jam> {
  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final TextEditingController tglAwalformController = TextEditingController();
  final TextEditingController tglAkhirformController = TextEditingController();
  final TextEditingController hariController = TextEditingController();
  DateTime? endData;
  DateTime? startDate;
  String? endDateValidator(value) {
    if (startDate != null && endData == null) {
      return "pilih tanggal!";
    }
    if (startDate == null && endData != null) {
      return 'isi tanggal awal';
    }
    if (endData == null) return "pilih tanggal";
    if (endData!.isBefore(startDate!)) {
      return "tanggal akhir setelah tanggal awal";
    }

    return null;
  }

  String chosevalue = 'All';
  String chosevaluedua = '10';
  String? tglAwal;
  String? tglAkhir;
  String? filterNama;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;

  List<dynamic> dataIzin3Jam = [];

  Future<void> fetchData() async {
    setState(() {
      isFetchingData = true;
    });
    final result = await HrIzin3JamListService().hrIzin3JamList(
      page: page,
      tanggalAwal: tglAwal,
      tanggalAkhir: tglAkhir,
      filterNama: filterNama,
      filterStatus: chosevalue,
      size: pageSize,
    );

    if (result != null && result is List<dynamic>) {
      setState(() {
        dataIzin3Jam = result;
      });
    } else {
      print('Error fetching data');
    }

    setState(() {
      isFetchingData = false;
    });
  }

  void onPageChange(int newPage) {
    setState(() {
      page = newPage;
    });
    fetchData();
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
            'Approval Izin 3 Jam',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: normalblue,
                  fixedSize: const Size(
                    147,
                    23,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NeedConfirmIzin3Jam(),
                    ),
                  );
                },
                child: const Text(
                  'Need Confirm',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: normalblue,
                  fixedSize: const Size(
                    147,
                    23,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LogIzin3jam(),
                    ),
                  );
                },
                child: const Text(
                  'Log',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 14,
          ),
          Row(
            children: [
              const Expanded(
                child: SizedBox(
                  width: 149,
                  child: Text(
                    'Tanggal Awal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: SizedBox(
                  width: 149,
                  height: 48,
                  child: TextFormField(
                    keyboardType: TextInputType.none,
                    controller: tglAwalController,
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
                            tglAwal = '$tahun-$bulan-$hari';
                          } catch (e) {
                            null;
                          }
                        },
                      );
                    },
                    decoration: InputDecoration(
                      hintText: 'tanggal',
                      fillColor: Colors.white24,
                      filled: true,
                      suffixIcon: const Icon(Icons.date_range_outlined),
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 29,
          ),
          Row(
            children: [
              const Expanded(
                child: SizedBox(
                  width: 149,
                  child: Text(
                    'Tanggal Akhir',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: SizedBox(
                  width: 149,
                  height: 48,
                  child: TextFormField(
                    keyboardType: TextInputType.none,
                    controller: tglAkhirController,
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
                            tglAkhir = '$tahun-$bulan-$hari';
                            fetchData();
                          } catch (e) {
                            null;
                          }
                        },
                      );
                    },
                    validator: endDateValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: 'tanggal',
                      fillColor: Colors.white24,
                      filled: true,
                      suffixIcon: const Icon(Icons.date_range_outlined),
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: 149,
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      hintText: 'Status',
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: black0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: lightgray,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: white0,
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
                          chosevalue = value.toString();
                          fetchData();
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: SizedBox(
                  width: 149,
                  height: 48,
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      hintText: 'Show',
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: black0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: lightgreen,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: white0,
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
                          chosevaluedua = value.toString();
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
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Nama Karyawan',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Judul Izin 3 Jam',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Tanggal Izin',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Durasi Izin',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
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
                          DataCell(Text('')),
                        ],
                      ),
                    ]
                  : List<DataRow>.generate(
                      dataIzin3Jam.length,
                      (int index) {
                        // print('TIPE: ${dataIzin3Jam[index]['waktu_awal'].runtimeType}');
                        int rowIndex = (page - 1) * pageSize + index + 1;
                        return DataRow(
                          cells: [
                            DataCell(Text(rowIndex.toString())),
                            DataCell(
                                Text(dataIzin3Jam[index]['nama_karyawan'])),
                            DataCell(Text(dataIzin3Jam[index]['judul'])),
                            DataCell(Text(dataIzin3Jam[index]['tanggal_ijin'])),
                            DataCell(
                              Text(
                                  '${dataIzin3Jam[index]['waktu_awal'].substring(0, 5)} - ${dataIzin3Jam[index]['waktu_akhir'].substring(0, 5)}'),
                            ),
                            DataCell(Text(dataIzin3Jam[index]['status'])),
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_right),
                onPressed: dataIzin3Jam.length >= pageSize
                    ? () => onPageChange(page + 1)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
