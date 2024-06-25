import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:project/services/pref_helper.dart';

class ListCutiTahunan {
  final url = 'http://192.168.2.155:8000/master_cuti_tahunan/hr/list';
  Dio dio = Dio();

  Future listcutitahunan({
    int page = 1,
    int size = 20,
    String order = '',
    String short_by = '',
    int tahun = 0,
    String nama = '',
    bool search_perusahaan = false,
  }) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };

      // Jika search_perusahaan = false, cari nama karyawan
      // Jika search_perusahaan = true, cari nama perusahaan
      final queryParameters = {
        'page': page,
        'size': size,
        'order': order,
        'tahun': tahun,
        'short_by': short_by,
        if (!search_perusahaan) 'nama': nama,
        if (search_perusahaan) 'nama_perusahaan': nama,
      };

      final response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        print('berhasil');
        return response.data;
      } else {
        print(response.statusCode);
      }
    } on DioError catch (e) {
      print(e.message);
      print(e.response);
      print(e.error);
    }
  }

  getLatestData() {}
}
