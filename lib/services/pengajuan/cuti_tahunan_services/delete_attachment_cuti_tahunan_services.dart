import 'dart:convert';

import 'package:dio/dio.dart';

import '../../pref_helper.dart';

class DeleteAttachmentCutiTahunanServices {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/delete_attachment';
  Dio dio = Dio();

  Future deleteAttachmentCutiTahunan(int id, int attachmentId) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {"Authorization": 'Bearer $token'};
      final response = await dio.delete(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: {
          'id_ijin': id,
          'hapus_id': attachmentId,
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('sukses hapus');
      } else {
        print('gagal hapus');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
