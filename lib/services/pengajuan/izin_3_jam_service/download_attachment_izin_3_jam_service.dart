import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../pref_helper.dart';

class DownloadAttachmentIzin3JamService {
  Dio dio = Dio();

  Future downloadAttachmentIzin3Jam(int idFile, String fileName) async {
    try {
      String url =
          'http://192.168.2.155:8000/ijin_3_jam/get_attachment/$idFile';
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };
      final directory = await getExternalStorageDirectory();
      final savePath = "${directory!.path}/$fileName";

      print('ini direktori : $directory');
      print('ini savepath : $savePath');

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

      print(response.statusCode);

      if (response.statusCode == 200) {
        print('sukses download');
      }
    } on DioError catch (e) {
      print('gagal mas e');
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}

// import 'dart:convert';
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';

// import '../pref_helper.dart';

// class DownloadAttachmentIzin3JamService {
//   Dio dio = Dio();

//   Future<File?> downloadAttachmentIzin3Jam(int idFile) async {
//     try {
//       String url =
//           'http://192.168.2.158:8000/ijin_3_jam/get_attachment/$idFile';
//       final tokenResponse = await PrefHelper().getToken() ?? '';
//       final tokenJson = jsonDecode(tokenResponse);
//       final token = tokenJson['access_token'];
//       final headers = {
//         "Authorization": 'Bearer $token',
//       };

//       // Generate the filename based on the idFile
//       String filename = 'attachment_$idFile';

//       // Get the path to the Download folder on Android
//       Directory? downloadsDirectory = await getExternalStorageDirectory();
//       if (downloadsDirectory == null) {
//         print('Unable to get downloads directory');
//         return null;
//       }
//       String filePath = '${downloadsDirectory.path}/$filename';

//       final response = await dio.download(
//         url,
//         filePath,
//         options: Options(
//           headers: headers,
//         ),
//         queryParameters: {
//           'id_file': idFile,
//         },
//       );

//       print(response.statusCode);
//       if (response.statusCode == 200) {
//         print('sukses download');
//         return File(filePath);
//       }
//     } on DioError catch (e) {
//       print('gagal mas e');
//       print(e.error);
//       print(e.message);
//       print(e.response);
//     }
//     return null;
//   }
// }

