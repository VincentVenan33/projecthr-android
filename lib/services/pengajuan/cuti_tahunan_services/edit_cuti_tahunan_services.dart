import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project/services/pref_helper.dart';

class CutiTahunanEditServices {
  final url = 'http://192.168.2.155:8000/ijin_sakit/update';
  Dio dio = Dio();

  Future cutiTahunanEdit(int id, String judul, String tanggalAwal,
      String tanggalAkhir, BuildContext context) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {"Authorization": 'Bearer $token'};
      final response = await dio.patch(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: {
          'id_ijin': id,
        },
        data: {
          'judul': judul,
          'tanggal_awal': tanggalAwal,
          'tanggal_akhir': tanggalAkhir,
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print('success');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
