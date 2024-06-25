import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:project/services/pref_helper.dart';

class TotalKuotaCutiTahunanService {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/sisa_kuota';
  Dio dio = Dio();

  Future<int> totalKuotaCutiTahunan(int tahun) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };

      final response = await dio.get(url,
          options: Options(
            headers: headers,
          ),
          queryParameters: {
            'tahun': tahun,
          });
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('berhasil');
        print('TESTTST : ${response.data}');
        return response.data;
      } else {
        print('gagal');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
    return 0;
  }
}
