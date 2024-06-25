import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../pref_helper.dart';

class DownloadAttachmentCutiTahunanServices {
  // final url = '';
  Dio dio = Dio();

  Future downloadAttachmenCutiTahunan(int idFile, String filename) async {
    try {
      String url =
          'http://192.168.2.155:8000/cuti_tahunan/get_attachment/$idFile';
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {"Authorization": 'Bearer $token'};
      final directory = await getExternalStorageDirectory();
      final savePath = "${directory!.path}/file.pdf";
      final response = await dio.download(
        url,
        (await getTemporaryDirectory()).path,
        options: Options(
          headers: headers,
        ),
        queryParameters: {'id_file': idFile},
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print("${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('sukses download');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
