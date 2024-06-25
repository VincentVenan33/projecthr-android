import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/services/master/master_company/master_company_delete.dart';
import 'package:project/services/master/master_company/master_company_list.dart';
import 'package:project/services/master/master_company/master_company_service.dart';
import 'package:project/util/customappbar.dart';

import '../../../color.dart';
import '../../../util/navhr.dart';
import 'master_company_edit.dart';

String nama = '';

// perlu ditambah idPerusahaan ngga dibagian onPressed formkey.currentState! untuk edit data, nanti yang di edit hanya NAMA aja

class MasterCompany extends StatefulWidget {
  const MasterCompany({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MasterCompanyState createState() => _MasterCompanyState();
}

class _MasterCompanyState extends State<MasterCompany> {
  TextEditingController namaperusahaan = TextEditingController();
  TextEditingController searchPerusahaan = TextEditingController();

  String? chosevalue;
  var selectedItem = '';
  bool isFetchingData = true;
  int page = 1;
  int pageSize = 20;
  String order = '';
  String? filterNama;

  final formkey = GlobalKey<FormState>();

  // AREA TABLE CONTOH
  List<dynamic> dataPerusahaan = [];

  Future<void> fetchData() async {
    setState(() {
      isFetchingData = true;
    });
    final result = await PerusahaanListService().perusahaanList(
      page: page,
      size: pageSize,
      filterNama: filterNama,
      order: order,
    );
    if (result != null && result is List<dynamic>) {
      setState(() {
        dataPerusahaan = result;
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
  @override
  Widget build(BuildContext context) {
    print(dataPerusahaan);
    return Scaffold(
        appBar: const CustomAppBar(),
        drawer: const NavHr(),
        body: SafeArea(
            child: ListView(
                padding: const EdgeInsets.only(
                  top: 10,
                  right: 16,
                  left: 16,
                  bottom: 50,
                ),
                children: [
              const Text(
                'Company',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: searchPerusahaan,
                onFieldSubmitted: (value) {
                  filterNama = searchPerusahaan.text;
                  fetchData();
                },
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.only(
                    right: 170,
                    left: 7,
                  ),
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: const Color(0xff6D9DF9),
                      fixedSize: const Size(215, 45),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Form(
                                  key: formkey,
                                  child: Container(
                                      width: 280,
                                      height: 280,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                      child: Column(children: [
                                        Container(
                                          width: double.infinity,
                                          height: 31,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(8),
                                            ),
                                            color: Color(0xff6D9DF9),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Text(
                                          'Tambah Perusahaan',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            bottom: 10,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Text(
                                                'Nama Perusahaan',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextFormField(
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      100)
                                                ],
                                                validator: (value) {
                                                  if (value!.length < 3 ||
                                                      value.length > 100) {
                                                    return 'minimal 3 karakter - maksimal 100 karakter';
                                                  }
                                                  return null;
                                                },
                                                controller: namaperusahaan,
                                                decoration: InputDecoration(
                                                  hintText: '',
                                                  hintStyle: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  border: OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 24,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  backgroundColor:
                                                      const Color(0xff6D9DF9),
                                                  fixedSize:
                                                      const Size(120, 43),
                                                ),
                                                onPressed: () async {
                                                  if (formkey.currentState!
                                                      .validate()) {
                                                    MasterCompanyService()
                                                        .inputPerusahaan(
                                                      namaperusahaan.text,
                                                      context,
                                                    );
                                                  }
                                                },
                                                child: const Text(
                                                  'Save',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]))));
                        },
                      );
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.add),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          'Tambah Perusahaan',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: white0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: 90,
                    height: 55,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        hintText: '20',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: black0,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: black0,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: black0,
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
                            pageSize = int.parse(chosevalue!);
                            fetchData();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xff12EEB9)),
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'No',
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Nama Perusahaan',
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Action',
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
                                ],
                              ),
                            ]
                          : List<DataRow>.generate(dataPerusahaan.length,
                              (int index) {
                              int rowIndex = (page - 1) * pageSize + index + 1;
                              return DataRow(
                                onLongPress: () {
                                  // Navigate to another page with the id obtained from the API
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditMasterCompany(
                                        id: dataPerusahaan[index]['id'],
                                      ),
                                    ),
                                  );
                                },
                                cells: [
                                  DataCell(Text(rowIndex.toString())),
                                  DataCell(Text(dataPerusahaan[index]
                                      ['nama_perusahaan'] ??= "")),
                                  DataCell(
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(12, 12),
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditMasterCompany(
                                                  id: dataPerusahaan[index]
                                                      ['id'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Icon(
                                            Icons.edit,
                                            color: lightgray,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16.33,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(9.33, 12),
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
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
                                                    height: 250,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: white0,
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
                                                                    lightgray,
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
                                                                  fontSize: 20,
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
                                                                    normalyellow,
                                                                fixedSize:
                                                                    const Size(
                                                                        100,
                                                                        35.81),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                {
                                                                  CompanyDeleteService()
                                                                      .CompanyDelete(
                                                                          dataPerusahaan[index]
                                                                              [
                                                                              'id']);
                                                                }
                                                                fetchData();
                                                                Navigator.pop(
                                                                    context);
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return Dialog(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            278,
                                                                        height:
                                                                            250,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                          color:
                                                                              white0,
                                                                        ),
                                                                        child:
                                                                            Column(
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
                                                                              'Data Berhasil di Hapus',
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 20,
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
                                                                                Navigator.pop(context);
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
                                          child: const Icon(
                                            Icons.delete,
                                            color: normalred,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
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
                        onPressed:
                            page > 1 ? () => onPageChange(page - 1) : null,
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
                        onPressed: dataPerusahaan.length >= pageSize
                            ? () => onPageChange(page + 1)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ])));
  }
}
