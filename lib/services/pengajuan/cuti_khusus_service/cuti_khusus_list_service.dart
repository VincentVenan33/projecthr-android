import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project/services/pref_helper.dart';

class CutiKhususListService {
  final url = 'http://192.168.2.155:8000/cuti_khusus/list';
  Dio dio = Dio();

  Future getCutiKhususList({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    required String? tanggalAwal,
    required String? tanggalAkhir,
  }) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };
      final queryparameters = {
        'page': page,
        'size': size,
        'filter_status': filterStatus,
        if (tanggalAwal != null) 'filter_tanggal_awal': tanggalAwal,
        if (tanggalAkhir != null) 'filter_tanggal_akhir': tanggalAkhir,
      };
      final response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: queryparameters,
      );
      debugPrint('${response.statusCode}');
      if (response.statusCode == 200) {
        debugPrint('${response.data}');
        return response.data;
      } else {
        debugPrint('failed to fetch data');
      }
    } on DioError catch (e) {
      debugPrint('${e.error}');
      debugPrint(e.message);
      debugPrint('${e.response}');
    }
  }
}
