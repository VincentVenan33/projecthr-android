import 'dart:convert';

import 'package:dio/dio.dart';

import '../../pref_helper.dart';

class NeedConfirmCutiTahunanListServices {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/hr/list';
  Dio dio = Dio();

  Future needConfirmCutiTahunanList({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    required String? filterNama,
    required String? tanggalAwal,
    required String? tanggalAkhir,
  }) async {
    try {
      final tokenRespons = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenRespons);
      final token = tokenJson['access_token'];
      final headers = {"Authorization": 'Bearer $token'};
      final queryparameters = {
        'page': page,
        'size': size,
        'filter_status': filterStatus,
        if (filterNama != null) 'filter_nama': filterNama,
        if (tanggalAwal != null) 'filter_tanggal_awal': tanggalAwal,
        if (tanggalAkhir != null) 'filter_tanggal_akhir': tanggalAkhir,
      };
      final response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: queryparameters,
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        print(response.data);
        return response.data;
      } else {
        print('failed to fetch data');
      }
    } on DioError catch (e) {
      print(e);
    }
  }
}
