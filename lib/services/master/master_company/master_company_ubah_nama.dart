import 'dart:convert';

import 'package:dio/dio.dart';

import '../../pref_helper.dart';

class EditCompanyService {
  final url = 'http://192.168.2.155:8000/perusahaan/ubah_nama';
  Dio dio = Dio();

  Future editCompany(int id, String nama) async {
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
          'id_perusahaan': id,
          'nama': nama,
        },
        data: {
          'nama': nama,
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Succes!!!');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}




// class EditCompanyService {
//   final url = 'https://8f9a-182-253-109-7.ap.ngrok.io/perusahaan/ubah_nama';
//   Dio dio = Dio();
//   Future<Map<String, dynamic>?> editCompany(
//       int id, String nama) async {
//     try {
//       final response = await dio.patch(
//         '$url/$id',
//         data: {
//           'nama': nama,
//         },
//       );
//       return response.data;
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }
// }

// const idString = '11';
// final id = int.parse(idString); // mengonversi String ke int
// const nama = 'kepo';

// class EditDataService {
//   final url = 'http://your-api.com/edit_data';
//   Dio dio = Dio();

//   Future editData(
//     int id, // ID data yang akan di edit
//     String newData, // Data baru
//   ) async {
//     try {
//       final tokenResponse = await PrefHelper().getToken() ?? '';
//       final tokenJson = jsonDecode(tokenResponse);
//       final token = tokenJson['access_token'];
//       final headers = {
//         "Authorization": 'Bearer $token',
//       };
//       final response = await dio.patch(
//         '$url/$id', // Tambahkan ID pada URL
//         options: Options(
//           headers: headers,
//         ),
//         data: {
//           'new_data': newData,
//         },
//       );
//       print(response.statusCode);
//       if (response.statusCode == 200) {
//         print('Data berhasil di edit');
//       } else {
//         print('Gagal mengedit data');
//       }
//     } on DioError catch (e) {
//       print(e.error);
//       print(e.message);
//       print(e.response);
//     }
//   }
// }

