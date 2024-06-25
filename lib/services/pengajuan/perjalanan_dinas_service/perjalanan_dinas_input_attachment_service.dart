import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project/services/pref_helper.dart';

class PerjalananDinasInputAttachmentService {
  final url = 'http://192.168.2.155:8000/perjalanan_dinas/input_attachment';
  Dio dio = Dio();

  Future perjalananDinasInputAttachment(int id, List<File> files) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };

      List<MultipartFile> multipartFiles = [];
      for (int i = 0; i < files.length; i++) {
        String fileName = files[i].path.split('/').last;
        multipartFiles.add(
          await MultipartFile.fromFile(files[i].path, filename: fileName),
        );
      }

      FormData formData = FormData.fromMap({
        "id_ijin": id,
        "input_baru": multipartFiles,
      });

      final response = await dio.post(
        url,
        options: Options(headers: headers),
        queryParameters: {'id_ijin': id},
        data: formData,
      );
      debugPrint('${response.statusCode}');
      if (response.statusCode == 200) {
        debugPrint('Succes!');
      } else {
        debugPrint('Failed!');
      }
    } on DioError catch (e) {
      debugPrint('$id');
      debugPrint('${e.error}');
      debugPrint('${e.response}');
      debugPrint(e.message);
    }
  }
}
