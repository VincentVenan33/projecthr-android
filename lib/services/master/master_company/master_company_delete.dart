import 'dart:convert';

import 'package:dio/dio.dart';

import '../../pref_helper.dart';

class CompanyDeleteService {
  final url = 'http://192.168.2.155:8000/perusahaan/delete';
  Dio dio = Dio();

  // CompanyDeleteService(companyDelete);

  Future CompanyDelete(int idPerusahaan) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };
      final response = await dio.delete(url,
          options: Options(
            headers: headers,
          ),
          queryParameters: {
            'id_perusahaan': idPerusahaan
          },
          data: {
            'id_perusahaan': idPerusahaan,
          });
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('berhasil di hapus');
      } else {
        print('gagal dihapus');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
