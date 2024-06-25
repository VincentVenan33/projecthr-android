// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

import '../../color.dart';
import '../detail/detail_pengajuan_hr/detail_view_hr/cuti_khusus_detail_hr.dart';
import '../services/pengajuan_hr_services/cuti_khusus/hr_cuti_khusus_canceled_service.dart';
import '../services/pengajuan_hr_services/cuti_khusus/hr_cuti_khusus_delete_service.dart';
import '../services/pengajuan_hr_services/cuti_khusus/hr_cuti_khusus_input_service.dart';
import '../services/pengajuan_hr_services/cuti_khusus/hr_cuti_khusus_list_service.dart';
import '../services/pengajuan_hr_services/cuti_khusus/hr_list_karyawan_service.dart';
import '../util/customappbar.dart';
import '../util/navhr.dart';
import 'hr_edit_pengajuan/hr_edit_cuti_khusus.dart';

class HRPengajuanCutiKhusus extends StatefulWidget {
  const HRPengajuanCutiKhusus({super.key});

  @override
  State<HRPengajuanCutiKhusus> createState() => _HRPengajuanCutiKhususState();
}

class _HRPengajuanCutiKhususState extends State<HRPengajuanCutiKhusus> {
  final TextEditingController namaKaryawanController = TextEditingController();
  final TextEditingController judulcutiController = TextEditingController();
  final TextEditingController addtanggalAwalController =
      TextEditingController();
  final TextEditingController addtanggalAkhirController =
      TextEditingController();
  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();
  DateTime? endData;
  DateTime? startDate;
  String tanggalAPIAwal = '';
  String tanggalAPIAkhir = '';
  int? selectedId;
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

  var durasi = 0;
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    durasi = (to.difference(from).inHours / 24).round();
    return durasi;
  }

  final formkey = GlobalKey<FormState>();

  String chosevalue = 'All';
  String chosevaluedua = '10';
  String? filterNama;
  String? tglAwal;
  String? tglAkhir;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;

  List<dynamic> dataCutiKhusus = [];

  Future<void> fetchData() async {
    setState(() {
      isFetchingData = true;
    });
    final result = await HRCutiKhususListService().gethrCutiKhususList(
      page: page,
      filterNama: filterNama,
      tanggalAwal: tglAwal,
      tanggalAkhir: tglAkhir,
      filterStatus: chosevalue,
      size: pageSize,
    );
    if (result != null && result is List<dynamic>) {
      setState(() {
        dataCutiKhusus = result;
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
    debugPrint('$dataCutiKhusus');
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const NavHr(),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            return ListView(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 50,
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'HR Cuti Khusus',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            6,
                          ),
                        ),
                        fixedSize: const Size(
                          190,
                          23,
                        ),
                        backgroundColor: normalblue,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              insetPadding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Form(
                                key: formkey,
                                child: Container(
                                  width: 320,
                                  height: 370,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: white0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 20,
                                          left: 11,
                                          right: 11,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            const Text(
                                              'Form Pembuatan Cuti Khusus',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 19,
                                            ),
                                            const Text(
                                              'Nama Karyawan',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: black0,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            TypeAheadFormField<dynamic>(
                                              textFieldConfiguration:
                                                  TextFieldConfiguration(
                                                controller:
                                                    namaKaryawanController,
                                                decoration: InputDecoration(
                                                  hintText:
                                                          'Pilih Karyawan',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.all(10),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 1,
                                                      color: black0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              suggestionsCallback:
                                                  (pattern) async {
                                                final ListKaryawanService
                                                    service =
                                                    ListKaryawanService();
                                                final List<dynamic>
                                                    suggestions =
                                                    await service.listKaryawan(
                                                  filterNama: pattern,
                                                );
                                                return suggestions;
                                              },
                                              itemBuilder: (context,
                                                  dynamic suggestion) {
                                                return ListTile(
                                                  title: Text(suggestion[
                                                      'nama_karyawan']),
                                                );
                                              },
                                              onSuggestionSelected:
                                                  (dynamic suggestion) {
                                                selectedId = suggestion['id'];
                                                namaKaryawanController.text =
                                                    suggestion['nama_karyawan'];
                                                debugPrint(
                                                    'ID Karyawan : $selectedId');
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Masukkan Nama Karyawan';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            const Text(
                                              'Judul Cuti Khusus',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: black0,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            TextFormField(
                                              controller: judulcutiController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Judul harus di isi';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                hintText: 'Judul Cuti Khusus',
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            StatefulBuilder(
                                              builder: (context, setState) =>
                                                  Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Tanggal Awal',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 1,
                                                      ),
                                                      SizedBox(
                                                        width: 110,
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .none,
                                                          controller:
                                                              addtanggalAwalController,
                                                          onTap: () {
                                                            showDatePicker(
                                                              context: context,
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              firstDate:
                                                                  DateTime(
                                                                      2000),
                                                              lastDate:
                                                                  DateTime(
                                                                      2100),
                                                            ).then(
                                                              (value) {
                                                                try {
                                                                  startDate =
                                                                      value;
                                                                  var hari = DateFormat
                                                                          .d()
                                                                      .format(
                                                                          value!);
                                                                  var bulan = DateFormat
                                                                          .M()
                                                                      .format(
                                                                          value);
                                                                  var bulan2 =
                                                                      DateFormat
                                                                              .M()
                                                                          .format(
                                                                              value);
                                                                  var tahun = DateFormat
                                                                          .y()
                                                                      .format(
                                                                          value);
                                                                  addtanggalAwalController
                                                                          .text =
                                                                      '$hari/$bulan/$tahun';
                                                                  tanggalAPIAwal =
                                                                      '$tahun-$bulan2-$hari';
                                                                } catch (e) {
                                                                  null;
                                                                }
                                                              },
                                                            );
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: 'tanggal',
                                                            fillColor:
                                                                Colors.white24,
                                                            filled: true,
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    10,
                                                                    10,
                                                                    0,
                                                                    5),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              borderSide:
                                                                  const BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 13,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Tanggal Akhir',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 1,
                                                      ),
                                                      SizedBox(
                                                        width: 110,
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .none,
                                                          controller:
                                                              addtanggalAkhirController,
                                                          onTap: () {
                                                            showDatePicker(
                                                              context: context,
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              firstDate:
                                                                  DateTime(
                                                                      2000),
                                                              lastDate:
                                                                  DateTime(
                                                                      2100),
                                                            ).then(
                                                              (value) {
                                                                try {
                                                                  endData =
                                                                      value;

                                                                  var hari = DateFormat
                                                                          .d()
                                                                      .format(
                                                                          value!);
                                                                  var bulan = DateFormat
                                                                          .M()
                                                                      .format(
                                                                          value);
                                                                  var bulan2 =
                                                                      DateFormat
                                                                              .M()
                                                                          .format(
                                                                              value);
                                                                  var tahun = DateFormat
                                                                          .y()
                                                                      .format(
                                                                          value);
                                                                  addtanggalAkhirController
                                                                          .text =
                                                                      '$hari/$bulan/$tahun';
                                                                  tanggalAPIAkhir =
                                                                      '$tahun-$bulan2-$hari';
                                                                  final difference =
                                                                      daysBetween(
                                                                          startDate!,
                                                                          endData!);
                                                                  setState(
                                                                      () {});
                                                                } catch (e) {
                                                                  null;
                                                                }
                                                              },
                                                            );
                                                          },
                                                          validator:
                                                              endDateValidator,
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: 'tanggal',
                                                            fillColor:
                                                                Colors.white24,
                                                            filled: true,
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    10,
                                                                    10,
                                                                    0,
                                                                    5),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              borderSide:
                                                                  const BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 13,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Hari',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 1,
                                                      ),
                                                      Container(
                                                        width: 50,
                                                        height: 48,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          '$durasi',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 17,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: lightgray,
                                                    fixedSize:
                                                        const Size(90, 28),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: white0,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 65,
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: normalblue,
                                                    fixedSize:
                                                        const Size(90, 28),
                                                  ),
                                                  onPressed: () async {
                                                    if (formkey.currentState!
                                                        .validate()) {
                                                      debugPrint(
                                                          'ID TERPILIH : $selectedId');
                                                      HRInputCutiKhususService()
                                                          .hrInputCutiKhusus(
                                                        selectedId!,
                                                        judulcutiController
                                                            .text,
                                                        tanggalAPIAwal,
                                                        tanggalAPIAkhir,
                                                        context,
                                                      );
                                                      judulcutiController.text;
                                                      addtanggalAwalController;
                                                      addtanggalAkhirController;
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  300), () {
                                                        fetchData();
                                                      });
                                                    }
                                                  },
                                                  child: const Text(
                                                    'Save',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: white0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.add),
                          SizedBox(
                            width: 11,
                          ),
                          Text(
                            'Buat Cuti Khusus',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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
                                      tanggalAwalController.text =
                                          '$hari/$bulan/$tahun';
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
                                suffixIcon:
                                    const Icon(Icons.date_range_outlined),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 5),
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
                                      tanggalAkhirController.text =
                                          '$hari/$bulan/$tahun';
                                      tglAkhir = '$tahun-$bulan-$hari';
                                      fetchData();
                                    } catch (e) {
                                      null;
                                    }
                                  },
                                );
                              },
                              validator: endDateValidator,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: 'tanggal',
                                fillColor: Colors.white24,
                                filled: true,
                                suffixIcon:
                                    const Icon(Icons.date_range_outlined),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 5),
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
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                hintText: 'Status',
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: black0)),
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
                                    chosevalue = value!;
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
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                hintText: 'Show',
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: black0)),
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
                      height: 15,
                    ),
                    StatefulBuilder(
                      builder: (context, setState) => SingleChildScrollView(
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
                                'Judul Cuti',
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
                                'Jumlah Hari',
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
                                  color: white0,
                                ),
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
                                  dataCutiKhusus.length,
                                  (int index) {
                                    int rowIndex =
                                        (page - 1) * pageSize + index + 1;
                                    return DataRow(
                                      onLongPress: () {
                                        // Navigate to another page with the id obtained from the API
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HRCutiKhususDetail(
                                              id: dataCutiKhusus[index]['id'],
                                            ),
                                          ),
                                        );
                                      },
                                      cells: [
                                        DataCell(Text(rowIndex.toString())),
                                        DataCell(Text(dataCutiKhusus[index]
                                            ['nama_karyawan'])),
                                        DataCell(Text(
                                            dataCutiKhusus[index]['judul'])),
                                        DataCell(Text(
                                            '${dataCutiKhusus[index]['tanggal_awal']} - ${dataCutiKhusus[index]['tanggal_akhir']}')),
                                        DataCell(Text(dataCutiKhusus[index]
                                                ['jumlah_hari']
                                            .toString())),
                                        DataCell(Text(
                                            dataCutiKhusus[index]['status'])),
                                        dataCutiKhusus[index]['status'] ==
                                                'Draft'
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
                                                                HREditCutiKhusus(
                                                              id: dataCutiKhusus[
                                                                  index]['id'],
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
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: Container(
                                                                width: 278,
                                                                height: 270,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          31,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.vertical(
                                                                          top: Radius.circular(
                                                                              8),
                                                                        ),
                                                                        color: Color(
                                                                            0xffFFF068),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          12,
                                                                    ),
                                                                    Image.asset(
                                                                      'assets/warning logo.png',
                                                                      width: 80,
                                                                      height:
                                                                          80,
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 7,
                                                                    ),
                                                                    const Text(
                                                                      'Apakah anda yakin\nmenghapus pengajuan ini?',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          24,
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
                                                                              ElevatedButton.styleFrom(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            backgroundColor:
                                                                                const Color(0xff949494),
                                                                            fixedSize:
                                                                                const Size(100, 35.81),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                            fetchData();
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Cancel',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 18,
                                                                              color: white0,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              34,
                                                                        ),
                                                                        ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            backgroundColor:
                                                                                const Color(0xffFFF068),
                                                                            fixedSize:
                                                                                const Size(100, 35.81),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                            HRCutiKhususDeleteService().hrcutiKhususDelete(dataCutiKhusus[index]['id'],
                                                                                context);
                                                                            Future.delayed(const Duration(milliseconds: 500),
                                                                                () {
                                                                              fetchData();
                                                                            });
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Ya',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w400,
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
                                            : dataCutiKhusus[index]['status'] ==
                                                        'Confirmed' ||
                                                    dataCutiKhusus[index]
                                                            ['status'] ==
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
                                                                builder:
                                                                    (context) =>
                                                                        HREditCutiKhusus(
                                                                  id: dataCutiKhusus[
                                                                          index]
                                                                      ['id'],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons
                                                                .cancel_outlined,
                                                            color: normalred,
                                                          ),
                                                          onPressed: () {
                                                            // Change the status of the data to 'Cancelled'
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Dialog(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    width: 278,
                                                                    height: 270,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              31,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.vertical(
                                                                              top: Radius.circular(8),
                                                                            ),
                                                                            color:
                                                                                Color(0xffFFF068),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              12,
                                                                        ),
                                                                        Image
                                                                            .asset(
                                                                          'assets/warning logo.png',
                                                                          width:
                                                                              80,
                                                                          height:
                                                                              80,
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              7,
                                                                        ),
                                                                        const Text(
                                                                          'Apakah anda yakin\nmengcancel pengajuan ini?',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            fontSize:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              24,
                                                                        ),
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                ),
                                                                                backgroundColor: const Color(0xff949494),
                                                                                fixedSize: const Size(100, 35.81),
                                                                              ),
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Text(
                                                                                'Cancel',
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.w400,
                                                                                  fontSize: 18,
                                                                                  color: white0,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 34,
                                                                            ),
                                                                            ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                ),
                                                                                backgroundColor: const Color(0xffFFF068),
                                                                                fixedSize: const Size(100, 35.81),
                                                                              ),
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                                HRCutiKhususCancelledService().hrcutiKhususCancelled(
                                                                                  dataCutiKhusus[index]['id'],
                                                                                  context,
                                                                                );
                                                                                Future.delayed(const Duration(milliseconds: 500), () {
                                                                                  fetchData();
                                                                                });
                                                                              },
                                                                              child: const Text(
                                                                                'Ya',
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.w400,
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
                                                : dataCutiKhusus[index]
                                                                ['status'] ==
                                                            'Refused' ||
                                                        dataCutiKhusus[index]
                                                                ['status'] ==
                                                            'Cancelled'
                                                    ? DataCell(
                                                        // If status is "Refused" or "Cancelled", show an empty container instead of the IconButton
                                                        Container(),
                                                      )
                                                    : DataCell(
                                                        IconButton(
                                                          icon: const Icon(Icons
                                                              .arrow_forward),
                                                          onPressed: () {
                                                            // Navigate to another page with the id obtained from the API
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        HREditCutiKhusus(
                                                                  id: dataCutiKhusus[
                                                                          index]
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
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_left),
                          onPressed:
                              page > 1 ? () => onPageChange(page - 1) : null,
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
                          onPressed: dataCutiKhusus.length >= pageSize
                              ? () => onPageChange(page + 1)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
