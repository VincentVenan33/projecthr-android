import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project/color.dart';
import 'package:project/pengajuan/pengajuan_pembatalan_izin_sakit.dart';
import 'package:project/services/pengajuan/izin_sakit_services/confirm_izin_sakit_services.dart';
import 'package:project/services/pengajuan/izin_sakit_services/delete_izin_sakit_services.dart';
import 'package:project/services/pengajuan/izin_sakit_services/input_attachment_izin_sakit.dart';
import 'package:project/services/pengajuan/izin_sakit_services/izin_sakit_input_services.dart';
import 'package:project/util/navkaryawan.dart';

import '../../util/customappbar.dart';

class DetailIzinSakit extends StatefulWidget {
  const DetailIzinSakit({super.key});
  @override
  State<DetailIzinSakit> createState() => _DetailIzinSakitState();
}

class _DetailIzinSakitState extends State<DetailIzinSakit> {
  final TextEditingController tglAwalformController =
      TextEditingController(text: tanggalAwalizin);

  final TextEditingController tglAkhirformController =
      TextEditingController(text: tanggalAkhirizin);

  final TextEditingController hariController =
      TextEditingController(text: jumlahhariizin);
  final TextEditingController judulSakit =
      TextEditingController(text: judulIzinSakit);

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

  // Map<String, dynamic> izinSakitList = {};
  // Future<Map<String, dynamic>>? _futureData;

  // Future<void> fetchData() async{
  //   final result = awai
  // }

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
              if (_filename != null)
                ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: _filename!
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
                                      _filename!.removeAt(index);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('File telah dihapus'),
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
              children: const [
                Text(
                  'Draf',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: normalorange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 13,
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
                                'Apakah yakin ingin\nmenghapus data ini ?',
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
                                      DeleteIzinSakitServices().deleteIzinSakit(
                                        idizinsakit,
                                        context,
                                      );
                                      Navigator.pop(context);
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
                child: const Icon(Icons.delete),
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
                  if (_filename?.isEmpty ?? true) {
                    print('kosong om');
                    IzinSakitConfirmServices().izinsakitconfirm(idizinsakit);
                  } else {
                    InputAttachmentIzinSakitServices().inputAttachmentizinsakit(
                      idizinsakit,
                      _filename!,
                    );
                    IzinSakitConfirmServices().izinsakitconfirm(idizinsakit);
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
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: darkgreen,
                                  fixedSize: const Size(120, 45),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PengajuanIzinSakit(),
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
                child: const Icon(Icons.send),
              ),
            ],
          )
        ],
      ),
    );
  }
}
