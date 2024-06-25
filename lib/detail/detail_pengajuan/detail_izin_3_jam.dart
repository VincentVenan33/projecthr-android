import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/color.dart';
import 'package:project/util/customappbar.dart';

import '../../pengajuan/pengajuan_pembatalan_izin_3jam.dart';
import '../../services/pengajuan/izin_3_jam_service/delete_izin_3_jam_service.dart';
import '../../services/pengajuan/izin_3_jam_service/input_attachment_izin_3_jam.dart';
import '../../services/pengajuan/izin_3_jam_service/izin_3_jam_confirm_service.dart';
import '../../services/pengajuan/izin_3_jam_service/izin_3_jam_service.dart';
import '../../util/navhr.dart';

class DetailIzin3Jam extends StatefulWidget {
  const DetailIzin3Jam({super.key});

  @override
  State<DetailIzin3Jam> createState() => _DetailIzin3JamState();
}

class _DetailIzin3JamState extends State<DetailIzin3Jam> {
  final TextEditingController tglController =
      TextEditingController(text: tanggalIzin3Jam);
  final TextEditingController judulIzinController =
      TextEditingController(text: judulIzin3Jam);
  final TextEditingController startDurasiIzinController =
      TextEditingController(text: durasiWaktuMulai);
  final TextEditingController endDurasiIzinController =
      TextEditingController(text: durasiWaktuSelesai);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const NavHr(),
      body: ListView(
        padding: const EdgeInsets.only(
          top: 20,
          right: 20,
          left: 20,
          bottom: 50,
        ),
        children: [
          const Text(
            'Detail Izin 3 Jam',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Judul Izin 3 Jam',
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
              enabled: false,
              keyboardType: TextInputType.none,
              controller: judulIzinController,
              decoration: InputDecoration(
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
                Expanded(
                  child: SizedBox(
                    width: 90,
                    child: Column(
                      children: const [
                        SizedBox(
                          // height: 55,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(
                              'Tanggal Izin',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 150,
                ),
                Expanded(
                  child: SizedBox(
                    width: 90,
                    child: Column(
                      children: const [
                        SizedBox(
                          // height: 55,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(
                              'Durasi Izin',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 110,
                height: 35,
                child: TextFormField(
                  enabled: false,
                  controller: tglController,
                  keyboardType: TextInputType.none,
                  decoration: InputDecoration(
                    disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: black0,
                      width: 1,
                    )),
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
                    //       tglController.text =
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
                width: 35,
              ),
              Expanded(
                child: SizedBox(
                  width: 65,
                  height: 35,
                  child: TextFormField(
                    controller: startDurasiIzinController,
                    keyboardType: TextInputType.none,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(5),
                    ],
                    decoration: InputDecoration(
                      disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                        color: black0,
                        width: 1,
                      )),
                      hintText: '00:00',
                      fillColor: Colors.white24,
                      filled: true,
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: black0,
                        ),
                      ),
                    ),
                    enabled: false,
                    onTap: () {},
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: SizedBox(
                  width: 65,
                  height: 35,
                  child: TextFormField(
                    enabled: false,
                    controller: endDurasiIzinController,
                    keyboardType: TextInputType.none,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(5),
                    ],
                    decoration: InputDecoration(
                      disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                        color: black0,
                        width: 1,
                      )),
                      hintText: '00:00',
                      fillColor: Colors.white24,
                      filled: true,
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: black0,
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),
            ],
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
            height: 5,
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
                  'Draft',
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
                                'Apakah yakin ingin\nmenghapus pengajuan ini ?',
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
                                      DeleteIzin3JamService().deleteIzin3Jam(
                                        idIzin3Jam,
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
                  if (files?.isEmpty ?? true) {
                    print('kosongan bang');
                    Izin3JamConfirmService().Izin3JamConfirm(
                      idIzin3Jam,
                    );
                  } else {
                    print('ada isinya bang');
                    InputAttachmentIzin3JamService().inputAttachmentIzin3Jam(
                      idIzin3Jam,
                      files!,
                    );
                    Izin3JamConfirmService().Izin3JamConfirm(
                      idIzin3Jam,
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
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: darkgreen,
                                  fixedSize: const Size(120, 45),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PengajuanIzin3Jam(),
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
