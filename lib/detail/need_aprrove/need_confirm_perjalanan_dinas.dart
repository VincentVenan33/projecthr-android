import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../color.dart';
import '../../services/approval/perjalanan_dinas_service/perjalanan_dinas_approved_service.dart';
import '../../services/approval/perjalanan_dinas_service/perjalanan_dinas_list_service.dart';
import '../../services/approval/perjalanan_dinas_service/perjalanan_dinas_refused_service.dart';
import '../../util/customappbar.dart';
import '../../util/navhr.dart';
import 'detail_need_approve/detail_need_confirm_perjalanan_dinas.dart';

class NeedConfirmPerjalananDinas extends StatefulWidget {
  const NeedConfirmPerjalananDinas({super.key});

  @override
  State<NeedConfirmPerjalananDinas> createState() =>
      _NeedConfirmPerjalananDinasState();
}

class _NeedConfirmPerjalananDinasState
    extends State<NeedConfirmPerjalananDinas> {
  final TextEditingController searchKaryawanController =
      TextEditingController();
  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();

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

  String chosevalue = 'Confirmed';
  String chosevaluedua = '10';
  String? filterNama;
  String? tglAwal;
  String? tglAkhir;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;

  List<dynamic> dataNeedConfirmPerjalananDinas = [];

  Future<void> fetchData() async {
    setState(() {
      isFetchingData = true;
    });
    final result = await ApprovalPerjalananDinasListService()
        .getApprovalPerjalananDinasList(
      page: page,
      filterNama: filterNama,
      tanggalAwal: tglAwal,
      tanggalAkhir: tglAkhir,
      filterStatus: chosevalue,
      size: pageSize,
    );
    if (result != null && result is List<dynamic>) {
      setState(() {
        dataNeedConfirmPerjalananDinas = result;
      });
    } else {
      debugPrint('Error fetching data');
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
            'Need Confirm Perjalanan Dinas',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 15,
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
                    controller: tanggalAwalController,
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
                            tanggalAwalController.text = '$hari/$bulan/$tahun';
                            tglAwal = '$tahun-$bulan-$hari';
                            fetchData();
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
            height: 15,
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
                    controller: tanggalAkhirController,
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
                            tanggalAkhirController.text = '$hari/$bulan/$tahun';
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
            height: 15,
          ),
          const SizedBox(
            height: 15,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateColor.resolveWith(
                (states) => normalgreen,
              ),
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'No',
                    style: TextStyle(
                      color: white0,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Nama Karyawan',
                    style: TextStyle(
                      color: white0,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Judul Cuti Khusus',
                    style: TextStyle(
                      color: white0,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Durasi Cuti',
                    style: TextStyle(
                      color: white0,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Jumlah Cuti',
                    style: TextStyle(
                      color: white0,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(
                      color: white0,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Action',
                    style: TextStyle(
                      color: Colors.white,
                    ),
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
                          DataCell(Text('')),
                        ],
                      ),
                    ]
                  : List<DataRow>.generate(
                      dataNeedConfirmPerjalananDinas.length,
                      (int index) {
                        int rowIndex = (page - 1) * pageSize + index + 1;
                        return DataRow(
                          onLongPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailNeedConfirmPerjalananDinas(
                                  id: dataNeedConfirmPerjalananDinas[index]
                                      ['id'],
                                ),
                              ),
                            );
                          },
                          cells: <DataCell>[
                            DataCell(Text(rowIndex.toString())),
                            DataCell(Text(dataNeedConfirmPerjalananDinas[index]
                                ['nama_karyawan'])),
                            DataCell(Text(dataNeedConfirmPerjalananDinas[index]
                                ['judul'])),
                            DataCell(Text(
                                '${dataNeedConfirmPerjalananDinas[index]['tanggal_awal']} - ${dataNeedConfirmPerjalananDinas[index]['tanggal_akhir']}')),
                            DataCell(Text(dataNeedConfirmPerjalananDinas[index]
                                    ['jumlah_hari']
                                .toString())),
                            DataCell(Text(dataNeedConfirmPerjalananDinas[index]
                                ['status'])),
                            DataCell(
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(108, 22),
                                      backgroundColor: lightred,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Container(
                                              width: 278,
                                              height: 270,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white,
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    height: 31,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        top: Radius.circular(8),
                                                      ),
                                                      color: Color(0xffFFF068),
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
                                                    'Apakah anda yakin\nmenerima pengajuan ini?',
                                                    textAlign: TextAlign.center,
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
                                                        style: ElevatedButton
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
                                                          fixedSize: const Size(
                                                              100, 35.81),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 18,
                                                            color: white0,
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
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          backgroundColor:
                                                              const Color(
                                                                  0xffFFF068),
                                                          fixedSize: const Size(
                                                              100, 35.81),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          PerjalananDinasRefusedService()
                                                              .perjalananDinasRefused(
                                                                  dataNeedConfirmPerjalananDinas[
                                                                          index]
                                                                      ['id'],
                                                                  context);
                                                          Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      500), () {
                                                            fetchData();
                                                          });
                                                        },
                                                        child: const Text(
                                                          'Ya',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
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
                                    child: const Text(
                                      'Refuse',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: black0),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 11,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(108, 22),
                                      backgroundColor: lightgreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Container(
                                              width: 278,
                                              height: 270,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white,
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    height: 31,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        top: Radius.circular(8),
                                                      ),
                                                      color: Color(0xffFFF068),
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
                                                    'Apakah anda yakin\nmenerima pengajuan ini?',
                                                    textAlign: TextAlign.center,
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
                                                        style: ElevatedButton
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
                                                          fixedSize: const Size(
                                                              100, 35.81),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 18,
                                                            color: white0,
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
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          backgroundColor:
                                                              const Color(
                                                                  0xffFFF068),
                                                          fixedSize: const Size(
                                                              100, 35.81),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          PerjalanDinasApprovedService()
                                                              .perjalanDinasApproved(
                                                                  dataNeedConfirmPerjalananDinas[
                                                                          index]
                                                                      ['id'],
                                                                  context);
                                                          Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      500), () {
                                                            fetchData();
                                                          });
                                                        },
                                                        child: const Text(
                                                          'Ya',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
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
                                    child: const Text(
                                      'Approve',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: black0),
                                    ),
                                  ),
                                ],
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
                onPressed: dataNeedConfirmPerjalananDinas.length >= pageSize
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
