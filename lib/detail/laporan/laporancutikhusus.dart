import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project/services/laporan/cuti_khusus_service/get_laporan_cuti_khusus_service.dart';
import 'package:project/util/navhr.dart';

import '../../color.dart';
import '../../services/laporan/cuti_khusus_service/export_laporan_cuti_khusus_service.dart';
import '../../util/customappbar.dart';

class LaporanCutiKhusus extends StatefulWidget {
  final int id;
  const LaporanCutiKhusus({super.key, required this.id});

  @override
  State<LaporanCutiKhusus> createState() => _LaporanCutiKhususState();
}

class _LaporanCutiKhususState extends State<LaporanCutiKhusus> {
  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();
  final TextEditingController searchKaryawanController =
      TextEditingController();
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
  // AREA TABLE CONTOH
  List<dynamic> dataCutiKhusus = [];
  List<dynamic> data = [];

  Future<void> fetchData() async {
    setState(() {
      isFetchingData = true;
    });
    final result = await GetLaporanCutiKhususService().getLaporanCutiKhusus(
      widget.id,
      page: page,
      tanggalAwal: tglAwal,
      filterNama: filterNama,
      tanggalAkhir: tglAkhir,
      filterStatus: chosevalue,
      size: pageSize,
    );

    if (result != null && result is List<dynamic>) {
      setState(() {
        dataCutiKhusus = result;
        print(dataCutiKhusus);
      });
    } else {
      print('Error fetching data');
    }

    setState(() {
      isFetchingData = false;
    });

    print('ID WIDGET : ${widget.id}');
    print('ID WIDGET : $dataCutiKhusus');
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

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    var formatter = DateFormat('d MMMM y', 'id');
    return formatter.format(date);
  }

  Future<void> _downloadExcel() async {
    final hasil =
        await DownloadLaporanCutiKhususService().downloadLaporanCutiKhusus(
      widget.id,
      context,
      tanggalAwal: tglAwal,
      filterNama: filterNama,
      tanggalAkhir: tglAkhir,
      filterStatus: chosevalue,
    );
    print('ini hasil bro : $hasil');
    setState(() {
      data = hasil;
    });
    print(data);
    // Create Excel file and sheet
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    CellStyle cellStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      bold: true,
      textWrapping: TextWrapping.WrapText,
    );

    DateTime firstDayOfMonth =
        DateTime(DateTime.now().year, DateTime.now().month, 1);
    DateTime lastDayOfMonth =
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

    String awalTanggal =
        formatDate(firstDayOfMonth.toString().substring(0, 10));
    String akhirTanggal =
        formatDate(lastDayOfMonth.toString().substring(0, 10));

    sheet.merge(
      CellIndex.indexByString('A1'),
      CellIndex.indexByString('G3'),
    );
    var cell1 = sheet.cell(CellIndex.indexByString('A1'));
    cell1.value =
        'Laporan Cuti Khusus\nPT.GOLEK TRUK DOT COM\nTanggal : $awalTanggal - $akhirTanggal';
    cell1.cellStyle = cellStyle;

    sheet.appendRow([
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    ]);
    sheet.appendRow([
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    ]);

    // Add headers to sheet
    sheet.appendRow([
      'No',
      'Nama Karyawan',
      'Jabatan',
      'Judul Cuti',
      'Durasi Cuti',
      'Jumlah Hari',
      'Status'
    ]);

    // Add data to sheet
    var no = 1;
    for (var i = 0; i < data.length; i++) {
      var item = data[i];
      var durasiCuti =
          '${formatDate(item['tanggal_awal'])} - ${formatDate(item['tanggal_akhir'])}';
      sheet.appendRow([
        no.toString(),
        item['nama_karyawan'],
        item['posisi'],
        item['judul'],
        durasiCuti,
        item['jumlah_hari'].toString(),
        item['status']
      ]);
      no++;
    }

    // Save Excel file to device storage
    var bytes = excel.encode();
    var dir = await getExternalStorageDirectory();
    var file = '${dir?.path}/LaporanCutiKhusus.xlsx';
    await File(file).writeAsBytes(bytes!, flush: true);
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const NavHr(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          children: [
            const Text(
              'Laporan Cuti Khusus',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: black0,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: searchKaryawanController,
              onFieldSubmitted: (value) {
                filterNama = searchKaryawanController.text;
                fetchData();
              },
              decoration: InputDecoration(
                hintText: 'Search Karyawan',
                fillColor: Colors.white24,
                filled: true,
                suffixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Tanggal Awal',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
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
                        borderRadius: BorderRadius.circular(6),
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
                Flexible(
                  child: SizedBox(
                    height: 50,
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 10, 10, 5),
                        hintText: 'Status',
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.greenAccent,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      value: chosevalue,
                      items: <String>[
                        'All',
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
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Tanggal Akhir',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  child: Column(
                    children: [
                      TextFormField(
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'tanggal',
                          fillColor: Colors.white24,
                          filled: true,
                          suffixIcon: const Icon(Icons.date_range_outlined),
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 10, 0, 5),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 10, 10, 5),
                            hintText: '10',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.greenAccent,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          value: chosevaluedua,
                          items: <String>[
                            '10',
                            '25',
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
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        backgroundColor: darkgreen,
                        fixedSize: const Size(90, 45),
                      ),
                      onPressed: () {
                        // showDialog(
                        //   context: context,
                        //   builder: (context) {
                        //     return Dialog(
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(8),
                        //       ),
                        //       child: Container(
                        //         width: 278,
                        //         height: 250,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(8),
                        //           color: Colors.white,
                        //         ),
                        //         child: Column(
                        //           children: [
                        //             Container(
                        //               width: double.infinity,
                        //               height: 31,
                        //               decoration: const BoxDecoration(
                        //                 borderRadius: BorderRadius.vertical(
                        //                   top: Radius.circular(8),
                        //                 ),
                        //                 color: darkgreen,
                        //               ),
                        //             ),
                        //             const SizedBox(
                        //               height: 15,
                        //             ),
                        //             const Icon(
                        //               Icons.check_circle,
                        //               color: normalgreen,
                        //               size: 80,
                        //             ),
                        //             const SizedBox(
                        //               height: 15,
                        //             ),
                        //             const Text(
                        //               'File Berhasil di Export',
                        //               style: TextStyle(
                        //                 fontWeight: FontWeight.w400,
                        //                 fontSize: 20,
                        //                 color: black0,
                        //               ),
                        //             ),
                        //             const SizedBox(
                        //               height: 24,
                        //             ),
                        //             ElevatedButton(
                        //               style: ElevatedButton.styleFrom(
                        //                 shape: RoundedRectangleBorder(
                        //                   borderRadius:
                        //                       BorderRadius.circular(8),
                        //                 ),
                        //                 backgroundColor: darkgreen,
                        //                 fixedSize: const Size(120, 45),
                        //               ),
                        //               onPressed: () {
                        //                 Navigator.pop(context);
                        //               },
                        //               child: const Text(
                        //                 'Oke',
                        //                 style: TextStyle(
                        //                   fontWeight: FontWeight.w500,
                        //                   fontSize: 20,
                        //                   color: white0,
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // );
                        _downloadExcel();
                        print('cekckeckc');
                      },
                      child: const Text(
                        'Export',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: white0,
                        ),
                      ),
                    ),
                  ],
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
                      'Jabatan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Judul Cuti',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Durasi Cuti',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Jumlah Hari',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Status',
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
                          ],
                        ),
                      ]
                    : List<DataRow>.generate(
                        dataCutiKhusus.length,
                        (int index) {
                          // print('TIPE: ${dataIzin3Jam[index]['waktu_awal'].runtimeType}');
                          int rowIndex = (page - 1) * pageSize + index + 1;
                          return DataRow(
                            cells: [
                              DataCell(Text(rowIndex.toString())),
                              DataCell(
                                  Text(dataCutiKhusus[index]['nama_karyawan'])),
                              DataCell(Text(dataCutiKhusus[index]['posisi'])),
                              DataCell(Text(dataCutiKhusus[index]['judul'])),
                              DataCell(
                                Text(
                                    '${dataCutiKhusus[index]['tanggal_awal']} - ${dataCutiKhusus[index]['tanggal_akhir']}'),
                              ),
                              DataCell(Text(dataCutiKhusus[index]['jumlah_hari']
                                  .toString())),
                              DataCell(Text(dataCutiKhusus[index]['status'])),
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
                  onPressed: dataCutiKhusus.length >= pageSize
                      ? () => onPageChange(page + 1)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
