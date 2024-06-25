import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../pref_helper.dart';

class EditIzin3JamService {
  final url = 'http://192.168.2.155:8000/ijin_3_jam/update';
  Dio dio = Dio();

  Future editIzin3Jam(int id, String judul, String tanggal, String waktuAwal,
      String waktuAkhir, BuildContext context) async {
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
          'id_ijin': id,
        },
        data: {
          'judul': judul,
          'tanggal_ijin': tanggal,
          'waktu_awal': waktuAwal,
          'waktu_akhir': waktuAkhir,
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print('sukses');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
