import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:project/util/navhr.dart';

import '../../../color.dart';
import '../../../services/master/master_jumlah_cuti_tahunan/master_jumlah_cuti_tahunan.dart';
import '../../../services/master/master_jumlah_cuti_tahunan/master_jumlah_cuti_tahunan_input.dart';
import '../../../util/customappbar.dart';
import 'jumlah_cuti_tahunan_edit.dart';

class JumlahCutiTahunan extends StatefulWidget {
  const JumlahCutiTahunan({super.key});

  @override
  State<JumlahCutiTahunan> createState() => _JumlahCutiTahunanState();
}

class _JumlahCutiTahunanState extends State<JumlahCutiTahunan> {
  final TextEditingController tanggalAwalController = TextEditingController();
  final TextEditingController tanggalAkhirController = TextEditingController();
  final TextEditingController tahunController = TextEditingController();
  final TextEditingController jumlahCutiController = TextEditingController();

  final inputListingCutiTahunan = ListCutiTahunan();

  String? _chosenTampilkan;
  String chosevalue = '20';
  int page = 1;
  int pageSize = 20;
  int tahun = 0;
  bool searchPerusahaan = false;
  bool isFetchingData = true;

  int _currentYear = DateTime.now().year;
  final int _minYear = 1900;

  Future<void> generate() async {
    int jumlahCuti = int.parse(jumlahCutiController.text);
    print('ini jumlah cuti :$jumlahCuti');
    await MasterCutiTahunanGenerateService().generateMasterJumlahCutiTahunan(
      tahunController.text,
      jumlahCuti,
      context,
    );
  }

  void _onChanged(num value) {
    if (value >= _minYear) {
      setState(() {
        _currentYear = value.toInt();
      });
    }
  }

  void _updateData() {
    DateTime now = DateTime.now();
    int year = now.year;
    // untuk update data
    setState(() {
      inputlistcutitahunan = [
        {
          'tanggal_generate': now.toString(),
          'tahun': year.toString(),
          'nama_perusahaan': '',
          'nama_karyawan': '',
          'email': '',
          'posisi': '',
          'kuota_cuti_tahunan': '',
          'tanggal_bergabung': '',
        }
      ];
      setState(() {
        inputlistcutitahunan = inputlistcutitahunan;
      });
    });
  }

// jika diklik
  // void _onGenerateButtonClicked() {
  //   _updateData();
  //   List<DataRow> dataRows = _getDataRows();
  // }

  List<dynamic> inputlistcutitahunan = [];
  @override
  void initState() {
    super.initState();
    print('DIJALANKAN');
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isFetchingData = true;
    });
    final data = await ListCutiTahunan().listcutitahunan(
      tahun: tahun,
      page: page,
      size: pageSize,
      order: 'asc',
      short_by: '',
      nama: '',
      search_perusahaan: false,
    );

    if (data != null && data is List<dynamic>) {
      setState(() {
        inputlistcutitahunan = data;
      });
    } else {
      print('Error fetching data');
    }

    setState(() {
      isFetchingData = false;
    });
  }

  @override
  void onPageChange(int newPage) {
    setState(() {
      page = newPage;
    });
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // List tahun = inputlistcutitahunan.map((e) => e['']).toList();
    // List tahun2023 = tahun.where((element) => element == '').toList();
    // print('TAHUN $tahun2023');
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
              'Jumlah Cuti Tahunan',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Search ',
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
              height: 15,
            ),
            Row(
              children: [
                SizedBox(
                  width: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 10, 10, 5),
                            hintText: '20',
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
                            '20',
                            '50',
                            '100',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(
                              () {
                                chosevalue = value!;
                                pageSize = int.parse(chosevalue);
                                fetchData();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          backgroundColor: darkgreen,
                          fixedSize: const Size(170, 50),
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
                                  height: 300,
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
                                          color: normalblue,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 11,
                                      ),
                                      const Text(
                                        'Generate Data',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
                                          color: black0,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            const Text(
                                              'Tahun',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: normalblue,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 1,
                                            ),
                                            NumberInputWithIncrementDecrement(
                                              controller: tahunController,
                                              numberFieldDecoration:
                                                  const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              widgetContainerDecoration:
                                                  const BoxDecoration(
                                                border: Border(
                                                  right: BorderSide.none,
                                                ),
                                              ),
                                              incIconDecoration:
                                                  const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide.none,
                                                ),
                                              ),
                                              incIconSize: 24,
                                              decIconSize: 24,
                                              initialValue:
                                                  _currentYear.toInt(),
                                              min: _minYear.toInt(),
                                              onChanged: _onChanged,
                                            ),
                                            const SizedBox(
                                              height: 12.13,
                                            ),
                                            const Text(
                                              'Jumlah Cuti',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: normalblue,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 1,
                                            ),
                                            NumberInputWithIncrementDecrement(
                                              controller: jumlahCutiController,
                                              min: 0,
                                              initialValue: 12,
                                              numberFieldDecoration:
                                                  const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              widgetContainerDecoration:
                                                  const BoxDecoration(
                                                border: Border(
                                                  right: BorderSide.none,
                                                ),
                                              ),
                                              incIconDecoration:
                                                  const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12.13,
                                      ),
                                      //untuk button berhasil ganerate
                                      ElevatedButton(
                                        onPressed: () {
                                          generate();
                                          Future.delayed(
                                              const Duration(milliseconds: 500),
                                              () {
                                            fetchData();
                                          });
                                        },
                                        child: const Text('Save'),
                                      ),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Text(
                          'Generate',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: white0,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
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
                    textAlign: TextAlign.center,
                  )),
                  DataColumn(
                    label: Text(
                      'Tanggal Ganerate',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Tahun',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Nama Perusahaan',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Nama Karyawan',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Email',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Posisi/Jabatan',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Jumlah Cuti',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Tanggal Bergabung',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Edit Cuti',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
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
                            DataCell(Text('')),
                            DataCell(Text('')),
                            DataCell(Text('')),
                          ],
                        ),
                      ]
                    : List<DataRow>.generate(
                        inputlistcutitahunan.length,
                        (int index) {
                          int rowIndex = (page - 1) * pageSize + index + 1;
                          return DataRow(cells: [
                            DataCell(Text(rowIndex.toString())),
                            DataCell(Text(inputlistcutitahunan[index]
                                    ['tanggal_generate']
                                .substring(0, 10))),
                            DataCell(Text(inputlistcutitahunan[index]['tahun']
                                .toString())),
                            DataCell(Text(inputlistcutitahunan[index]
                                ['nama_perusahaan'])),
                            DataCell(Text(
                                inputlistcutitahunan[index]['nama_karyawan'])),
                            DataCell(
                                Text(inputlistcutitahunan[index]['email'])),
                            DataCell(
                                Text(inputlistcutitahunan[index]['posisi'])),
                            DataCell(Text(inputlistcutitahunan[index]
                                    ['kuota_cuti_tahunan']
                                .toString())),
                            DataCell(Text(inputlistcutitahunan[index]
                                    ['tanggal_bergabung']
                                .toString())),
                            DataCell(
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
                                          EditMasterCutiTahunan(
                                        id: inputlistcutitahunan[index]['id'],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ]);
                        },
                      ).toList(),
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
                  onPressed: inputlistcutitahunan.length >= pageSize
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
