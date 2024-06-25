import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/color.dart';
import 'package:project/home/login/lupa_pw.dart';
import 'package:project/services/pengajuan/izin_sakit_services/download_attachement_izin_sakit_services.dart';
import 'package:project/services/pengajuan/izin_sakit_services/get_attachement_izin_sakit_services.dart';
import 'package:project/services/pengajuan_hr_services/izin_sakit_services/data_edit_izin_sakit_services.dart';
import 'package:project/util/navkaryawan.dart';

import '../../../../util/customappbar.dart';

class DetailIzinSakitViewTabelHR extends StatefulWidget {
  final int id;
  const DetailIzinSakitViewTabelHR({super.key, required this.id});
  @override
  State<DetailIzinSakitViewTabelHR> createState() =>
      _DetailIzinSakitViewTabelHRState();
}

class _DetailIzinSakitViewTabelHRState
    extends State<DetailIzinSakitViewTabelHR> {
  final TextEditingController tglAwalformController = TextEditingController();
  final TextEditingController tglAkhirformController = TextEditingController();
  final TextEditingController hariController = TextEditingController();
  final TextEditingController judulSakit = TextEditingController();

  var durasi = 0;
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    durasi = (to.difference(from).inHours / 24).round();
    return durasi;
  }

  FilePickerResult? result;
  List<File>? _filename;
  int maxFile = 5;
  int maxFilesSize = 10485760;
  String? errorMessage;
  bool isLoading = false;
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
          if (platformFile.size <= maxFilesSize) {
            File newFile = File(platformFile.path!);
            newFiles.add(newFile);
          } else {
            debugPrint('File yang diperbolehkan hanya 10mb!!');
            hasInvalidFile = true;
          }
        }
        if (hasInvalidFile) {
          setState(() {
            errorMessage = 'File yang diperbolehkan hanya 10mb!!';
          });
        } else if ((_filename?.length ?? 0) + newFiles.length <= maxFile) {
          _filename ??= [];
          _filename!.addAll(newFiles);
          debugPrint('Selected files: $_filename');
          setState(() {
            errorMessage = null;
          });
        } else {
          debugPrint('File telah mencapai batas!');
          setState(() {
            errorMessage = 'File telah mencapai batas!';
          });
          int maxNewFiles = maxFile - (_filename?.length ?? 0);
          if (maxNewFiles > 0) {
            _filename ??= [];
            _filename!.addAll(newFiles.take(maxNewFiles));
          }
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Map<String, dynamic> izinSakitList = {};
  Future<Map<String, dynamic>>? _futureData;
  List<Map<String, dynamic>> filesData = [];
  List<Map<String, dynamic>> combinedList = [];

  Future<void> fetchData() async {
    final result =
        await DataEditIzinSakitHRService().dataEditIzinSakitHR(widget.id);

    izinSakitList = result;
    judulSakit.text = izinSakitList['judul'];
    tglAwalformController.text = izinSakitList['tanggal_awal'];
    tglAkhirformController.text = izinSakitList['tanggal_akhir'];

    final inputTanggalAwal = izinSakitList['tanggal_awal'];
    final inputDateFormatAwal = DateFormat('yyyy-MM-dd');
    final outputDateFormatAwal = DateFormat('d/M/y');
    final inputDateAwal = inputDateFormatAwal.parse(inputTanggalAwal);
    final outputDateStringAwal = outputDateFormatAwal.format(inputDateAwal);
    tglAwalformController.text = outputDateStringAwal;

    final inputDateAkhir = izinSakitList['tanggal_akhir'];
    final inputDateFormatAkhir = DateFormat('yyyy-MM-dd');
    final outputDateFormatAkhir = DateFormat('d/M/y');
    final inputdateAkhir = inputDateFormatAkhir.parse(inputDateAkhir);
    final outputDateStringAkhir = outputDateFormatAkhir.format(inputdateAkhir);
    tglAkhirformController.text = outputDateStringAkhir;

    //Get Attachment
    final resultAttachment =
        await GetAttachmenIzinSakitServices().getAttachmentIzinSakit(widget.id);
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
      ...?_filename?.map((file) => {'path': file.path}),
    ];
  }

  Future<void> downloadAttachment(int index, String fileName) async {
    final attachmentId = filesData[index]['id'];
    final service = DownloadAttachmentIzinSakit();
    await service.downloadAttachmenIzinSakit(attachmentId, fileName);
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File Berhasil di download'),
        ),
      );
    });
    print(service);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _futureData = DataEditIzinSakitHRService().dataEditIzinSakitHR(widget.id)
        as Future<Map<String, dynamic>>?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const NavKaryawan(),
      body: FutureBuilder(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('Error Fetching data');
          } else {
            final izinSakitList = snapshot.data ?? {};
            return Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                  bottom: 50,
                ),
                children: [
                  const Text(
                    'Detail Izin Sakit',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Judul Izin Sakit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: black0,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 270,
                    height: 35,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: judulSakit,
                      decoration: InputDecoration(
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
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
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
                          width: 60,
                        ),
                        SizedBox(
                          width: 120,
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
                                      fontSize: 16,
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
                  const SizedBox(
                    height: 10,
                  ),
                  StatefulBuilder(
                    builder: (context, setState) => Row(
                      children: [
                        SizedBox(
                          width: 138,
                          height: 35,
                          child: TextFormField(
                            controller: tglAwalformController,
                            keyboardType: TextInputType.none,
                            decoration: InputDecoration(
                              // hintText: 'tanggal awal',
                              fillColor: Colors.white24,
                              filled: true,
                              // contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: black0,
                                ),
                              ),
                            ),
                            onTap: () {
                              // showDatePicker(
                              //   context: context,
                              //   initialDate: DateTime.now(),
                              //   firstDate: DateTime(2000),
                              //   lastDate: DateTime(2100),
                              // ).then(
                              //   (value) {
                              //     try {
                              //       tglAwalformController.text =
                              //           DateFormat.yMd().format(value!);
                              //     } catch (e) {
                              //       null;
                              //     }
                              //   },
                              // );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 44,
                        ),
                        SizedBox(
                          width: 138,
                          height: 35,
                          child: TextFormField(
                            controller: tglAkhirformController,
                            keyboardType: TextInputType.none,
                            decoration: InputDecoration(
                              // hintText: 'tanggal awal',
                              fillColor: Colors.white24,
                              filled: true,
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
                            onTap: () {
                              // showDatePicker(
                              //   context: context,
                              //   initialDate: DateTime.now(),
                              //   firstDate: DateTime(2000),
                              //   lastDate: DateTime(2100),
                              // ).then(
                              //   (value) {
                              //     try {
                              //       tglAkhirformController.text =
                              //           DateFormat.yMd().format(value!);
                              //     } catch (e) {
                              //       null;
                              //     }
                              //   },
                              // );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
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
                          '${izinSakitList['status']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: normalorange,
                          ),
                        ),
                      ],
                    ),
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
