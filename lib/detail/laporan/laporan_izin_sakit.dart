import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../color.dart';
import '../../services/laporan/izin_sakit_service/export_laporan_izin_sakit_service.dart';
import '../../services/laporan/izin_sakit_service/get_laporan_izin_sakit_service.dart';
import '../../util/customappbar.dart';
import '../../util/navhr.dart';

class LaporanIzinSakit extends StatefulWidget {
  final int id;
  const LaporanIzinSakit({super.key, required this.id});

  @override
  State<LaporanIzinSakit> createState() => _LaporanIzinSakitState();
}

class _LaporanIzinSakitState extends State<LaporanIzinSakit> {
  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();
  final TextEditingController searchKaryawanController =
      TextEditingController();
  DateTime? endData;
  DateTime? startDate;
  String? endDateValidator(value) {
    if (startDate != null && endData == null) {
      return "pilih tanggal";
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
  List<dynamic> dataIzinSakit = [];
  List<dynamic> data = [];

  Future<void> fetchData() async {
    setState(() {
      isFetchingData = true;
    });
    final result = await GetLaporanIzinSakitService().getLaporanIzinSakit(
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
        dataIzinSakit = result;
        print(dataIzinSakit);
      });
    } else {
      print('Error fetching data');
    }

    setState(() {
      isFetchingData = false;
    });

    print('ID WIDGET : ${widget.id}');
    print('ID WIDGET : $dataIzinSakit ');
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
        await DownloadLaporanIzinSakitService().downloadLaporanIzinSakit(
      widget.id,
      context,
      tanggalAwal: tglAwal,
      filterNama: filterNama,
      tanggalAkhir: tglAkhir,
      filterStatus: chosevalue,
    );
    print('ini hasil : $hasil');
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
        'Laporan Izin Sakit \nPT.GOLEK TRUK DOT COM\nTanggal : $awalTanggal - $akhirTanggal';
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
      'Judul Izin',
      'Durasi Izin',
      'Jumlah Hari',
      'Status'
    ]);

    // Add data to sheet
    var no = 1;
    for (var i = 0; i < data.length; i++) {
      var item = data[i];
      var durasiIzin =
          '${formatDate(item['tanggal_awal'])} - ${formatDate(item['tanggal_akhir'])}';
      sheet.appendRow([
        no.toString(),
        item['nama_karyawan'],
        item['posisi'],
        item['judul'],
        durasiIzin,
        item['jumlah_hari'].toString(),
        item['status']
      ]);
      no++;
    }
    final status = await Permission.storage.request();
    if (status.isGranted) {
      print('diijinkan');
      var bytes = excel.encode();
      var dir = await getExternalStorageDirectory();
      Directory generalDownloadDir = Directory('/storage/emulated/0/Download');

      var file = '${generalDownloadDir.path}/LaporanIzinSakit.xlsx';
      await File(file).writeAsBytes(bytes!, flush: true);
    } else if (status.isDenied) {
      print('tidak diijinkan');
    } else if (status.isPermanentlyDenied) {
      // permission permanently denied, navigate to app settings
      print('tertolak');
      openAppSettings();
    }
    // Save Excel file to device storage
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
              'Laporan Izin Sakit',
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
                hintText: 'Search',
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
                        _downloadExcel();
                        print('hemmmm');
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
                  (states) => normalgreen,
                ),
                headingTextStyle: const TextStyle(
                  fontSize: 15,
                  color: white0,
                ),
                dataTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: black0,
                ),
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'No',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Nama Karyawan',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Jabatan',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Judul Izin',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Durasi Izin',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Jumlah Hari',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Status',
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
                        dataIzinSakit.length,
                        (int index) {
                          // print('TIPE: ${dataIzinSakit[index]['waktu_awal'].runtimeType}');
                          int rowIndex = (page - 1) * pageSize + index + 1;
                          return DataRow(
                            cells: [
                              DataCell(Text(rowIndex.toString())),
                              DataCell(
                                  Text(dataIzinSakit[index]['nama_karyawan'])),
                              DataCell(Text(dataIzinSakit[index]['posisi'])),
                              DataCell(Text(dataIzinSakit[index]['judul'])),
                              DataCell(
                                Text(
                                    '${dataIzinSakit[index]['tanggal_awal']} - ${dataIzinSakit[index]['tanggal_akhir']}'),
                              ),
                              DataCell(Text(dataIzinSakit[index]['jumlah_hari']
                                  .toString())),
                              DataCell(Text(dataIzinSakit[index]['status'])),
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
                  onPressed: dataIzinSakit.length >= pageSize
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
