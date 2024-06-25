import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import '.../color.dart';
import 'package:project/color.dart';
import 'package:project/detail/Log/detail_log/detail_log_cuti_ttahunan.dart';
import 'package:project/services/approval/cuti_tahunan_services/log_cuti_tahunan_services.dart';
// import '.../util/navbar.dart';
import 'package:project/util/navhr.dart';

import '../../util/customappbar.dart';

class LogCutiTahunan extends StatefulWidget {
  const LogCutiTahunan({super.key});

  @override
  State<LogCutiTahunan> createState() => _LogCutiTahunanState();
}

class _LogCutiTahunanState extends State<LogCutiTahunan> {
  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final TextEditingController hariController = TextEditingController();

  final TextEditingController searchKaryawanController =
      TextEditingController();
  DateTime? endData;
  DateTime? startDate;
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

  String chosevalue = 'All';
  String chosevalue3 = 'Refused,Cancelled,Approved';
  String chosevaluedua = '10';
  String? tgllAwal;
  String? tgllAkhir;
  String? filterNama;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;

  List<dynamic> cutiTahunanList = [];

  void filter(value) async {
    try {
      if (value == 'All') {
        chosevalue = value;
        chosevalue3 = 'Refused,Cancelled,Approved';
      } else {
        chosevalue = value;
        chosevalue3 = chosevalue;
      }
      fetchData();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchData() async {
    setState(() {
      isFetchingData = true;
    });
    final result =
        await LogCutiTahunanListServices().logCutiTahunanListServices(
      page: page,
      tanggalAwal: tgllAwal,
      tanggalAkhir: tgllAkhir,
      filterNama: filterNama,
      filterStatus: chosevalue3,
      size: pageSize,
    );
    if (result != null && result is List<dynamic>) {
      setState(() {
        cutiTahunanList = result;
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
            'Log Cuti Tahunan',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: searchKaryawanController,
            onFieldSubmitted: (value) {
              filterNama = searchKaryawanController.text;
              fetchData();
            },
            decoration: InputDecoration(
              hintText: 'Search Karyawan',
              suffixIcon: const Icon(
                Icons.search,
                color: black0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  width: 1,
                  color: black0,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: 149,
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
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: SizedBox(
                  width: 149,
                  height: 48,
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
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: SizedBox(
                  width: 149,
                  height: 48,
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
                    validator: endDateValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    isExpanded: true,
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
                          // chosevalue = value!;
                          // fetchData();
                          filter(value.toString());
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
                    isExpanded: true,
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
                      cutiTahunanList.length,
                      (int index) {
                        // print('TIPE: ${dataIzin3Jam[index]['waktu_awal'].runtimeType}');
                        int rowIndex = (page - 1) * pageSize + index + 1;
                        return DataRow(
                          onLongPress: () {
                            // Navigate to another page with the id obtained from the API
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CutiTahunanDetailLog(
                                  id: cutiTahunanList[index]['id'],
                                ),
                              ),
                            );
                          },
                          cells: [
                            DataCell(Text(rowIndex.toString())),
                            DataCell(
                                Text(cutiTahunanList[index]['nama_karyawan'])),
                            DataCell(Text(cutiTahunanList[index]['judul'])),
                            DataCell(Text(
                                '${cutiTahunanList[index]['tanggal_awal']} - ${cutiTahunanList[index]['tanggal_akhir']}')),
                            DataCell(Text(cutiTahunanList[index]['status'])),
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
                onPressed: cutiTahunanList.length >= pageSize
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
