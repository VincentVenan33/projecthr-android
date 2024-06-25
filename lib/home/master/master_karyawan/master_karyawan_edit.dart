// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:project/services/master/master_company/master_company_list.dart';
import 'package:project/services/master/master_karyawan/master_karyawan_detail_service.dart';
import 'package:project/services/master/master_karyawan/master_karyawan_update.dart';

import '../../../../color.dart';
import '../../../../util/customappbar.dart';
import '../../../../util/navhr.dart';
import 'master_karyawan.dart';

class EditMasterKaryawan extends StatefulWidget {
  final int id;
  const EditMasterKaryawan({super.key, required this.id});

  @override
  State<EditMasterKaryawan> createState() => _EditMasterKaryawanState();
}

class _EditMasterKaryawanState extends State<EditMasterKaryawan> {
  final TextEditingController namaPerusahaanController =
      TextEditingController();
  final TextEditingController namaKaryawanController = TextEditingController();
  final selectedPerusahaanController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  TextEditingController passwordkaryawan = TextEditingController();
  final TextEditingController level = TextEditingController();
  final TextEditingController posisiController = TextEditingController();
  Map<String, dynamic> dataMasterKaryawan = {};
  Future<Map<String, dynamic>>? _futureData;
  String? choselevel;

  String? choseperusahaan;
  String? _selectedPerusahaan;
  String tanggalAPILahir = '';
  List<Map<String, dynamic>> levelList = [];

  List<dynamic> _perusahaanList = [];
  final PerusahaanListService _perusahaanListService = PerusahaanListService();
  final formKey = GlobalKey<FormState>();

  // TEST
  Future<void> fetchData() async {
    final result =
        await DetailMasterKaryawanService().detailMasterKaryawan(widget.id);

    dataMasterKaryawan = result;
    _selectedPerusahaan = dataMasterKaryawan['nama_perusahaan'];
    namaKaryawanController.text = dataMasterKaryawan['nama_karyawan'];
    tempatLahirController.text = dataMasterKaryawan['tempat_lahir'];
    tanggalLahirController.text = dataMasterKaryawan['tanggal_lahir'];
    alamatController.text = dataMasterKaryawan['alamat'];
    noHpController.text = dataMasterKaryawan['no_hp'];
    emailController.text = dataMasterKaryawan['email'];
    choselevel = dataMasterKaryawan['level'];
    posisiController.text = dataMasterKaryawan['posisi'];
  }

  int getPerusahaanId(String perusahaanName) {
    final perusahaan = _perusahaanList
        .firstWhere((item) => item['nama_perusahaan'] == perusahaanName);
    return perusahaan['id'];
  }

  Future<void> _getPerusahaanList() async {
    try {
      final perusahaanList = await _perusahaanListService.getPerusahaanList();
      setState(() {
        _perusahaanList = perusahaanList;
      });
    } catch (e) {
      print(e);
    }
  }

  bool isFetchingData = true;

  @override
  void initState() {
    super.initState();
    _getPerusahaanList();

    fetchData().then((_) {
      setState(() {
        isFetchingData = false;
      });
    });
    // _futureData = DetailMasterKaryawanService().detailMasterKaryawan(widget.id)
    //     as Future<Map<String, dynamic>>?;
  }

  @override
  Widget build(BuildContext context) {
    print(dataMasterKaryawan);
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const NavHr(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('Error fetching data');
          } else {
            final dataMasterKaryawan = snapshot.data ?? {};
            return Form(
                key: formKey,
                child: ListView(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    children: [
                      const Text(
                        'Edit Karyawan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                            SizedBox(
                              width: double.infinity,
                              height: 35,
                              child: TextFormField(
                                controller: namaKaryawanController,
                                decoration: InputDecoration(
                                  disabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: black0,
                                    width: 1,
                                  )),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(10, 10, 0, 5),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      width: 1,
                                      color: black0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Nama Perusahaan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: black0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 35,
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                10, 10, 10, 5),
                                        hintText: 'Pilih perusahaan',
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.black,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      value: _selectedPerusahaan ??
                                          (_perusahaanList.isNotEmpty
                                              ? _perusahaanList[0]
                                                  ['nama_perusahaan']
                                              : null),
                                      items: _perusahaanList.map((perusahaan) {
                                        return DropdownMenuItem<String>(
                                          value: perusahaan['nama_perusahaan'],
                                          child: Text(
                                              perusahaan['nama_perusahaan']),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          _selectedPerusahaan = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Tempat Lahir',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: black0,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 35,
                                          child: TextFormField(
                                            controller: tempatLahirController,
                                            decoration: InputDecoration(
                                              disabledBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                color: black0,
                                                width: 1,
                                              )),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 10, 0, 5),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                borderSide: const BorderSide(
                                                  width: 1,
                                                  color: black0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'Tanggal Lahir',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: black0,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                height: 35,
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.none,
                                                  controller:
                                                      tanggalLahirController,
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
                                                          var hari =
                                                              DateFormat.d()
                                                                  .format(
                                                                      value!);
                                                          var bulan =
                                                              DateFormat.M()
                                                                  .format(
                                                                      value);
                                                          var tahun =
                                                              DateFormat.y()
                                                                  .format(
                                                                      value);
                                                          tanggalLahirController
                                                                  .text =
                                                              '$hari/$bulan/$tahun';
                                                          tanggalAPILahir =
                                                              '$tahun-$bulan-$hari';
                                                        } catch (e) {
                                                          null;
                                                        }
                                                      },
                                                    );
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: '',
                                                    fillColor: Colors.white24,
                                                    filled: true,
                                                    suffixIcon: const Icon(Icons
                                                        .date_range_outlined),
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(
                                                            10, 10, 0, 5),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
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
                                                height: 15,
                                              ),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'Alamat',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14,
                                                        color: black0,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      height: 35,
                                                      child: TextFormField(
                                                        controller:
                                                            alamatController,
                                                        decoration:
                                                            InputDecoration(
                                                          disabledBorder:
                                                              const OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                            color: black0,
                                                            width: 1,
                                                          )),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                          ),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  10, 10, 0, 5),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            borderSide:
                                                                const BorderSide(
                                                              width: 1,
                                                              color: black0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                            'No HP',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 14,
                                                              color: black0,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            height: 35,
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  noHpController,
                                                                  validator: (value) {
                                                                  if (value!.isEmpty) {
                                                                    return 'No Telepon harus diisi';
                                                                  } else if (value.length < 9 || value.length > 14) {
                                                                    return 'No Telepon minimal harus 9 dan maksimal 14 digit';
                                                                  }
                                                                  return null;
                                                                },
                                                                inputFormatters: <TextInputFormatter>[
                                                                  FilteringTextInputFormatter.allow(
                                                                    RegExp(r'[0-9+]'),
                                                                  ),
                                                                  LengthLimitingTextInputFormatter(
                                                                    14,
                                                                  ),
                                                                ],
                                                                keyboardType: TextInputType.phone,
                                                              decoration:
                                                                  InputDecoration(
                                                                disabledBorder:
                                                                    const OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                  color: black0,
                                                                  width: 1,
                                                                )),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                ),
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
                                                                              6),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    width: 1,
                                                                    color:
                                                                        black0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const Text(
                                                                  'Email',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        black0,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 35,
                                                                  child:
                                                                      TextFormField(
                                                                        validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return "Email tidak boleh kosong";
                                                        } else if (!value
                                                            .contains('@')) {
                                                          return "Harus menggunakan @";
                                                        } else if (!value
                                                            .contains('.')) {
                                                          return "Harus menggunakan .";
                                                        }
                                                        return null;
                                                      },
                                                                    controller:
                                                                        emailController,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      disabledBorder:
                                                                          const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                        color:
                                                                            black0,
                                                                        width:
                                                                            1,
                                                                      )),
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6),
                                                                      ),
                                                                      contentPadding:
                                                                          const EdgeInsets.fromLTRB(
                                                                              10,
                                                                              10,
                                                                              0,
                                                                              5),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6),
                                                                        borderSide:
                                                                            const BorderSide(
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              black0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .stretch,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const Text(
                                                                      'Level',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            14,
                                                                        color:
                                                                            black0,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    SizedBox(
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          35,
                                                                      child:
                                                                          DropdownButtonFormField(
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  10, 10, 0, 5),
                                                          hintText: 'Level',
                                                          hintStyle:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: black0,
                                                          ),
                                                          focusedBorder:
                                                              const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: black0,
                                                            ),
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                          ),
                                                        ),
                                                        value: choselevel,
                                                        items: <String>[
                                                          'HR',
                                                          'karyawan',
                                                        ].map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Text(value),
                                                          );
                                                        }).toList(),
                                                        onChanged: (String? value) {
                                                        if (value == 'HR' || value == 'karyawan') {
                                                          setState(() {
                                                            choselevel = value.toString();
                                                          });
                                                        }
                                                      },
                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .stretch,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        const Text(
                                                                          'Posisi',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                black0,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              35,
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                posisiController,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              disabledBorder: const OutlineInputBorder(
                                                                                  borderSide: BorderSide(
                                                                                color: black0,
                                                                                width: 1,
                                                                              )),
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
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          15,
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
                                                                            backgroundColor:
                                                                                normalred,
                                                                            fixedSize:
                                                                                const Size(
                                                                              90,
                                                                              29,
                                                                            ),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return Dialog(
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                  child: Container(
                                                                                    width: 278,
                                                                                    height: 270,
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(8),
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Container(
                                                                                          width: double.infinity,
                                                                                          height: 31,
                                                                                          decoration: const BoxDecoration(
                                                                                            borderRadius: BorderRadius.vertical(
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
                                                                                          'Apakah yakin ingin kembali\nhal yang anda edit tidak akan tersimpan ?',
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(
                                                                                            fontWeight: FontWeight.w300,
                                                                                            fontSize: 16,
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 24,
                                                                                        ),
                                                                                        Row(
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                                                                                Navigator.pushReplacement(
                                                                                                  context,
                                                                                                  MaterialPageRoute(
                                                                                                    builder: (context) => const MasterKaryawan(),
                                                                                                  ),
                                                                                                );
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
                                                                          child:
                                                                              const Icon(Icons.cancel_outlined),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              24,
                                                                        ),
                                                                        ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                normalgreen,
                                                                            fixedSize:
                                                                                const Size(
                                                                              90,
                                                                              29,
                                                                            ),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            if (formKey.currentState!.validate()) {
                                                                              EditKaryawanService().editKaryawan(
                                                                                widget.id,
                                                                                getPerusahaanId(_selectedPerusahaan!),
                                                                                namaKaryawanController.text,
                                                                                tempatLahirController.text,
                                                                                tanggalLahirController.text,
                                                                                alamatController.text,
                                                                                noHpController.text,
                                                                                emailController.text,
                                                                                passwordkaryawan.text,
                                                                                choselevel!,
                                                                                posisiController.text,
                                                                              );
                                                                            }
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return Dialog(
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                  child: Container(
                                                                                    width: 278,
                                                                                    height: 250,
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(8),
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Container(
                                                                                          width: double.infinity,
                                                                                          height: 31,
                                                                                          decoration: const BoxDecoration(
                                                                                            borderRadius: BorderRadius.vertical(
                                                                                              top: Radius.circular(8),
                                                                                            ),
                                                                                            color: darkgreen,
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 15,
                                                                                        ),
                                                                                        const Icon(
                                                                                          Icons.check_circle,
                                                                                          color: normalgreen,
                                                                                          size: 80,
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 15,
                                                                                        ),
                                                                                        const Text(
                                                                                          'Nama Perusahaan Telah berhasil di ubah',
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(
                                                                                            fontWeight: FontWeight.w400,
                                                                                            fontSize: 12,
                                                                                            color: black0,
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 24,
                                                                                        ),
                                                                                        ElevatedButton(
                                                                                          style: ElevatedButton.styleFrom(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(8),
                                                                                            ),
                                                                                            backgroundColor: darkgreen,
                                                                                            fixedSize: const Size(120, 45),
                                                                                          ),
                                                                                          onPressed: () {
                                                                                            Navigator.pushReplacement(
                                                                                              context,
                                                                                              MaterialPageRoute(
                                                                                                builder: (context) => const MasterKaryawan(),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                          child: const Text(
                                                                                            'Oke',
                                                                                            style: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: 20,
                                                                                              color: white0,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                          child:
                                                                              const Icon(Icons.save),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ])
                                                        ])
                                                  ])
                                            ])
                                      ])
                                ])
                          ])
                    ]));
          }
        },
      ),
    );
  }
}
