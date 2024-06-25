import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../pref_helper.dart';

class CutiKhususDownloadService {
  Dio dio = Dio();

  Future cutiKhususDownload(int idFile, String fileName) async {
    try {
      String url =
          'http://192.168.2.155:8000/cuti_khusus/get_attachment/$idFile';
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };
      // final directory = await getExternalStorageDirectory();
      // Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
      // final savePath = "${generalDownloadDir!.path}/$fileName";
      final directory = await getExternalStorageDirectory();
      final savePath = "${directory!.path}/$fileName";

      debugPrint('ini direktori : $directory');
      debugPrint('ini savepath : $savePath');

      final response = await dio.download(
        url,
        savePath,
        options: Options(
          headers: headers,
          responseType: ResponseType.bytes,
        ),
        queryParameters: {
          'id_file': idFile,
        },
      );

      debugPrint('${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('Download Succes!!!');
      }
    } on DioError catch (e) {
      debugPrint('Failed!!!');
      debugPrint('${e.error}');
      debugPrint(e.message);
      debugPrint('${e.response}');
    }
  }
}
