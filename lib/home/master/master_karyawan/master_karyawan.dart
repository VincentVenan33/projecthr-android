import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:project/home/master/master_karyawan/master_karyawan_edit.dart';
import 'package:project/services/master/master_karyawan/master_karyawan_delete.dart';
import 'package:project/services/master/master_karyawan/master_karyawan_list.dart';
import 'package:project/services/master/master_karyawan/master_karyawan_service.dart';
import 'package:project/util/customappbar.dart';

import '../../../color.dart';
import '../../../services/master/master_company/master_company_list.dart';
import '../../../util/navhr.dart';

class MasterKaryawan extends StatefulWidget {
  const MasterKaryawan({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MasterKaryawanState createState() => _MasterKaryawanState();
}

class _MasterKaryawanState extends State<MasterKaryawan> {
  TextEditingController tambahkaryawan = TextEditingController();
  TextEditingController namaperusahaan = TextEditingController();
  TextEditingController namakaryawan = TextEditingController();
  TextEditingController tempatlahir = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController nohp = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController passwordkaryawan = TextEditingController();
  TextEditingController level = TextEditingController();
  TextEditingController posisi = TextEditingController();
  TextEditingController searchKaryawan = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController tanggalBergabungController =
      TextEditingController();
  String? chosevalue;
  String? choselevel;
  String? choseperusahaan;
  bool isPassword = true;
  var selectedItem = '';
  String tanggalAPILahir = '';
  String tanggalAPIBergabung = '';
  final formKey = GlobalKey<FormState>();
  bool isFetchingData = true;
  int page = 1;
  int pageSize = 20;
  String order = 'asc';
  int perusahaanId = 0;
  String? filterNama;

  // AREA TABLE CONTOH
  List<dynamic> dataKaryawan = [];
  final PerusahaanListService _perusahaanListService = PerusahaanListService();
  List<dynamic> _perusahaanList = [];
  String? _selectedPerusahaan;

  Future<void> fetchData() async {
    setState(() {
      isFetchingData = true;
    });
    final result = await KaryawanListService().listkaryawan(
      page: page,
      size: pageSize,
      order: order,
      filterNama: filterNama,
      perusahaan_id: perusahaanId,
    );
    if (result != null && result is List<dynamic>) {
      setState(() {
        dataKaryawan = result;
      });
    } else {
      print('Error fetching data');
    }

    setState(() {
      isFetchingData = false;
    });
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

  @override
  void initState() {
    super.initState();
    _getPerusahaanList();
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
  // AREA TABLE

  @override
  Widget build(BuildContext context) {
    print(dataKaryawan);
    return Scaffold(
        appBar: const CustomAppBar(),
        drawer: const NavHr(),
        body: SafeArea(
            child: ListView(
                padding: const EdgeInsets.only(
                  top: 10,
                  right: 16,
                  left: 16,
                  bottom: 50,
                ),
                children: [
              const Text(
                'Karyawan',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: searchKaryawan,
                onFieldSubmitted: (value) {
                  filterNama = searchKaryawan.text;
                  fetchData();
                },
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.only(
                    right: 170,
                    left: 7,
                  ),
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: const Color(0xff6D9DF9),
                      fixedSize: const Size(194, 45),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Form(
                                  key: formKey,
                                  child: Container(
                                      width: 400,
                                      height: 856,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                      child: Column(children: [
                                        Expanded(
                                          child: ListView(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: 30,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xff6D9DF9),
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top: Radius.circular(8),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              const Text(
                                                'Tambah Karyawan',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 14,
                                                  right: 14,
                                                  bottom: 10,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'Nama Perusahaan',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 50,
                                                      child:
                                                          DropdownButtonFormField<
                                                              String>(
                                                        isExpanded: true,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  10,
                                                                  10,
                                                                  10,
                                                                  5),
                                                          hintText:
                                                              'Pilih perusahaan',
                                                          focusedBorder:
                                                              const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color:
                                                                  Colors.black,
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
                                                        value:
                                                            _selectedPerusahaan,
                                                        items: _perusahaanList
                                                            .map((perusahaan) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: perusahaan[
                                                                'nama_perusahaan'],
                                                            child: Text(perusahaan[
                                                                'nama_perusahaan']),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            _selectedPerusahaan =
                                                                value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'Nama Karyawan',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      controller: namakaryawan,
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            100)
                                                      ],
                                                      validator: (value) {
                                                        if (value!.length < 3 ||
                                                            value.length >
                                                                100) {
                                                          return 'minimal 3 karakter - maksimal 100 karakter';
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 10, 0, 5),
                                                        hintText: '',
                                                        hintStyle:
                                                            const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'Tempat Lahir',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      controller: tempatlahir,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 10, 0, 5),
                                                        hintText: '',
                                                        hintStyle:
                                                            const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'Tanggal Lahir',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: TextFormField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .none,
                                                            controller:
                                                                tanggalLahirController,
                                                            onTap: () {
                                                              showDatePicker(
                                                                context:
                                                                    context,
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
                                                                    var hari = DateFormat
                                                                            .d()
                                                                        .format(
                                                                            value!);
                                                                    var bulan = DateFormat
                                                                            .M()
                                                                        .format(
                                                                            value);
                                                                    var tahun = DateFormat
                                                                            .y()
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
                                                            decoration:
                                                                InputDecoration(
                                                              hintText: '',
                                                              fillColor: Colors
                                                                  .white24,
                                                              filled: true,
                                                              suffixIcon:
                                                                  const Icon(Icons
                                                                      .date_range_outlined),
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
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'Alamat',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            100)
                                                      ],
                                                      validator: (value) {
                                                        if (value!.length < 3 ||
                                                            value.length >
                                                                1000) {
                                                          return 'minimal 3 karakter - maksimal 1000 karakter';
                                                        }
                                                        return null;
                                                      },
                                                      controller: alamat,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 10, 0, 5),
                                                        hintText: '',
                                                        hintStyle:
                                                            const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'No Hp',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.phone,
                                                      controller: nohp,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'No Telepon harus diisi';
                                                        } else if (value
                                                                    .length <
                                                                9 ||
                                                            value.length > 14) {
                                                          return 'No Telepon minimal harus 9 dan maksimal 14 digit';
                                                        }
                                                        return null;
                                                      },
                                                      inputFormatters: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .allow(
                                                          RegExp(r'[0-9+]'),
                                                        ),
                                                        LengthLimitingTextInputFormatter(
                                                          14,
                                                        ),
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 10, 0, 5),
                                                        hintText: '',
                                                        hintStyle:
                                                            const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'Email',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                      ),
                                                    ),
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
                                                      controller: email,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 10, 0, 5),
                                                        hintText: '',
                                                        hintStyle:
                                                            const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'Password Karyawan',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    StatefulBuilder(
                                                      builder:
                                                          (context, setState) =>
                                                              TextFormField(
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(
                                                              20)
                                                        ],
                                                        validator: (value) {
                                                          if (value!.length <
                                                                  8 ||
                                                              value.length >
                                                                  20) {
                                                            return 'minimal 8 karakter - maksimal 20 karakter';
                                                          }
                                                          return null;
                                                        },
                                                        controller:
                                                            passwordkaryawan,
                                                        obscureText: isPassword,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  10, 10, 0, 5),
                                                          suffixIcon:
                                                              IconButton(
                                                            icon: isPassword
                                                                ? const Icon(Icons
                                                                    .visibility_off)
                                                                : const Icon(Icons
                                                                    .visibility),
                                                            onPressed: () {
                                                              setState(() {
                                                                isPassword =
                                                                    !isPassword;
                                                              });
                                                            },
                                                          ),
                                                          hintText: '',
                                                          hintStyle:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                          ),
                                                          fillColor:
                                                              Colors.white,
                                                          filled: true,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'Level',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 90,
                                                      height: 55,
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
                                                        onChanged:
                                                            (String? value) {
                                                          setState(
                                                            () {
                                                              choselevel = value
                                                                  .toString();
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'Posisi',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      controller: posisi,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 10, 0, 5),
                                                        hintText: '',
                                                        hintStyle:
                                                            const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                            color: black0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                      'Tanggal Bergabung',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: TextFormField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .none,
                                                            controller:
                                                                tanggalBergabungController,
                                                            onTap: () {
                                                              showDatePicker(
                                                                context:
                                                                    context,
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
                                                                    var hari = DateFormat
                                                                            .d()
                                                                        .format(
                                                                            value!);
                                                                    var bulan = DateFormat
                                                                            .M()
                                                                        .format(
                                                                            value);
                                                                    var tahun = DateFormat
                                                                            .y()
                                                                        .format(
                                                                            value);
                                                                    tanggalBergabungController
                                                                            .text =
                                                                        '$hari/$bulan/$tahun';
                                                                    tanggalAPIBergabung =
                                                                        '$tahun-$bulan-$hari';
                                                                  } catch (e) {
                                                                    null;
                                                                  }
                                                                },
                                                              );
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              hintText: '',
                                                              fillColor: Colors
                                                                  .white24,
                                                              filled: true,
                                                              suffixIcon:
                                                                  const Icon(Icons
                                                                      .date_range_outlined),
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
                                                      height: 24,
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        backgroundColor:
                                                            const Color(
                                                                0xff6D9DF9),
                                                        fixedSize:
                                                            const Size(120, 43),
                                                      ),
                                                      onPressed: () async {
                                                        if (formKey
                                                            .currentState!
                                                            .validate()) {
                                                          MasterKaryawanInputService()
                                                              .masterInputkaryawan(
                                                            getPerusahaanId(
                                                                _selectedPerusahaan!),
                                                            namakaryawan.text,
                                                            tempatlahir.text,
                                                            tanggalAPILahir,
                                                            alamat.text,
                                                            nohp.text,
                                                            email.text,
                                                            passwordkaryawan
                                                                .text,
                                                            choselevel!,
                                                            posisi.text,
                                                            tanggalAPIBergabung,
                                                            // status.text,
                                                          );
                                                        }
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
                                                                child:
                                                                    Container(
                                                                  width: 400,
                                                                  height: 300,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            30,
                                                                        decoration: const BoxDecoration(
                                                                            color: Color(0xff05DAA7),
                                                                            borderRadius: BorderRadius.vertical(
                                                                              top: Radius.circular(8),
                                                                            )),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            16,
                                                                      ),
                                                                      const Icon(
                                                                        Icons
                                                                            .check_circle,
                                                                        color: Color(
                                                                            0xff05DAA7),
                                                                        size:
                                                                            120,
                                                                      ),
                                                                      const Text(
                                                                        'Data Berhasil di Tambah',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              18,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            24,
                                                                      ),
                                                                      ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          backgroundColor:
                                                                              const Color(0xff05DAA7),
                                                                          fixedSize: const Size(
                                                                              120,
                                                                              43),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => const MasterKaryawan()),
                                                                          );
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          'Oke',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      },
                                                      child: const Text(
                                                        'Save',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]))));
                        },
                      );
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.add),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          'Tambah Karyawan',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: white0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: 90,
                    height: 55,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        hintText: '20',
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
                        '20',
                        '50',
                        '100',
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
                            pageSize = int.parse(chosevalue!);
                            fetchData();
                          },
                        );
                      },
                    ),
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
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Nama Karyawan',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Nama Perusahaan',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Tempat Lahir',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Tanggal Lahir',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Alamat',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'No Hp',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Email',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Level',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Posisi',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Tanggal Bergabung',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Status',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Action',
                            style: TextStyle(color: Colors.white),
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
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                ],
                              ),
                            ]
                          : List<DataRow>.generate(dataKaryawan.length,
                              (int index) {
                              int rowIndex = (page - 1) * pageSize + index + 1;
                              return DataRow(
                                onLongPress: () {
                                  // Navigate to another page with the id obtained from the API
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditMasterKaryawan(
                                        id: dataKaryawan[index]['id'],
                                      ),
                                    ),
                                  );
                                },
                                cells: [
                                  DataCell(Text(rowIndex.toString())),
                                  DataCell(Text(dataKaryawan[index]
                                      ['nama_karyawan'] ??= "")),
                                  DataCell(Text(dataKaryawan[index]
                                      ['nama_perusahaan'] ??= "")),
                                  DataCell(Text(dataKaryawan[index]
                                      ['tempat_lahir'] ??= "")),
                                  DataCell(Text(dataKaryawan[index]
                                      ['tanggal_lahir'] ??= "")),
                                  DataCell(Text(
                                      dataKaryawan[index]['alamat'] ??= "")),
                                  DataCell(Text(
                                      dataKaryawan[index]['no_hp'] ??= "")),
                                  DataCell(Text(
                                      dataKaryawan[index]['email'] ??= "")),
                                  DataCell(Text(
                                      dataKaryawan[index]['level'] ??= "")),
                                  DataCell(Text(
                                      dataKaryawan[index]['posisi'] ??= "")),
                                  DataCell(Text(dataKaryawan[index]
                                      ['tanggal_bergabung'] ??= "")),
                                  DataCell(Text(
                                      dataKaryawan[index]['status'] ??= "")),
                                  DataCell(
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(12, 12),
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditMasterKaryawan(
                                                  id: dataKaryawan[index]['id'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Icon(
                                            Icons.edit,
                                            color: lightgray,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16.33,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(9.33, 12),
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
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
                                                    height: 250,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: white0,
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
                                                            color: normalyellow,
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
                                                          'Apakah yakin ingin\nmenghapus data ini ?',
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
                                                                    lightgray,
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
                                                                  fontSize: 20,
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
                                                                    normalyellow,
                                                                fixedSize:
                                                                    const Size(
                                                                        100,
                                                                        35.81),
                                                              ),
                                                              onPressed: () {
                                                                {
                                                                  KaryawanDeleteService()
                                                                      .KaryawanDelete(
                                                                          dataKaryawan[index]
                                                                              [
                                                                              'id']);
                                                                }
                                                                fetchData();
                                                                Navigator.pop(
                                                                    context);
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return Dialog(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            278,
                                                                        height:
                                                                            250,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                          color:
                                                                              white0,
                                                                        ),
                                                                        child:
                                                                            Column(
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
                                                                              'Data Berhasil di Hapus',
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 20,
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
                                                                                Navigator.pop(context);
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
                                          child: const Icon(
                                            Icons.delete,
                                            color: normalred,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
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
                        onPressed: dataKaryawan.length >= pageSize
                            ? () => onPageChange(page + 1)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ])));
  }
}
