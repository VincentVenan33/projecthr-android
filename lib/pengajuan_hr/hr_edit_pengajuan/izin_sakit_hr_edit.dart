// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/home/login/lupa_pw.dart';
import 'package:project/pengajuan_hr/pengajuan_izin_sakit_hr.dart';
import 'package:project/services/pengajuan/izin_sakit_services/download_attachement_izin_sakit_services.dart';
import 'package:project/services/pengajuan/izin_sakit_services/get_attachement_izin_sakit_services.dart';
import 'package:project/services/pengajuan/izin_sakit_services/input_attachment_izin_sakit.dart';
import 'package:project/services/pengajuan_hr_services/izin_sakit_services/confirm_izin_sakit_hr_services.dart';
import 'package:project/services/pengajuan_hr_services/izin_sakit_services/data_edit_izin_sakit_services.dart';
import 'package:project/services/pengajuan_hr_services/izin_sakit_services/delete_attachement_izin_sakit_hr_services.dart';
import 'package:project/services/pengajuan_hr_services/izin_sakit_services/edit_izin_sakit_hr_services.dart';

import '../../../color.dart';
import '../../../util/customappbar.dart';
import '../../../util/navhr.dart';
// import '../pengajuan_pembatalan_izin_sakit.dart';

class EditIzinSakitHR extends StatefulWidget {
  final int id;
  const EditIzinSakitHR({super.key, required this.id});

  @override
  State<EditIzinSakitHR> createState() => _EditIzinSakitHRState();
}

class _EditIzinSakitHRState extends State<EditIzinSakitHR> {
  final TextEditingController judulSakit = TextEditingController();
  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final DateFormat formatter = DateFormat("dd/MM/YYYY");
  DateTime? endData;
  DateTime? startDate;
  String tanggalAPIa = '';
  String tanggalAPIb = '';
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
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Map<String, dynamic> izinSakitList = {};
  Future<Map<String, dynamic>>? _futureData;
  List<Map<String, dynamic>> fileData = [];
  List<Map<String, dynamic>> combineList = [];

  // TEST
  Future<void> fetchData() async {
    final result =
        await DataEditIzinSakitHRService().dataEditIzinSakitHR(widget.id);

    izinSakitList = result;
    judulSakit.text = izinSakitList['judul'];
    tglAwalController.text = izinSakitList['tanggal_awal'];
    tglAkhirController.text = izinSakitList['tanggal_akhir'];
    // jumlahHariController.text = izinSakitList['jumlah_hari'].toString();

    // Format Tanggal Awal
    final inputDateAwal = izinSakitList['tanggal_awal'];
    final inputDateFormatAwal = DateFormat('yyyy-MM-dd');
    final outputDateFormatAwal = DateFormat('d/M/y');
    final inputdateAwal = inputDateFormatAwal.parse(inputDateAwal);
    final outputDateStringAwal = outputDateFormatAwal.format(inputdateAwal);
    tglAwalController.text = outputDateStringAwal;
    // Format Tanggal Akhir
    final inputDateAkhir = izinSakitList['tanggal_akhir'];
    final inputDateFormatAkhir = DateFormat('yyyy-MM-dd');
    final outputDateFormatAkhir = DateFormat('d/M/y');
    final inputdateAkhir = inputDateFormatAkhir.parse(inputDateAkhir);
    final outputDateStringAkhir = outputDateFormatAkhir.format(inputdateAkhir);
    tglAkhirController.text = outputDateStringAkhir;

    final resultAttachment =
        await GetAttachmenIzinSakitServices().getAttachmentIzinSakit(widget.id);
    if (resultAttachment != null) {
      setState(
        () {
          fileData = List<Map<String, dynamic>>.from(
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
    combineList = [
      ...fileData,
      ...?files?.map((file) => {'path': file.path}),
    ];
  }

  Future<void> deleteAttachment(int index) async {
    final attachmentId = fileData[index]['id'];
    final idIzin = widget.id;
    final services = IzinSakitDeleteAttachmentHRServices();
    await services.izinSakitDeleteAttachmentHR(idIzin, attachmentId, context);
    setState(() {
      fileData.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File telah dihapus'),
        ),
      );
    });
  }

  Future<void> downloadAttachment(int index, String filename) async {
    final attachmentId = fileData[index]['id'];
    final services = DownloadAttachmentIzinSakit();
    await services.downloadAttachmenIzinSakit(attachmentId, filename);
    setState(() {
      fileData.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File telah dihapus'),
        ),
      );
    });
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
    print(izinSakitList);
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
            final izinSakitList = snapshot.data ?? {};
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
                    'HR Edit Detail Izin Sakit',
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
                        'Judul Izin Sakit',
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
                        width: 270,
                        height: 35,
                        child: TextFormField(
                          enabled: izinSakitList['status'] == 'Draft',
                          keyboardType: TextInputType.none,
                          controller: judulSakit,
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
                                enabled: izinSakitList['status'] == 'Draft',
                                controller: tglAwalController,
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
                                        tglAwalController.text =
                                            '$hari/$bulan/$tahun';
                                        tanggalAPIa = '$tahun-$bulan2-$hari';
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
                        width: 19,
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
                                enabled: izinSakitList['status'] == 'Draft',
                                controller: tglAkhirController,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                validator: endDateValidator,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                        var bulan2 =
                                            DateFormat.M().format(value);
                                        var tahun =
                                            DateFormat.y().format(value);
                                        tglAkhirController.text =
                                            '$hari/$bulan/$tahun';
                                        tanggalAPIb = '$tahun-$bulan2-$hari';
                                        final difference =
                                            daysBetween(startDate!, endData!);
                                        setState(() {});
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
                                  pickFile();
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
                      if (files != null)
                        ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: files!
                              .asMap()
                              .map((index, file) => MapEntry(
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
                                                '${index + 1}. ${file.path.split('/').last}')),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              files!.removeAt(index);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'File telah dihapus'),
                                                ),
                                              );
                                            });
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  )))
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
                          '${izinSakitList['status']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: black0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
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
                                                      const PengajuanIzinSakitHR(),
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
                              print('kosongan bang');
                            } else {
                              print('ada isinya bang');
                              InputAttachmentIzinSakitServices()
                                  .inputAttachmentizinsakit(
                                widget.id,
                                files!,
                              );
                            }

                            if (izinSakitList['status'] == 'Draft') {
                              IzinSakitHRConfirmServices().izinsakitHRconfirm(
                                widget.id,
                              );
                              EditIzinSakitHRServices().editIzinSakitHR(
                                widget.id,
                                judulSakit.text,
                                tanggalAPIa,
                                tanggalAPIb,
                                context,
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
                                          'Pengajuan telah dikirim\nmenunggu konfirmasi Pimpinan dan HR',
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            backgroundColor: darkgreen,
                                            fixedSize: const Size(120, 45),
                                          ),
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const PengajuanIzinSakitHR(),
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
