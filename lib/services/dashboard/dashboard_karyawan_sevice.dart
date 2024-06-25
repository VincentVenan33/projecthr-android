import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:project/services/pref_helper.dart';

///////////////////////untuk total karyawan /////////////////////////////////////////
class SisaCutiTahunanKaryawanService {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/sisa_kuota';
  Dio dio = Dio();

  Future<int> sisaCutiTahunanKaryawan({
    String tahun = '',
  }) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };
      final tahunSekarang = DateTime.now().year.toString();

      final response = await dio.get(
        '$url?tahun=$tahunSekarang',
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        print('berhasil');
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
}

///////////////////////untuk total karyawan /////////////////////////////////////////
class Izin3JamKaryawanService {
  final url = 'http://192.168.2.155:8000/ijin_3_jam/jumlah_ijin_bulan';
  Dio dio = Dio();

  Future<int> izin3JamKaryawan() async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };

      final response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        print('berhasil');
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
}

///////////////////////untuk cuti tahunan pertahun /////////////////////////////////////////
class CutiTahunanKaryawanTahunService {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/jumlah_ijin_tahun';
  Dio dio = Dio();

  Future<int> cutiTahunanKaryawanTahun() async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };

      final response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        print('berhasil');
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
}

///////////////////////untuk cuti khusus pertahun /////////////////////////////////////////
class CutiKhususKaryawanTahunService {
  final url = 'http://192.168.2.155:8000/cuti_khusus/jumlah_ijin_tahun';
  Dio dio = Dio();

  Future<int> cutiKhususKaryawanTahun() async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };

      final response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        print('berhasil');
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
}

///////////////////////untuk izin 3 jam pertahun /////////////////////////////////////////
class Izin3JamKaryawanTahunService {
  final url = 'http://192.168.2.155:8000/ijin_3_jam/jumlah_ijin_tahun';
  Dio dio = Dio();

  Future<int> izin3JamKaryawanTahun() async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };

      final response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        print('berhasil');
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
}

///////////////////////untuk izin sakit pertahun /////////////////////////////////////////
class IzinSakitKaryawanTahunService {
  final url = 'http://192.168.2.155:8000/ijin_sakit/jumlah_ijin_tahun';
  Dio dio = Dio();

  Future<int> izinSakitKaryawanTahun() async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };

      final response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        print('berhasil');
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
}

///////////////////////untuk izin sakit pertahun /////////////////////////////////////////
class PerjalananDinasKaryawanTahunService {
  final url = 'http://192.168.2.155:8000/perjalanan_dinas/jumlah_ijin_tahun';
  Dio dio = Dio();

  Future<int> perjalananDinasKaryawanTahun() async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };

      final response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        print('berhasil');
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
}
