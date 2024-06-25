import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

import '../color.dart';
import '../detail/detail_pengajuan_hr/detail_view_hr/hr_ijin_3_jam_detail.dart';
import '../services/pengajuan_hr_services/izin_3_jam_services/hr_cancelled_izin_3_jam_service.dart';
import '../services/pengajuan_hr_services/izin_3_jam_services/hr_delete_izin_3_jam_service.dart';
import '../services/pengajuan_hr_services/izin_3_jam_services/hr_input_izin_3_jam_service.dart';
import '../services/pengajuan_hr_services/izin_3_jam_services/hr_izin_3_jam_list_service.dart';
import '../services/pengajuan_hr_services/izin_3_jam_services/hr_list_karyawan_service.dart';
import '../util/customappbar.dart';
import '../util/navhr.dart';
import '../pengajuan/edit_pengajuan/edit_pengajuan_ijin_3_jam.dart';
import 'hr_edit_pengajuan/hr_edit_pengajuan_ijin_3_jam.dart';

String judulIzin3Jam = '';
String durasiWaktuMulai = '';
String durasiWaktuSelesai = '';
String tanggalIzin3Jam = '';

class HRPengajuanIzin3Jam extends StatefulWidget {
  const HRPengajuanIzin3Jam({super.key});

  @override
  State<HRPengajuanIzin3Jam> createState() => _HRPengajuanIzin3JamState();
}

class _HRPengajuanIzin3JamState extends State<HRPengajuanIzin3Jam> {
  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final TextEditingController tglFormController = TextEditingController();
  final TextEditingController startDurasiIzinController =
      TextEditingController();
  final TextEditingController endDurasiIzinController = TextEditingController();
  final TextEditingController judulIzinController = TextEditingController();
  final TextEditingController hariController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController namaKaryawanController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  int? selectedId;
  DateTime? endData;
  DateTime? startDate;
  String tanggalAPI = '';

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

  TimeOfDay _startTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay _endTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? startWaktu;
  TimeOfDay? endWaktu;

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

  String chosevalue = 'All';
  String chosevaluedua = '10';
  String? tglAwal;
  String? tglAkhir;
  int pageSize = 10;
  int page = 1;
  bool isFetchingData = true;
  // AREA TABLE CONTOH
  List<dynamic> dataIzin3Jam = [];

  Future<void> fetchData() async {
    setState(() {
      isFetchingData = true;
    });
    final result = await Izin3JamListHRService().izin3JamListHR(
      context,
      page: page,
      tanggalAwal: tglAwal,
      tanggalAkhir: tglAkhir,
      filterStatus: chosevalue,
      size: pageSize,
    );

    if (result != null && result is List<dynamic>) {
      setState(() {
        dataIzin3Jam = result;
      });
    } else {
      print('Error fetching data');
    }

    setState(() {
      isFetchingData = false;
    });
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
  // AREA TABLE

  int? idIjin;

  Future kirimData() async {
    final id = await HRIzin3JamService().hrIzin3jam(
      selectedId!,
      judulIzinController.text,
      tanggalAPI,
      startDurasiIzinController.text,
      endDurasiIzinController.text,
      context,
    );

    print('INI ID IJIN DARI HR : $id');
    return id;
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
            'HR Izin 3 Jam',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 120),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: normalblue,
                  fixedSize: const Size(147, 23)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      insetPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Form(
                        key: formkey,
                        child: Container(
                          width: 320,
                          height: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'FORM PEMBUATAN IZIN 3 JAM',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Nama Karyawan',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 270,
                                  height: 60,
                                  child: TypeAheadFormField<dynamic>(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      controller: namaKaryawanController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          borderSide: const BorderSide(
                                            width: 1,
                                            color: black0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      final ListKaryawanService service =
                                          ListKaryawanService();
                                      final List<dynamic> suggestions =
                                          await service.listKaryawan(
                                        filterNama: pattern,
                                      );
                                      return suggestions;
                                    },
                                    itemBuilder: (context, dynamic suggestion) {
                                      return ListTile(
                                        title:
                                            Text(suggestion['nama_karyawan']),
                                      );
                                    },
                                    onSuggestionSelected: (dynamic suggestion) {
                                      selectedId = suggestion['id'];
                                      namaKaryawanController.text =
                                          suggestion['nama_karyawan'];
                                      print('ID NIH BOS SENGGOL : $selectedId');
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Masukkan Nama Karyawan';
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Judul Izin 3 Jam',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                SizedBox(
                                  width: 270,
                                  height: 60,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: judulIzinController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      contentPadding: const EdgeInsets.all(10),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color: black0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Masukkan judul izin';
                                      }
                                      if (value.length > 30) {
                                        return 'judul maksimal 30 karakter';
                                      }
                                      return null;
                                    },
                                  ),
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
                                        width: 90,
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
                                        width: 100,
                                        height: 60,
                                        child: TextFormField(
                                          controller: tglFormController,
                                          keyboardType: TextInputType.none,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'tanggal harus diisi';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            // hintText: 'tanggal awal',
                                            fillColor: Colors.white24,
                                            filled: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    10, 10, 0, 5),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
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
                                                  var hari = DateFormat.d()
                                                      .format(value!);
                                                  var bulan2 = DateFormat.M()
                                                      .format(value);
                                                  var tahun = DateFormat.y()
                                                      .format(value);
                                                  tglFormController.text =
                                                      '$hari/$bulan2/$tahun';
                                                  tanggalAPI =
                                                      '$tahun-$bulan2-$hari';
                                                } catch (e) {
                                                  null;
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 35,
                                      ),
                                      SizedBox(
                                        width: 65,
                                        height: 60,
                                        child: TextFormField(
                                          controller: startDurasiIzinController,
                                          keyboardType: TextInputType.none,
                                          inputFormatters: <TextInputFormatter>[
                                            LengthLimitingTextInputFormatter(5),
                                          ],
                                          validator: startTimeValidator,
                                          decoration: InputDecoration(
                                            hintText: '00:00',
                                            fillColor: Colors.white24,
                                            filled: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    10, 10, 0, 10),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              borderSide: const BorderSide(
                                                width: 1,
                                                color: black0,
                                              ),
                                            ),
                                          ),
                                          onTap: _selectStartTime,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        width: 65,
                                        height: 60,
                                        child: TextFormField(
                                          controller: endDurasiIzinController,
                                          keyboardType: TextInputType.none,
                                          inputFormatters: <TextInputFormatter>[
                                            LengthLimitingTextInputFormatter(5),
                                          ],
                                          onTap: _selectEndTime,
                                          validator: endTimeValidator,
                                          decoration: InputDecoration(
                                            hintText: '00:00',
                                            fillColor: Colors.white24,
                                            filled: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    10, 10, 0, 10),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
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
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 35,
                                    right: 35,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(84, 29),
                                            backgroundColor: lightgray,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Batal',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      SizedBox(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(84, 29),
                                            backgroundColor: normalblue,
                                          ),
                                          onPressed: () {
                                            setState(() {});
                                            if (formkey.currentState!
                                                .validate()) {
                                              print(
                                                  'INI SELECTED ID : $selectedId');
                                              kirimData();

                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 300), () {
                                                fetchData();
                                              });
                                            }
                                          },
                                          child: const Text(
                                            'Save',
                                            textAlign: TextAlign.center,
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
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text(
                'Buat Izin 3 Jam',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              const Expanded(
                child: SizedBox(
                  width: 149,
                  child: Text(
                    'Tanggal Awal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: SizedBox(
                  width: 149,
                  height: 48,
                  child: TextFormField(
                    keyboardType: TextInputType.none,
                    controller: tglAwalController,
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
                            tglAwalController.text = '$hari/$bulan/$tahun';
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
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
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
              const Expanded(
                child: SizedBox(
                  width: 149,
                  child: Text(
                    'Tanggal Akhir',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: SizedBox(
                  width: 149,
                  height: 48,
                  child: TextFormField(
                    keyboardType: TextInputType.none,
                    controller: tglAkhirController,
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
                            tglAkhirController.text = '$hari/$bulan/$tahun';
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
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
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
                child: SizedBox(
                  width: 149,
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      hintText: 'Status',
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: black0)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: lightgreen,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: white0,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    value: chosevalue,
                    items: <String>[
                      'All',
                      'Draft',
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
                          // chosevalue = value.toString();
                          chosevalue = value!;
                          fetchData();
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: SizedBox(
                  width: 149,
                  height: 48,
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      hintText: 'Show',
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: black0)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: lightgreen,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: white0,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    value: chosevaluedua,
                    items: <String>[
                      '10',
                      '20',
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
                          // chosevaluedua = value.toString();
                          chosevaluedua = value!;
                          pageSize = int.parse(chosevaluedua);
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
            height: 15,
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
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  'Nama Karyawan',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  'Judul Izin 3 Jam',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  'Tanggal Izin',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  'Durasi Izin',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  'Status',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  'Actions',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )),
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
                      dataIzin3Jam.length,
                      (int index) {
                        // print('TIPE: ${dataIzin3Jam[index]['waktu_awal'].runtimeType}');
                        int rowIndex = (page - 1) * pageSize + index + 1;
                        return DataRow(
                          onLongPress: () {
                            // Navigate to another page with the id obtained from the API
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HRIjin3JamDetail(
                                  id: dataIzin3Jam[index]['id'],
                                ),
                              ),
                            );
                          },
                          cells: [
                            DataCell(Text(rowIndex.toString())),
                            DataCell(
                                Text(dataIzin3Jam[index]['nama_karyawan'])),
                            DataCell(Text(dataIzin3Jam[index]['judul'])),
                            DataCell(Text(dataIzin3Jam[index]['tanggal_ijin'])),
                            DataCell(
                              Text(
                                  '${dataIzin3Jam[index]['waktu_awal'].substring(0, 5)} - ${dataIzin3Jam[index]['waktu_akhir'].substring(0, 5)}'),
                            ),
                            DataCell(Text(dataIzin3Jam[index]['status'])),
                            dataIzin3Jam[index]['status'] == 'Draft'
                                ? DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: lightgray,
                                          ),
                                          onPressed: () {
                                            // Navigate to another page with the id obtained from the API
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HREditPengajuanIjin3Jam(
                                                  id: dataIzin3Jam[index]['id'],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: normalred,
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
                                                            color: Color(
                                                                0xffFFF068),
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
                                                          'Apakah anda yakin\nmenghapus pengajuan ini?',
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
                                                                style:
                                                                    TextStyle(
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
                                                                    const Color(
                                                                        0xffFFF068),
                                                                fixedSize:
                                                                    const Size(
                                                                        100,
                                                                        35.81),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                DeleteIzin3JamHRService()
                                                                    .deleteIzin3JamHR(
                                                                        dataIzin3Jam[index]
                                                                            [
                                                                            'id'],
                                                                        context);
                                                                Future.delayed(
                                                                    const Duration(
                                                                        milliseconds:
                                                                            300),
                                                                    () {
                                                                  fetchData();
                                                                });
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
                                        ),
                                      ],
                                    ),
                                  )
                                : dataIzin3Jam[index]['status'] ==
                                            'Confirmed' ||
                                        dataIzin3Jam[index]['status'] ==
                                            'Approved'
                                    ? DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: lightgray,
                                              ),
                                              onPressed: () {
                                                // Navigate to another page with the id obtained from the API
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HREditPengajuanIjin3Jam(
                                                      id: dataIzin3Jam[index]
                                                          ['id'],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.cancel_outlined,
                                                color: normalred,
                                              ),
                                              onPressed: () {
                                                // Change the status of the data to 'Cancelled'
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Container(
                                                        width: 278,
                                                        height: 270,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: Colors.white,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 31,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          8),
                                                                ),
                                                                color: Color(
                                                                    0xffFFF068),
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
                                                              'Apakah anda yakin\nmengcancel pengajuan ini?',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
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
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
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
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Cancel',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          18,
                                                                      color:
                                                                          white0,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 34,
                                                                ),
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xffFFF068),
                                                                    fixedSize:
                                                                        const Size(
                                                                            100,
                                                                            35.81),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);
                                                                    await CancelledIzin3JamHRService()
                                                                        .cancelledIzin3JamHR(
                                                                      dataIzin3Jam[
                                                                              index]
                                                                          [
                                                                          'id'],
                                                                      context,
                                                                    );
                                                                    fetchData();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Ya',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          20,
                                                                      color:
                                                                          white0,
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
                                            ),
                                          ],
                                        ),
                                      )
                                    : dataIzin3Jam[index]['status'] ==
                                                'Refused' ||
                                            dataIzin3Jam[index]['status'] ==
                                                'Cancelled'
                                        ? DataCell(
                                            // If status is "Refused" or "Cancelled", show an empty container instead of the IconButton
                                            Container(),
                                          )
                                        : DataCell(
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.arrow_forward),
                                              onPressed: () {
                                                // Navigate to another page with the id obtained from the API
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditPengajuanIjin3Jam(
                                                      id: dataIzin3Jam[index]
                                                          ['id'],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
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
                onPressed: dataIzin3Jam.length >= pageSize
                    ? () => onPageChange(page + 1)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
