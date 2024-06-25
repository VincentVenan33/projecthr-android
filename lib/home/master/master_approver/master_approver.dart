import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:project/services/master/master_approver/master_approver_delete.dart';
import 'package:project/services/master/master_approver/master_approver_input.dart';
import 'package:project/util/customappbar.dart';

import '../../../color.dart';
import '../../../services/master/master_approver/master_approver_list.dart';
import '../../../services/master/master_approver/master_approver_list_approver_service.dart';
import '../../../util/navhr.dart';

class MasterApprover extends StatefulWidget {
  const MasterApprover({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MasterApproverState createState() => _MasterApproverState();
}

class SubjectModel {
  String subjectId;
  String subjectName;
  SubjectModel({
    required this.subjectId,
    required this.subjectName,
  });
}

class _MasterApproverState extends State<MasterApprover> {
  TextEditingController tambahapprover = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController namaapprover = TextEditingController();
  TextEditingController namakaryawan = TextEditingController();
  TextEditingController searchApprover = TextEditingController();

  // ignore: unused_field
  final int _selectedIndex = 0;
  String? chosevalue;
  String? choseappr;
  int? selectedId;
  var selectedItem = '';
  bool isPassword = true;
  bool isChecked = false;
  final formKey = GlobalKey<FormState>();
  bool isFetchingData = true;
  int page = 1;
  int pageSize = 20;
  int id = 0;
  bool selectAll = false;
  String? filterNama;
  // AREA TABLE CONTOH
  List<dynamic> dataApprover = [];
  String? _selectedKaryawan;
  final List<dynamic> _karyawanList = [];
  String? _selectedApprover;
  List<dynamic> _approverList = [];
  final ListingApproverService _ListingApproverService =
      ListingApproverService();
  List<dynamic> approvers = [];

  Future<void> fetchData() async {
    setState(() {
      isFetchingData = true;
    });
    final result = await ListingApproverService().listingApprover(
      page: page,
      size: pageSize,
      id: id,
      filterNama: filterNama,
    );
    if (result != null && result is List<dynamic>) {
      setState(() {
        dataApprover = result;
      });
    } else {
      print('Error fetching data');
    }
    final listApproverService = ListApproverService();
    final data = await listApproverService.listApprover(filterNama: null);
    final mappedData = data
        .map((item) => MultiSelectItem(item['id'], item['nama_karyawan']))
        .toList();
    setState(() {
      isFetchingData = false;
      approvers = mappedData;
    });
  }

  int getApproverId(String approverName) {
    final approver = _approverList
        .firstWhere((item) => item['nama_approver'] == approverName);
    return approver['id'];
  }

  Future<void> _getApproverList() async {
    try {
      final approverList = await _ListingApproverService.getApproverList();
      setState(() {
        _approverList = approverList;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getApproverList();
    fetchData().then((_) {
      setState(() {
        isFetchingData = false;
        fetchData();
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
    // final appDataController = Get.find<AppDataController>();
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
                'Approval',
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
                controller: searchApprover,
                onFieldSubmitted: (value) {
                  filterNama = searchApprover.text;
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
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    backgroundColor: const Color(0xff6D9DF9),
                    fixedSize: const Size(195, 45),
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
                                key: formKey,
                                child: Container(
                                    width: 280,
                                    height: 350,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: Column(children: [
                                      Expanded(
                                          child: ListView(children: [
                                        Container(
                                          width: double.infinity,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                            color: Color(0xff6D9DF9),
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(8),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        const Text(
                                          'Tambah Approval',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 35,
                                            right: 35,
                                            bottom: 150,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Text(
                                                'Nama Approver',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                height: 50,
                                                child:
                                                    TypeAheadFormField<dynamic>(
                                                  textFieldConfiguration:
                                                      TextFieldConfiguration(
                                                    controller: namaapprover,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Pilih Approver',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1,
                                                          color: black0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  suggestionsCallback:
                                                      (pattern) async {
                                                    final ListApproverService
                                                        service =
                                                        ListApproverService();
                                                    final List<dynamic>
                                                        suggestions =
                                                        await service
                                                            .listApprover(
                                                      filterNama: pattern,
                                                    );
                                                    return suggestions;
                                                  },
                                                  itemBuilder: (context,
                                                      dynamic suggestion) {
                                                    return ListTile(
                                                      title: Text(suggestion[
                                                          'nama_karyawan']),
                                                    );
                                                  },
                                                  onSuggestionSelected:
                                                      (dynamic suggestion) {
                                                    selectedId =
                                                        suggestion['id'];
                                                    namaapprover.text =
                                                        suggestion[
                                                            'nama_karyawan'];
                                                    debugPrint(
                                                        'ID Approver : $selectedId');
                                                  },
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Masukkan Nama Approver';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              const Text(
                                                'Nama Karyawan',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              MultiSelectDialogField(
                                                items: [
                                                  MultiSelectItem("select_all",
                                                      "Pilih Semua"),
                                                  ...approvers.cast<
                                                      MultiSelectItem<
                                                          Object?>>()
                                                ],
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border:
                                                      Border.all(color: black0),
                                                ),
                                                buttonIcon: const Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Colors.black,
                                                ),
                                                buttonText: const Text(
                                                  "Pilih Karyawan",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                searchHint: 'Cari Karyawan',
                                                searchIcon:
                                                    const Icon(Icons.search),
                                                searchable: true,
                                                closeSearchIcon:
                                                    const Icon(Icons.close),
                                                onConfirm: (results) {
                                                  List<String> selectedItems =
                                                      [];
                                                  if (results
                                                      .contains("select_all")) {
                                                    selectedItems.addAll(
                                                        approvers.map((e) => e
                                                            .value
                                                            .toString()));
                                                  } else {
                                                    for (var item in results) {
                                                      selectedItems
                                                          .add(item.toString());
                                                    }
                                                  }
                                                  print(
                                                      'Selected items: $selectedItems');
                                                },
                                                chipDisplay:
                                                    MultiSelectChipDisplay(
                                                  scroll: true,
                                                  onTap: (item) {
                                                    setState(() {
                                                      approvers.remove(item);
                                                    });
                                                  },
                                                  icon:
                                                      const Icon(Icons.cancel),
                                                  chipColor: Colors.transparent,
                                                  textStyle: const TextStyle(
                                                    color: black0,
                                                  ),
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
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    MasterInputApprover()
                                                        .inputMasterApprover(
                                                            getApproverId(
                                                              _selectedApprover!,
                                                            ),
                                                            namakaryawan.text);
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Container(
                                                              width: 400,
                                                              height: 300,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    height: 30,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                            color:
                                                                                Color(0xff05DAA7),
                                                                            borderRadius: BorderRadius.vertical(
                                                                              top: Radius.circular(8),
                                                                            )),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 16,
                                                                  ),
                                                                  const Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    color: Color(
                                                                        0xff05DAA7),
                                                                    size: 120,
                                                                  ),
                                                                  const Text(
                                                                    'Data Berhasil di Tambah',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 24,
                                                                  ),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                      ),
                                                                      backgroundColor:
                                                                          const Color(
                                                                              0xff05DAA7),
                                                                      fixedSize:
                                                                          const Size(
                                                                              120,
                                                                              43),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                const MasterApprover()),
                                                                      );
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      'Oke',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
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
                                      ]))
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
                        'Tambah Approval',
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                              'Nama Approver',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Nama Karyawan',
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
                                    DataCell(Text('')),
                                  ],
                                ),
                              ]
                            : List<DataRow>.generate(dataApprover.length,
                                (int index) {
                                int rowIndex =
                                    (page - 1) * pageSize + index + 1;
                                return DataRow(
                                  cells: [
                                    DataCell(Text(rowIndex.toString())),
                                    DataCell(Text(dataApprover[index]
                                        ['nama_approver'] ??= "")),
                                    DataCell(Text(dataApprover[index]
                                        ['nama_karyawan'] ??= "")),
                                    DataCell(
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(12, 12),
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                            ),
                                            onPressed: () {},
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
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Container(
                                                      width: 278,
                                                      height: 250,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
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
                                                                    .circular(
                                                                        8),
                                                              ),
                                                              color:
                                                                  normalyellow,
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
                                                                        BorderRadius
                                                                            .circular(8),
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
                                                                child:
                                                                    const Text(
                                                                  'Cancel',
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
                                                              const SizedBox(
                                                                width: 34,
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
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
                                                                  if (dataApprover[
                                                                              index]
                                                                          [
                                                                          'id'] !=
                                                                      null) {
                                                                    ApproverDeleteService().approverDelete(
                                                                        dataApprover[index]
                                                                            [
                                                                            'id']);
                                                                  }
                                                                  fetchData();
                                                                  print(
                                                                      'Data successfully deleted and fetched new data: ${dataApprover.toString()}');
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
                          onPressed: dataApprover.length >= pageSize
                              ? () => onPageChange(page + 1)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ])
            ])));
  }
}
