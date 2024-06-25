import 'dart:convert';

import 'package:dio/dio.dart';

import '../../pref_helper.dart';

class EditApproverService {
  final url = 'http://192.168.2.155:8000/approver/hr/update';
  Dio dio = Dio();

  Future editApprover(
    int id,
    int approverID,
    int karyawanID,
  ) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };

      final response = await dio.patch(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: {
          'id': id,
        },
        data: {'approver_id': approverID, 'karyawan_id': karyawanID},
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Succes!!!');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
