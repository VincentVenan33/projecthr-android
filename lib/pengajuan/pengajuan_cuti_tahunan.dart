import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/detail/detail_pengajuan/detail_view/cuti_tahunan_detail.dart';
import 'package:project/pengajuan/edit_pengajuan/edit_cuti_tahunan.dart';
import 'package:project/services/pengajuan/cuti_tahunan_services/cancelled_cuti_tahunan_services.dart';
import 'package:project/services/pengajuan/cuti_tahunan_services/cuti_tahunan_input_services.dart';
import 'package:project/services/pengajuan/cuti_tahunan_services/cuti_tahunan_list_services.dart';
import 'package:project/services/pengajuan/cuti_tahunan_services/delete_cuti_tahunan_services.dart';
import 'package:project/services/pengajuan/cuti_tahunan_services/total_cuti_tahunan_services.dart';
import 'package:project/util/navkaryawan.dart';

import '../../util/customappbar.dart';
import '../color.dart';

// String judulCutiTahunan = '';
// String tanggalAwalCutiTahunan = '';
// String tanggalAkhirCutiTahunan = '';
// String jumlahhariCutiTahunan = '';

class PengajuanCutiTahunan extends StatefulWidget {
  const PengajuanCutiTahunan({super.key});

  @override
  State<PengajuanCutiTahunan> createState() => _PengajuanCutiTahunanState();
}

class _PengajuanCutiTahunanState extends State<PengajuanCutiTahunan> {
  final formkey = GlobalKey<FormState>();

  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final TextEditingController tglAwalformController = TextEditingController();
  final TextEditingController tglAkhirformController = TextEditingController();
  // final TextEditingController hariController = TextEditingController();
  final TextEditingController sisaCutiController = TextEditingController();
  final TextEditingController judulCutiTahunanController =
      TextEditingController();

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

    return null; // optional while already return type is null
  }

  var durasi = 0;
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    durasi = (to.difference(from).inHours / 24).round() + 1;

    return durasi;
  }

  String chosevalue = 'All';
  String chosevaluedua = '10';
  String? tglAwal;
  String? tglAkhir;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;
  int currentYear = 0;

  List<dynamic> cutiTahunanList = [];

  Future<void> fetchData() async {
    setState(() {
      isFetchingData = true;
    });
    final result = await CutiTahunanListServices().cutiTahunanlist(
      page: page,
      tanggalAwal: tglAwal,
      tanggalAkhir: tglAkhir,
      filterStatus: chosevalue,
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
    DateTime now = DateTime.now();
    currentYear = now.year;
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
            'Cuti Tahunan',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 323,
            height: 63,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: normalgreen,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: FutureBuilder(
                future: TotalKuotaCutiTahunanService()
                    .totalKuotaCutiTahunan(currentYear),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'Sisa Cuti Tahunan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: black0,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Tahun ini',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 80,
                        ),
                        Text(
                          '${snapshot.data}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                            color: black0,
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
                            height: 384,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: FutureBuilder(
                                future: TotalKuotaCutiTahunanService()
                                    .totalKuotaCutiTahunan(currentYear),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return Column(
                                      children: [
                                        const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'FORM PEMBUATAN CUTI TAHUNAN',
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
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 250,
                                                child: Row(
                                                  children: [
                                                    const SizedBox(
                                                      // height: 55,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 10,
                                                        ),
                                                        child: Text(
                                                          'Sisa Cuti Tahunan',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    // const Spacer(
                                                    //   flex: 0,
                                                    // ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 16,
                                                      ),
                                                      child: Text(
                                                        '${snapshot.data}',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Judul Cuti Tahunan',
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
                                          keyboardType: TextInputType.text,
                                          controller:
                                              judulCutiTahunanController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Harus Diisi!!';
                                            }
                                            if (value.length > 30) {
                                              return 'maksimal 30 karakter!!!';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
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
                                                        padding:
                                                            EdgeInsets.only(
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
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: 90,
                                                child: Column(
                                                  children: const [
                                                    SizedBox(
                                                      // height: 55,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: 28,
                                                child: Column(
                                                  children: const [
                                                    SizedBox(
                                                      // height: 55,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 10,
                                                        ),
                                                        child: Text(
                                                          'Hari',
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
                                                width: 100,
                                                height: 35,
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.none,
                                                  controller:
                                                      tglAwalformController,
                                                  onTap: () {
                                                    showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2100),
                                                    ).then(
                                                      (value) {
                                                        try {
                                                          startDate = value;
                                                          var hari =
                                                              DateFormat.d()
                                                                  .format(
                                                                      value!);
                                                          var bulan =
                                                              DateFormat.M()
                                                                  .format(
                                                                      value);
                                                          var bulan2 =
                                                              DateFormat.M()
                                                                  .format(
                                                                      value);
                                                          var tahun =
                                                              DateFormat.y()
                                                                  .format(
                                                                      value);
                                                          tglAwalformController
                                                                  .text =
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
                                                        const EdgeInsets
                                                                .fromLTRB(
                                                            10, 10, 0, 5),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      borderSide:
                                                          const BorderSide(
                                                        width: 1,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 100,
                                                height: 35,
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.none,
                                                  controller:
                                                      tglAkhirformController,
                                                  onTap: () {
                                                    showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2100),
                                                    ).then(
                                                      (value) {
                                                        try {
                                                          endData = value;

                                                          var hari =
                                                              DateFormat.d()
                                                                  .format(
                                                                      value!);
                                                          var bulan =
                                                              DateFormat.M()
                                                                  .format(
                                                                      value);
                                                          var bulan2 =
                                                              DateFormat.M()
                                                                  .format(
                                                                      value);
                                                          var tahun =
                                                              DateFormat.y()
                                                                  .format(
                                                                      value);
                                                          tglAkhirformController
                                                                  .text =
                                                              '$hari/$bulan/$tahun';
                                                          tanggalAPIb =
                                                              '$tahun-$bulan2-$hari';
                                                          final difference =
                                                              daysBetween(
                                                                  startDate!,
                                                                  endData!);
                                                          setState(() {});
                                                        } catch (e) {
                                                          null;
                                                        }
                                                      },
                                                    );
                                                  },
                                                  validator: endDateValidator,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  decoration: InputDecoration(
                                                    hintText: 'tanggal',
                                                    fillColor: Colors.white24,
                                                    filled: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(
                                                            10, 10, 0, 5),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      borderSide:
                                                          const BorderSide(
                                                        width: 1,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: 50,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '$durasi',
                                                  style: const TextStyle(
                                                    fontSize: 17,
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    fixedSize:
                                                        const Size(84, 29),
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
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 40,
                                              ),
                                              SizedBox(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    fixedSize:
                                                        const Size(84, 29),
                                                    backgroundColor: normalblue,
                                                  ),
                                                  onPressed: () {
                                                    if (formkey.currentState!
                                                        .validate()) {
                                                      CutiTahunanInputServices()
                                                          .cutiTahunanInput(
                                                        judulCutiTahunanController
                                                            .text,
                                                        tanggalAPIa,
                                                        tanggalAPIb,
                                                        context,
                                                      );
                                                      // judulCutiTahunan =
                                                      //     judulCutiTahunanController
                                                      //         .text;
                                                      // tanggalAwalCutiTahunan =
                                                      //     tglAwalformController
                                                      //         .text;
                                                      // tanggalAkhirCutiTahunan =
                                                      //     tglAkhirformController
                                                      //         .text;
                                                      // jumlahhariCutiTahunan =
                                                      //     durasi;
                                                    }
                                                  },
                                                  child: const Text(
                                                    'Save',
                                                    textAlign: TextAlign.center,
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
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              },
              child: const Text(
                'Buat Cuti Tahunan',
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
              Expanded(
                child: SizedBox(
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
                            tglAwal = '$tahun-$bulan-$hari';
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
              Expanded(
                child: SizedBox(
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
                            tglAkhir = '$tahun-$bulan-$hari';
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
                  width: 155,
                  height: 55,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 55,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            hintText: 'Status',
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: black0,
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: black0)),
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
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: SizedBox(
                  width: 155,
                  height: 55,
                  child: SizedBox(
                    height: 55,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        hintText: 'show',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: black0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: black0)),
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
                    'Judul Cuti Tahunan',
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
                  label: Padding(
                    padding: EdgeInsets.only(
                      left: 50,
                    ),
                    child: Text(
                      'Action',
                      style: TextStyle(
                        color: white0,
                      ),
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
                        ],
                      ),
                    ]
                  : List<DataRow>.generate(
                      cutiTahunanList.length,
                      (int index) {
                        int rowIndex = (page - 1) * pageSize + index + 1;
                        return DataRow(
                          onLongPress: () {
                            // Navigate to another page with the id obtained from the API
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CutiTahunanDetail(
                                  id: cutiTahunanList[index]['id'],
                                ),
                              ),
                            );
                          },
                          cells: [
                            DataCell(Text(rowIndex.toString())),
                            DataCell(Text(cutiTahunanList[index]['judul'])),
                            DataCell(Text(
                                '${cutiTahunanList[index]['tanggal_awal']} - ${cutiTahunanList[index]['tanggal_akhir']}')),
                            DataCell(Text(cutiTahunanList[index]['jumlah_hari']
                                .toString())),
                            DataCell(Text(cutiTahunanList[index]['status'])),
                            cutiTahunanList[index]['status'] == 'Draft'
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
                                                    EditCutiTahunan(
                                                  id: cutiTahunanList[index]
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
                                                                Future.delayed(
                                                                    const Duration(
                                                                        milliseconds:
                                                                            500),
                                                                    () {
                                                                  fetchData();
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                                DeleteCutiTahunanService()
                                                                    .deleteCutiTahunan(
                                                                        cutiTahunanList[index]
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
                                : cutiTahunanList[index]['status'] ==
                                            'Confirmed' ||
                                        cutiTahunanList[index]['status'] ==
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
                                                        EditCutiTahunan(
                                                      id: cutiTahunanList[index]
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
                                                                    Future.delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                500),
                                                                        () {
                                                                      fetchData();
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                    CutiTahunanCancelledServices()
                                                                        .cutiThaunanCancelled(
                                                                      cutiTahunanList[
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
                                    : cutiTahunanList[index]['status'] ==
                                                'Refused' ||
                                            cutiTahunanList[index]['status'] ==
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
                                                        EditCutiTahunan(
                                                      id: cutiTahunanList[index]
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
                onPressed: cutiTahunanList.length >= pageSize
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
