import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:project/services/pref_helper.dart';

// statusnya ttep di masukin apa nggak, soalnya bagian input gaada tempat buat status.
class MasterKaryawanInputService {
  final url = 'http://192.168.2.155:8000/user/hr/input';
  Dio dio = Dio();

  Future masterInputkaryawan(
    int perusahaanId,
    String namakaryawan,
    String tempatlahir,
    String tanggallahir,
    String alamat,
    String nohp,
    String email,
    String password,
    String level,
    String posisi,
    String tanggalbergabung,
    // String status,
  ) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };
      final response = await dio.post(
        url,
        options: Options(
          headers: headers,
        ),
        data: {
          'perusahaan_id': perusahaanId,
          'nama_karyawan': namakaryawan,
          'tempat_lahir': tempatlahir,
          'tanggal_lahir': tanggallahir,
          'alamat': alamat,
          'no_hp': nohp,
          'email': email,
          'password': password,
          'level': level,
          'posisi': posisi,
          'tanggal_bergabung': tanggalbergabung,
          // 'status': status,
        },
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        print('Data berhasil diinput');
      } else {
        print('Terjadi kesalahan saat mengirim data');
      }
    } on DioError catch (e) {
      print(e.message);
      print(e.response);
      print(e.error);
    }
  }
}
