import 'dart:convert';

import 'package:dio/dio.dart';

import '../../pref_helper.dart';

class GetAttachmenCutiTahunanServices {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/list_attachment';
  Dio dio = Dio();

  Future getAttachmentCutiTahunan(int id) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {"Authorization": 'Bearer $token'};
      final response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: {
          'id_ijin': id,
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('dapat');
        return response.data;
      } else {
        print('gagal');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
