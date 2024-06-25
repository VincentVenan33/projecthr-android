import 'dart:convert';

import 'package:dio/dio.dart';

import '../../pref_helper.dart';

class LogCutiTahunanListServices {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/hr/list';
  Dio dio = Dio();

  Future logCutiTahunanListServices({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    required String? filterNama,
    required String? tanggalAwal,
    required String? tanggalAkhir,
  }) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
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
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('failed to fetch data');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
