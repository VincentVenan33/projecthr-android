// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/pengajuan/pengajuan_perjalanan_dinas.dart';

import '../../../color.dart';
import '../../../util/customappbar.dart';
import '../../../util/navhr.dart';
import '../../services/pengajuan/perjalanan_dinas_service/perjalanan_dinas_confirm_service.dart';
import '../../services/pengajuan/perjalanan_dinas_service/perjalanan_dinas_delete_attachment_service.dart';
import '../../services/pengajuan/perjalanan_dinas_service/perjalanan_dinas_detail.dart';
import '../../services/pengajuan/perjalanan_dinas_service/perjalanan_dinas_download_service.dart';
import '../../services/pengajuan/perjalanan_dinas_service/perjalanan_dinas_edit_service.dart';
import '../../services/pengajuan/perjalanan_dinas_service/perjalanan_dinas_get_attachment_service.dart';
import '../../services/pengajuan/perjalanan_dinas_service/perjalanan_dinas_input_attachment_service.dart';

class EditPerjalananDinas extends StatefulWidget {
  final int id;
  const EditPerjalananDinas({super.key, required this.id});

  @override
  State<EditPerjalananDinas> createState() => _EditPerjalananDinasState();
}

class _EditPerjalananDinasState extends State<EditPerjalananDinas> {
  final TextEditingController judulcutiController = TextEditingController();
  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();
  final TextEditingController jumlahHariController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  DateTime? endData;
  DateTime? startDate;
  String tanggalAPIAwal = '';
  String tanggalAPIAkhir = '';
  final disabledUpload = {'Refused', 'Cancelled'};
  String? endDateValidator(value) {
    if (startDate != null && endData == null) {
      return "pilih tanggal!";
    }
    if (startDate == null && endData != null) {
      return 'isi tanggal awal';
    }
    if (endData != null && endData!.isBefore(startDate!)) {
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

  void updateJumlahHari() {
    if (startDate != null && endData != null) {
      final difference = daysBetween(startDate!, endData!);
      setState(() {
        jumlahHariController.text = '$difference';
      });
    }
  }

  FilePickerResult? result;
  bool isLoading = false;
  List<File>? files;
  int maxFiles = 5;
  int maxFileSize = 10485760;

  String? errorMessage;
  void pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });

      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'pdf', 'jpg'],
        allowMultiple: true,
      );
      if (result != null) {
        List<PlatformFile>? platformFiles = result!.files;
        List<File> newFiles = [];
        bool hasInvalidFile = false;
        for (PlatformFile platformFile in platformFiles) {
          if (platformFile.size <= maxFileSize) {
            File newFile = File(platformFile.path!);
            newFiles.add(newFile);
          } else {
            debugPrint('File yang diperbolehkan hanya 10mb');
            hasInvalidFile = true;
          }
        }
        if (hasInvalidFile) {
          setState(() {
            errorMessage = 'File yang diperbolehkan hanya 10mb';
          });
        } else if ((files?.length ?? 0) + newFiles.length <= maxFiles) {
          files ??= [];
          files!.addAll(newFiles);
          debugPrint('Selected files: $files');
          setState(() {
            errorMessage = null;
          });
        } else {
          debugPrint('File telah mencapai batas');
          setState(() {
            errorMessage = 'File telah mencapai batas';
          });
          // Add only the first 5 files if more than 5 files are selected
          int maxNewFiles = maxFiles - (files?.length ?? 0);
          if (maxNewFiles > 0) {
            files ??= [];
            files!.addAll(newFiles.take(maxNewFiles));
          }
        }
      }

      setState(() {
        fetchData();
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Map<String, dynamic> dataPerjalananDinas = {};
  Future<Map<String, dynamic>>? _futureData;
  List<Map<String, dynamic>> filesData = [];
  List<Map<String, dynamic>> combinedList = [];

  // TEST
  Future<void> fetchData() async {
    final result =
        await DetailPerjalananDinasService().detailPerjalananDinas(widget.id);

    dataPerjalananDinas = result;
    DateTime? endData = DateTime.parse(dataPerjalananDinas['tanggal_akhir']);
    DateTime? startDate = DateTime.parse(dataPerjalananDinas['tanggal_awal']);

    judulcutiController.text = dataPerjalananDinas['judul'];
    tanggalAwalController.text = dataPerjalananDinas['tanggal_awal'];
    tanggalAkhirController.text = dataPerjalananDinas['tanggal_akhir'];
    jumlahHariController.text = dataPerjalananDinas['jumlah_hari'].toString();

    // Format Tanggal Awal
    final inputDateAwal = dataPerjalananDinas['tanggal_awal'];
    final inputDateFormatAwal = DateFormat('yyyy-MM-dd');
    final outputDateFormatAwal = DateFormat('d/M/y');
    final inputdateAwal = inputDateFormatAwal.parse(inputDateAwal);
    final outputDateStringAwal = outputDateFormatAwal.format(inputdateAwal);
    tanggalAwalController.text = outputDateStringAwal;
    tanggalAPIAwal = dataPerjalananDinas['tanggal_awal'];

    // Format Tanggal Akhir
    final inputDateAkhir = dataPerjalananDinas['tanggal_akhir'];
    final inputDateFormatAkhir = DateFormat('yyyy-MM-dd');
    final outputDateFormatAkhir = DateFormat('d/M/y');
    final inputdateAkhir = inputDateFormatAkhir.parse(inputDateAkhir);
    final outputDateStringAkhir = outputDateFormatAkhir.format(inputdateAkhir);
    tanggalAkhirController.text = outputDateStringAkhir;
    tanggalAPIAkhir = dataPerjalananDinas['tanggal_akhir'];

    final resultAttachment = await PerjalananDinasGetAttachmentService()
        .getAttachmentPerjalananDinas(widget.id);
    if (resultAttachment != null) {
      setState(
        () {
          filesData = List<Map<String, dynamic>>.from(
            resultAttachment.map(
              (item) {
                return {
                  'id': item['id'],
                  'path': item['nama_attachment'],
                };
              },
            ),
          );
        },
      );
    }
    combinedList = [
      ...filesData,
      ...?files?.map((file) => {'path': file.path}),
    ];
  }

  Future<void> deleteAttachment(int index) async {
    final attachmentId = filesData[index]['id'];
    final idIjin = widget.id;
    final service = PerjalananDinasDeleteAttachmentService();
    await service.perjalananDinasDeleteAttachment(
      idIjin,
      attachmentId,
      context,
    );
    setState(() {
      filesData.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File telah dihapus'),
        ),
      );
    });
  }

  Future<void> downloadAttachment(int index, String fileName) async {
    final attachmentId = filesData[index]['id'];
    final service = PerjalananDinasDownloadService();
    await service.perjalananDinasDownload(attachmentId, fileName);
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File Berhasil di download'),
        ),
      );
    });
    debugPrint('$service');
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _futureData = DetailPerjalananDinasService()
        .detailPerjalananDinas(widget.id) as Future<Map<String, dynamic>>?;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('$dataPerjalananDinas');
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
            final dataPerjalananDinas = snapshot.data ?? {};
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
                    'Edit Perjalanan Dinas',
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
                      SizedBox(
                        width: double.infinity,
                        height: 35,
                        child: TextFormField(
                          enabled: dataPerjalananDinas['status'] == 'Draft',
                          controller: judulcutiController,
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
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tanggal Awal',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextFormField(
                                enabled:
                                    dataPerjalananDinas['status'] == 'Draft',
                                controller: tanggalAwalController,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.none,
                                decoration: InputDecoration(
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: black0,
                                      width: 1,
                                    ),
                                  ),
                                  fillColor: Colors.white24,
                                  filled: true,
                                  contentPadding: const EdgeInsets.all(0),
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
                                        var hari =
                                            DateFormat.d().format(value!);
                                        var bulan =
                                            DateFormat.M().format(value);
                                        var bulan2 =
                                            DateFormat.M().format(value);
                                        var tahun =
                                            DateFormat.y().format(value);
                                        tanggalAwalController.text =
                                            '$hari/$bulan/$tahun';
                                        tanggalAPIAwal = '$tahun-$bulan2-$hari';
                                        updateJumlahHari();
                                      } catch (e) {
                                        null;
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tanggal Akhir',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextFormField(
                                enabled:
                                    dataPerjalananDinas['status'] == 'Draft',
                                controller: tanggalAkhirController,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                validator: endDateValidator,
                                keyboardType: TextInputType.none,
                                decoration: InputDecoration(
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: black0,
                                      width: 1,
                                    ),
                                  ),
                                  fillColor: Colors.white24,
                                  filled: true,
                                  contentPadding: const EdgeInsets.all(0),
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

                                        var hari =
                                            DateFormat.d().format(value!);
                                        var bulan =
                                            DateFormat.M().format(value);

                                        var tahun =
                                            DateFormat.y().format(value);
                                        tanggalAkhirController.text =
                                            '$hari/$bulan/$tahun';
                                        tanggalAPIAkhir = '$tahun-$bulan-$hari';
                                        updateJumlahHari();
                                      } catch (e) {
                                        null;
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hari',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: TextFormField(
                                enabled: false,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.none,
                                controller: jumlahHariController,
                                decoration: InputDecoration(
                                  disabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: black0,
                                    width: 1,
                                  )),
                                  fillColor: Colors.white24,
                                  filled: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: const BorderSide(
                                      width: 1,
                                      color: black0,
                                    ),
                                  ),
                                  hintStyle: const TextStyle(
                                    color: black0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('File Lampiran Opsional'),
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: normalblue,
                                ),
                                onPressed: () {
                                  disabledUpload.contains(
                                          dataPerjalananDinas['status'])
                                      ? null
                                      : pickFile();
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.cloud_upload_rounded,
                                      color: white0,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Pilih File',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: white0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: combinedList
                            .asMap()
                            .map(
                              (index, file) => MapEntry(
                                index,
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                              '${index + 1}. ${file['path'].split('/').last}')),
                                      IconButton(
                                        onPressed: () {
                                          downloadAttachment(
                                            index,
                                            file['path'],
                                          );
                                        },
                                        icon: const Icon(Icons.download),
                                      ),
                                      IconButton(
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
                                                        BorderRadius.circular(
                                                            8),
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
                                                              BorderRadius
                                                                  .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    8),
                                                          ),
                                                          color: normalred,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      const Icon(
                                                        Icons.warning,
                                                        color: normalred,
                                                        size: 80,
                                                      ),
                                                      const SizedBox(
                                                        height: 7,
                                                      ),
                                                      const Text(
                                                        'Apakah yakin ingin\nmenghapus file ini ?\nFile akan langsung hilang',
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
                                                              style: TextStyle(
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
                                                                  normalred,
                                                              fixedSize:
                                                                  const Size(
                                                                      100,
                                                                      35.81),
                                                            ),
                                                            onPressed: () {
                                                              deleteAttachment(
                                                                  index);
                                                              Navigator.pop(
                                                                  context);
                                                              fetchData();
                                                            },
                                                            child: const Text(
                                                              'Ya',
                                                              style: TextStyle(
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
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .values
                            .toList(),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (errorMessage != null) // tambahkan blok ini
                        Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: lightorange,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${dataPerjalananDinas['status']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: normalorange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: normalred,
                          fixedSize: const Size(
                            90,
                            29,
                          ),
                        ),
                        onPressed: () {
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              backgroundColor:
                                                  const Color(0xff949494),
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
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              backgroundColor:
                                                  const Color(0xffFFF068),
                                              fixedSize: const Size(100, 35.81),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PengajuanPerjalananDinas(),
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
                        child: const Icon(Icons.cancel_outlined),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: normalgreen,
                          fixedSize: const Size(
                            90,
                            29,
                          ),
                        ),
                        onPressed: () {
                          setState(() {});
                          if (formKey.currentState!.validate()) {
                            if (files?.isEmpty ?? true) {
                              debugPrint('File kosong');
                            } else {
                              debugPrint('File masuk');
                              PerjalananDinasInputAttachmentService()
                                  .perjalananDinasInputAttachment(
                                widget.id,
                                files!,
                              );
                            }

                            if (dataPerjalananDinas['status'] == 'Draft') {
                              PerjalananDinasConfirmService()
                                  .perjalananDinasConfirm(
                                widget.id,
                                context,
                              );
                              PerjalananDinasEditService().perjalananDinasEdit(
                                widget.id,
                                judulcutiController.text,
                                tanggalAPIAwal,
                                tanggalAPIAkhir,
                                context,
                              );
                            }
                          }
                        },
                        child: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
