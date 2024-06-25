import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:project/color.dart';
import 'package:project/services/pengajuan/izin_3_jam_service/get_attachment_izin_3_jam_service.dart';
import 'package:project/util/customappbar.dart';

import '../../services/pengajuan/izin_3_jam_service/input_attachment_izin_3_jam.dart';
import '../../services/pengajuan_hr_services/izin_3_jam_services/hr_confirm_izin_3_jam_service.dart';
import '../../services/pengajuan_hr_services/izin_3_jam_services/hr_delete_izin_3_jam_service.dart';
import '../../services/pengajuan_hr_services/izin_3_jam_services/hr_detail_izin_3_jam_service.dart';
import '../../util/navhr.dart';

class HRDetailIzin3Jam extends StatefulWidget {
  final int id;
  const HRDetailIzin3Jam({super.key, required this.id});

  @override
  State<HRDetailIzin3Jam> createState() => _HRDetailIzin3JamState();
}

class _HRDetailIzin3JamState extends State<HRDetailIzin3Jam> {
  final TextEditingController tglController = TextEditingController();
  final TextEditingController judulIzinController = TextEditingController();
  final TextEditingController startDurasiIzinController =
      TextEditingController();
  final TextEditingController endDurasiIzinController = TextEditingController();
  final TextEditingController namaKaryawanController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  TimeOfDay _startTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay _endTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? startWaktu;
  TimeOfDay? endWaktu;
  String tanggalAPI = '';
  final disabledUpload = {'Refused', 'Cancelled'};

  void _selectStartTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (newTime != null) {
      setState(
        () {
          _startTime = newTime;
          var jam = _startTime.hour;
          var menit = _startTime.minute;
          var hasilMenit = '';
          var hasilJam = '';
          if (jam < 10) {
            hasilJam = '0$jam';
          } else {
            hasilJam = jam.toString();
          }
          if (menit < 10) {
            hasilMenit = '0$menit';
          } else {
            hasilMenit = menit.toString();
          }
          startWaktu = _startTime;
          startDurasiIzinController.text = '$hasilJam:$hasilMenit';
        },
      );
    }
  }

  void _selectEndTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (newTime != null) {
      setState(
        () {
          _endTime = newTime;
          var jam = _endTime.hour;
          var menit = _endTime.minute;
          var hasilMenit = '';
          var hasilJam = '';
          if (jam < 10) {
            hasilJam = '0$jam';
          } else {
            hasilJam = jam.toString();
          }
          if (menit < 10) {
            hasilMenit = '0$menit';
          } else {
            hasilMenit = menit.toString();
          }
          endWaktu = _endTime;
          endDurasiIzinController.text = '$hasilJam:$hasilMenit';
        },
      );
    }
  }

  int getMinutesDiff(TimeOfDay tod1, TimeOfDay tod2) {
    return (tod1.hour * 60 + tod1.minute) - (tod2.hour * 60 + tod2.minute);
  }

  String? startTimeValidator(value) {
    if (startWaktu == null) {
      return 'waktu awal wajib di isi';
    }
    return null;
  }

  String? endTimeValidator(value) {
    if (endWaktu == null) {
      return "pilih waktu akhir";
    } else if (endWaktu != null && startWaktu != null) {
      int beda = getMinutesDiff(startWaktu!, endWaktu!).abs();
      int startMinute = startWaktu!.hour * 60 + startWaktu!.minute;
      int endMinute = endWaktu!.hour * 60 + endWaktu!.minute;
      if (startMinute > endMinute) {
        return 'waktu awal harus lebih kecil dari waktu akhir';
      }
      if (beda > 180) {
        return 'izin maksimal 3 jam!';
      }
    }
    return null;
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

  Map<String, dynamic> dataIzin3Jam = {};
  Future<Map<String, dynamic>>? _futureData;
  List<Map<String, dynamic>> filesData = [];
  List<Map<String, dynamic>> combinedList = [];

  // TEST
  Future<void> fetchData() async {
    final result =
        await DataDetailIzin3JamHRService().dataDetailIzin3JamHR(widget.id);

    dataIzin3Jam = result;
    judulIzinController.text = dataIzin3Jam['judul'];
    namaKaryawanController.text = dataIzin3Jam['nama_karyawan'];
    startDurasiIzinController.text = dataIzin3Jam['waktu_awal'].substring(0, 5);
    endDurasiIzinController.text = dataIzin3Jam['waktu_akhir'].substring(0, 5);

    // Format Tanggal
    final inputDateString = dataIzin3Jam['tanggal_ijin'];
    final inputDateFormat = DateFormat('yyyy-MM-dd');
    final outputDateFormat = DateFormat('d/M/y');
    final inputDate = inputDateFormat.parse(inputDateString);
    final outputDateString = outputDateFormat.format(inputDate);
    tglController.text = outputDateString;
    tanggalAPI = dataIzin3Jam['tanggal_ijin'];

    //Format Durasi Awal
    DateFormat inputFormatAwal = DateFormat('HH:mm');
    DateTime dateTimeAwal =
        inputFormatAwal.parse(dataIzin3Jam['waktu_awal'].substring(0, 5));
    TimeOfDay formatDurasiAwal = TimeOfDay.fromDateTime(dateTimeAwal);
    startWaktu = formatDurasiAwal;

    //Format Durasi Akhir
    DateFormat inputFormatAkhir = DateFormat('HH:mm');
    DateTime dateTimeAkhir =
        inputFormatAkhir.parse(dataIzin3Jam['waktu_akhir'].substring(0, 5));
    TimeOfDay formatDurasiAkhir = TimeOfDay.fromDateTime(dateTimeAkhir);
    endWaktu = formatDurasiAkhir;

    //Get Attachment
    final resultAttachment =
        await GetAttachmentIzin3JamService().getAttachmentIzin3Jam(widget.id);
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

  @override
  void initState() {
    super.initState();
    fetchData();
    _futureData = DataDetailIzin3JamHRService().dataDetailIzin3JamHR(widget.id)
        as Future<Map<String, dynamic>>?;
  }

  // TEST

  // Kombinasi Attachment

  // Kombinasi Attachment

  @override
  Widget build(BuildContext context) {
    print(dataIzin3Jam);

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
              final dataIzin3Jam = snapshot.data ?? {};
              return Form(
                key: formkey,
                child: ListView(
                  padding: const EdgeInsets.only(
                    top: 20,
                    right: 20,
                    left: 20,
                    bottom: 50,
                  ),
                  children: [
                    const Text(
                      'HR Detail Izin 3 Jam',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Nama Karyawan',
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
                      height: 10,
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
                          const SizedBox(
                            width: 150,
                          ),
                          SizedBox(
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
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                ).then(
                                  (value) {
                                    try {
                                      var hari = DateFormat.d().format(value!);
                                      var bulan = DateFormat.M().format(value);
                                      var tahun = DateFormat.y().format(value);
                                      tglController.text =
                                          '$hari/$bulan/$tahun';
                                      tanggalAPI = '$tahun-$bulan-$hari';
                                    } catch (e) {
                                      null;
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 95,
                          ),
                          SizedBox(
                            width: 65,
                            height: 35,
                            child: TextFormField(
                              controller: startDurasiIzinController,
                              keyboardType: TextInputType.none,
                              validator: startTimeValidator,
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
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: black0,
                                  ),
                                ),
                              ),
                              enabled: false,
                              onTap: _selectStartTime,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 65,
                            height: 35,
                            child: TextFormField(
                              enabled: false,
                              controller: endDurasiIzinController,
                              keyboardType: TextInputType.none,
                              validator: endTimeValidator,
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
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: black0,
                                  ),
                                ),
                              ),
                              onTap: _selectEndTime,
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
                                    disabledUpload
                                            .contains(dataIzin3Jam['status'])
                                        ? null
                                        : pickFile();
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                            fetchData();
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
                        children: [
                          Text(
                            '${dataIzin3Jam['status']}',
                            style: const TextStyle(
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
                                                fixedSize:
                                                    const Size(100, 35.81),
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
                                                fixedSize:
                                                    const Size(100, 35.81),
                                              ),
                                              onPressed: () {
                                                DeleteIzin3JamHRService()
                                                    .deleteIzin3JamHR(
                                                  widget.id,
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
                              Izin3JamConfirmHRService().izin3JamConfirmHR(
                                widget.id,
                                context,
                              );
                            } else {
                              print('ada isinya bang');
                              InputAttachmentIzin3JamService()
                                  .inputAttachmentIzin3Jam(
                                widget.id,
                                files!,
                              );
                              Izin3JamConfirmHRService().izin3JamConfirmHR(
                                widget.id,
                                context,
                              );
                            }
                          },
                          child: const Icon(Icons.send),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }
          },
        ));
  }
}
