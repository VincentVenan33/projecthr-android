import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../pref_helper.dart';

class EditizinSakitServices {
  final url = 'http://192.168.2.155:8000/ijin_sakit/update';
  Dio dio = Dio();

  Future editIzinSakit(int id, String judul, String tanggalAwal,
      String tanggalAkhir, BuildContext context) async {
    try {
      final tokenRespons = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenRespons);
      final token = tokenJson['access_token'];
      final headerss = {
        "Authorization": 'Bearer $token',
      };
      final response = await dio.post(
        url,
        options: Options(
          headers: headerss,
        ),
        data: {
          'judul': judul,
          'tanggal_awal': tanggalAwal,
          'tanggal_akhir': tanggalAkhir,
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Sukses');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
