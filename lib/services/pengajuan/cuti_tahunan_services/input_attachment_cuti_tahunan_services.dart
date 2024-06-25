import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:project/services/pref_helper.dart';

class CutiTahunanInputAttachmentServices {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/input_attachment';
  Dio dio = Dio();

  Future cutiTahunanInputAttachment(int id, List<File> files) async {
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
        options: Options(
          headers: headers,
        ),
        queryParameters: {
          'id_ijin': id,
        },
        data: formData,
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print('success');
      } else {
        print('Failed');
      }
    } on DioError catch (e) {
      print(id);
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
