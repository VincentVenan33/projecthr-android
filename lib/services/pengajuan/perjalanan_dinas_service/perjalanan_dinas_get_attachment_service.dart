import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../pref_helper.dart';

class PerjalananDinasGetAttachmentService {
  final url = 'http://192.168.2.155:8000/perjalanan_dinas/list_attachment';
  Dio dio = Dio();

  Future getAttachmentPerjalananDinas(int id) async {
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

      debugPrint('${response.statusCode}');
      if (response.statusCode == 200) {
        debugPrint('File muncul!!!');
        // debugPrint(response.data);
        return response.data;
      } else {
        debugPrint('File kosong!!!');
      }
    } on DioError catch (e) {
      debugPrint('${e.error}');
      debugPrint(e.message);
      debugPrint('${e.response}');
    }
  }
}
