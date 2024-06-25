import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../color.dart';
import '../../pengajuan_hr/hr_pengajuan_cuti_khusus.dart';
import '../../services/pengajuan/cuti_khusus_service/cuti_khusus_input_attachment_service.dart';
import '../../services/pengajuan_hr_services/cuti_khusus/hr_cuti_khusus_confirm_service.dart';
import '../../services/pengajuan_hr_services/cuti_khusus/hr_cuti_khusus_delete_service.dart';
import '../../services/pengajuan_hr_services/cuti_khusus/hr_cuti_khusus_detail_service.dart';
import '../../services/pengajuan_hr_services/cuti_khusus/hr_cuti_khusus_input_service.dart';
import '../../util/customappbar.dart';
import '../../util/navhr.dart';

class HRDetailCutiKhusus extends StatefulWidget {
  final int idCutiKhusus;
  final int id;
  const HRDetailCutiKhusus({
    super.key,
    required this.idCutiKhusus,
    required this.id,
  });

  @override
  State<HRDetailCutiKhusus> createState() => _HRDetailCutiKhususState();
}

class _HRDetailCutiKhususState extends State<HRDetailCutiKhusus> {
  final TextEditingController namaKaryawanController = TextEditingController();
  final TextEditingController judulcutiController = TextEditingController();
  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();
  final TextEditingController jumlahHariController = TextEditingController();

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

  Map<String, dynamic> dataCutiKhusus = {};
  Future<Map<String, dynamic>>? futureData;

  // TEST
  Future<void> fetchData() async {
    final result =
        await HRDetailCutiKhususService().hrdetailCutikhusus(widget.id);

    dataCutiKhusus = result;
    namaKaryawanController.text = dataCutiKhusus['nama_karyawan'];
    judulcutiController.text = dataCutiKhusus['judul'];
    tanggalAwalController.text = dataCutiKhusus['tanggal_awal'];
    tanggalAkhirController.text = dataCutiKhusus['tanggal_akhir'];
    jumlahHariController.text = dataCutiKhusus['jumlah_hari'].toString();

    // Format Tanggal Awal
    final inputDateAwal = dataCutiKhusus['tanggal_awal'];
    final inputDateFormatAwal = DateFormat('yyyy-MM-dd');
    final outputDateFormatAwal = DateFormat('d/M/y');
    final inputdateAwal = inputDateFormatAwal.parse(inputDateAwal);
    final outputDateStringAwal = outputDateFormatAwal.format(inputdateAwal);
    tanggalAwalController.text = outputDateStringAwal;
    // Format Tanggal Akhir
    final inputDateAkhir = dataCutiKhusus['tanggal_akhir'];
    final inputDateFormatAkhir = DateFormat('yyyy-MM-dd');
    final outputDateFormatAkhir = DateFormat('d/M/y');
    final inputdateAkhir = inputDateFormatAkhir.parse(inputDateAkhir);
    final outputDateStringAkhir = outputDateFormatAkhir.format(inputdateAkhir);
    tanggalAkhirController.text = outputDateStringAkhir;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    futureData = HRDetailCutiKhususService().hrdetailCutikhusus(widget.id)
        as Future<Map<String, dynamic>>?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const NavHr(),
      body: ListView(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        children: [
          const Text(
            'HR Detail Cuti Khusus',
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
                width: 270,
                height: 35,
                child: TextFormField(
                  enabled: false,
                  keyboardType: TextInputType.none,
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
                width: 270,
                height: 35,
                child: TextFormField(
                  enabled: false,
                  keyboardType: TextInputType.none,
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
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        enabled: false,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        controller: tanggalAwalController,
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
                        onTap: () {},
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
                        enabled: false,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        controller: tanggalAkhirController,
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
                        onTap: () {},
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
                                        '${index + 1}. ${file.path.split('/').last}')),
                                IconButton(
                                  onPressed: () {
                                    setState(
                                      () {
                                        files!.removeAt(index);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('File telah dihapus'),
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
              if (errorMessage != null)
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
                    101,
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
                            color: white0,
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
                                      backgroundColor: lightgray,
                                      fixedSize: const Size(100, 35.81),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
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
                                      backgroundColor: normalyellow,
                                      fixedSize: const Size(100, 35.81),
                                    ),
                                    onPressed: () {
                                      HRCutiKhususDeleteService()
                                          .hrcutiKhususDelete(
                                        idCutiKhusus,
                                        context,
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
                child: const Icon(Icons.delete),
              ),
              const SizedBox(
                width: 24,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: normalgreen,
                  fixedSize: const Size(
                    101,
                    29,
                  ),
                ),
                onPressed: () {
                  if (files?.isEmpty ?? true) {
                    debugPrint('File kosong');
                    HRCutiKhususConfirmService().hrcutiKhususConfirm(
                      idCutiKhusus,
                      context,
                    );
                  } else {
                    debugPrint('File Masuk');
                    CutiKhususInputAttachmentService()
                        .cutiKhususInputAttachment(
                      idCutiKhusus,
                      files!,
                    );
                    HRCutiKhususConfirmService().hrcutiKhususConfirm(
                      idCutiKhusus,
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
                          height: 270,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: white0,
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
                                  fontSize: 14,
                                  color: black0,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
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
                                          const HRPengajuanCutiKhusus(),
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
          ),
        ],
      ),
    );
  }
}
