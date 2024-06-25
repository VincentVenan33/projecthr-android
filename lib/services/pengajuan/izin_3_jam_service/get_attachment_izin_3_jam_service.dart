import 'dart:convert';

import 'package:dio/dio.dart';

import '../../pref_helper.dart';

class GetAttachmentIzin3JamService {
  final url = 'http://192.168.2.155:8000/ijin_3_jam/list_attachment';
  Dio dio = Dio();

  Future getAttachmentIzin3Jam(int id) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };
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
        print('dapet mas');
        // print(response.data);
        return response.data;
      } else {
        print('ga dapet');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
