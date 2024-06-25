import 'package:dio/dio.dart';

class LupapwService {
  final url = 'http://192.168.2.155:8000/forgot_password';
  Dio dio = Dio();

  Future<int> lupapw(String email) async {
    print('EMAIL $email');
    try {
      final response = await dio.post(
        url,
        queryParameters: {
          'emailAddress': email,
        },
      );
      print('RESPONSE : $response');

      if (response.statusCode == 200) {
        print('Berhasil');
        return response.data;
      } else {
        print(response.statusCode);
      }
    } on DioError catch (e) {
      print(e.message);
      print(e.response);
      print(e.error);
    }
    return 0; // nilai default jika terjadi error
  }

  // Future<int> verifikasi(String email, String token) async {
  //   try {
  //     final headers = {
  //       "Authorization": 'Bearer $token',
  //     };

  //     final response = await dio.post(
  //       '$url/verify',
  //       options: Options(
  //         headers: headers,
  //       ),
  //       queryParameters: {
  //         'emailAddress': email,
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       print('Berhasil');
  //       return response.data;
  //     } else {
  //       print(response.statusCode);
  //     }
  //   } on DioError catch (e) {
  //     print(e.message);
  //     print(e.response);
  //     print(e.error);
  //   }
  //   return 0; // nilai default jika terjadi error
  // }
}
