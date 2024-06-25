import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/detail/detail_pengajuan/detail_view/izin_sakit_detail_view.dart';
import 'package:project/pengajuan/edit_pengajuan/edit_izin_sakit.dart';
import 'package:project/services/pengajuan/izin_sakit_services/cancelled_izin_sakit_services.dart';
import 'package:project/services/pengajuan/izin_sakit_services/delete_izin_sakit_services.dart';
import 'package:project/services/pengajuan/izin_sakit_services/izin_sakit_input_services.dart';
import 'package:project/services/pengajuan/izin_sakit_services/izin_sakit_list_services.dart';
import 'package:project/util/navkaryawan.dart';

import '../../util/customappbar.dart';
import '../color.dart';
// import '../services/izin_sakit_services/izin_sakit_input_services.dart';

import '../util/navhr.dart';

String judulIzinSakit = '';
String tanggalAwalizin = '';
String tanggalAkhirizin = '';
String jumlahhariizin = '';

class PengajuanIzinSakit extends StatefulWidget {
  const PengajuanIzinSakit({super.key});

  @override
  State<PengajuanIzinSakit> createState() => _PengajuanIzinSakitState();
}

class _PengajuanIzinSakitState extends State<PengajuanIzinSakit> {
  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final TextEditingController tglAwalformController = TextEditingController();
  final TextEditingController tglAkhirformController = TextEditingController();
  final TextEditingController hariController = TextEditingController();

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
    final result = await IzinSakitListServices().izinsakitlist(
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
      drawer: const NavKaryawan(),
      body: ListView(
        padding: const EdgeInsets.only(
          top: 20,
          right: 20,
          left: 20,
          bottom: 50,
        ),
        children: [
          const Text(
            'Izin Sakit',
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
            padding: const EdgeInsets.only(right: 120),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: normalblue,
                  fixedSize: const Size(147, 23)),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        insetPadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Form(
                          key: formkey,
                          child: Container(
                            width: 320,
                            height: 320,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'FORM PEMBUATAN IZIN SAKIT',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Judul Izin Sakit',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: judulSakit,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'harus diisi!!';
                                      }
                                      if (value.length > 30) {
                                        return 'maksimal 30 karakter!!!';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      // border: OutlineInputBorder(
                                      //   borderRadius:
                                      //       BorderRadius.circular(6),
                                      //       borderSide: BorderSide(width: 1),
                                      // ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: const BorderSide(
                                          width: 1,
                                          // color: black0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5,
                                      right: 5,
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 90,
                                          child: Column(
                                            children: const [
                                              SizedBox(
                                                // height: 55,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 10,
                                                  ),
                                                  child: Text(
                                                    'Tanggal Awal',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 90,
                                        ),
                                        SizedBox(
                                          width: 90,
                                          child: Column(
                                            children: const [
                                              SizedBox(
                                                // height: 55,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 10,
                                                  ),
                                                  child: Text(
                                                    'Tanggal Akhir',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  StatefulBuilder(
                                    builder: (context, setState) => Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 130,
                                          height: 35,
                                          child: TextFormField(
                                            keyboardType: TextInputType.none,
                                            controller: tglAwalformController,
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
                                                    var hari = DateFormat.d()
                                                        .format(value!);
                                                    var bulan = DateFormat.M()
                                                        .format(value);
                                                    var bulan2 = DateFormat.M()
                                                        .format(value);
                                                    var tahun = DateFormat.y()
                                                        .format(value);
                                                    tglAwalformController.text =
                                                        '$hari/$bulan/$tahun';
                                                    tanggalAPIa =
                                                        '$tahun-$bulan2-$hari';
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
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 10, 0, 5),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 130,
                                          height: 35,
                                          child: TextFormField(
                                            keyboardType: TextInputType.none,
                                            controller: tglAkhirformController,
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

                                                    var hari = DateFormat.d()
                                                        .format(value!);
                                                    var bulan = DateFormat.M()
                                                        .format(value);
                                                    var bulan2 = DateFormat.M()
                                                        .format(value);
                                                    var tahun = DateFormat.y()
                                                        .format(value);
                                                    tglAkhirformController
                                                            .text =
                                                        '$hari/$bulan/$tahun';
                                                    tanggalAPIb =
                                                        '$tahun-$bulan2-$hari';

                                                    final difference =
                                                        daysBetween(startDate!,
                                                            endData!);
                                                    setState(() {});
                                                  } catch (e) {
                                                    null;
                                                  }
                                                },
                                              );
                                            },
                                            validator: endDateValidator,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            decoration: InputDecoration(
                                              hintText: 'tanggal',
                                              fillColor: Colors.white24,
                                              filled: true,
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 10, 0, 5),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 35,
                                      right: 35,
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(84, 29),
                                              backgroundColor: lightgray,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Batal',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 40,
                                        ),
                                        SizedBox(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(84, 29),
                                              backgroundColor: normalblue,
                                            ),
                                            onPressed: () {
                                              setState(() {});
                                              if (formkey.currentState!
                                                  .validate()) {
                                                IzinSakitServices().izinsakit(
                                                    judulSakit.text,
                                                    tanggalAPIa,
                                                    tanggalAPIb,
                                                    context);
                                                judulIzinSakit =
                                                    judulSakit.text;
                                                tanggalAwalizin =
                                                    tglAwalformController.text;
                                                tanggalAkhirizin =
                                                    tglAkhirformController.text;
                                                jumlahhariizin =
                                                    hariController.text;
                                              }
                                            },
                                            child: const Text(
                                              'Save',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              },
              child: const Text(
                'Buat Izin Sakit',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                DataColumn(
                  label: Text(
                    'Actions',
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailIzinSakitViewTabel(
                                  id: izinSakitList[index]['id'],
                                ),
                              ),
                            );
                          },
                          cells: [
                            DataCell(Text(rowIndex.toString())),
                            DataCell(Text(izinSakitList[index]['judul'])),
                            DataCell(Text(
                                '${izinSakitList[index]['tanggal_awal']} - ${izinSakitList[index]['tanggal_akhir']}')),
                            DataCell(Text(izinSakitList[index]['status'])),
                            izinSakitList[index]['status'] == 'Draft'
                                ? DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: lightgray,
                                          ),
                                          onPressed: () {
                                            // Navigate to another page with the id obtained from the API
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditIzinSakit(
                                                  id: izinSakitList[index]
                                                      ['id'],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: normalred,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Container(
                                                    width: 278,
                                                    height: 270,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Colors.white,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: 31,
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .vertical(
                                                              top: Radius
                                                                  .circular(8),
                                                            ),
                                                            color: Color(
                                                                0xffFFF068),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        Image.asset(
                                                          'assets/warning logo.png',
                                                          width: 80,
                                                          height: 80,
                                                        ),
                                                        const SizedBox(
                                                          height: 7,
                                                        ),
                                                        const Text(
                                                          'Apakah anda yakin\nmenghapus pengajuan ini?',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 24,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                backgroundColor:
                                                                    const Color(
                                                                        0xff949494),
                                                                fixedSize:
                                                                    const Size(
                                                                        100,
                                                                        35.81),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                'Cancel',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 18,
                                                                  color: white0,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 34,
                                                            ),
                                                            ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                backgroundColor:
                                                                    const Color(
                                                                        0xffFFF068),
                                                                fixedSize:
                                                                    const Size(
                                                                        100,
                                                                        35.81),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                DeleteIzinSakitServices()
                                                                    .deleteIzinSakit(
                                                                        izinSakitList[index]
                                                                            [
                                                                            'id'],
                                                                        context);
                                                                fetchData();
                                                              },
                                                              child: const Text(
                                                                'Ya',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 20,
                                                                  color: white0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                : izinSakitList[index]['status'] ==
                                            'Confirmed' ||
                                        izinSakitList[index]['status'] ==
                                            'Approved'
                                    ? DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: lightgray,
                                              ),
                                              onPressed: () {
                                                // Navigate to another page with the id obtained from the API
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditIzinSakit(
                                                      id: izinSakitList[index]
                                                          ['id'],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.cancel_outlined,
                                                color: normalred,
                                              ),
                                              onPressed: () {
                                                // Change the status of the data to 'Cancelled'
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Container(
                                                        width: 278,
                                                        height: 270,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: Colors.white,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 31,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          8),
                                                                ),
                                                                color: Color(
                                                                    0xffFFF068),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            Image.asset(
                                                              'assets/warning logo.png',
                                                              width: 80,
                                                              height: 80,
                                                            ),
                                                            const SizedBox(
                                                              height: 7,
                                                            ),
                                                            const Text(
                                                              'Apakah anda yakin\nmengcancel pengajuan ini?',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 24,
                                                            ),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xff949494),
                                                                    fixedSize:
                                                                        const Size(
                                                                            100,
                                                                            35.81),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Cancel',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          18,
                                                                      color:
                                                                          white0,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 34,
                                                                ),
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xffFFF068),
                                                                    fixedSize:
                                                                        const Size(
                                                                            100,
                                                                            35.81),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    CancelledIzinSakitServices()
                                                                        .cancelledIzinSakit(
                                                                      izinSakitList[
                                                                              index]
                                                                          [
                                                                          'id'],
                                                                      context,
                                                                    );
                                                                    fetchData();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Ya',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          20,
                                                                      color:
                                                                          white0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    : izinSakitList[index]['status'] ==
                                                'Refused' ||
                                            izinSakitList[index]['status'] ==
                                                'Cancelled'
                                        ? DataCell(
                                            // If status is "Refused" or "Cancelled", show an empty container instead of the IconButton
                                            Container(),
                                          )
                                        : DataCell(
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.arrow_forward),
                                              onPressed: () {
                                                // Navigate to another page with the id obtained from the API
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditIzinSakit(
                                                      id: izinSakitList[index]
                                                          ['id'],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
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
