import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:project/services/pref_helper.dart';

///////////////////////untuk total karyawan /////////////////////////////////////////
class JumlahKaryawanService {
  final url = 'http://192.168.2.155:8000/user/hr/jumlah_karyawan';
  Dio dio = Dio();

  Future<int> jumlahKaryawan({
    int perusahaanId = 0,
  }) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };

      final response = await dio.get(url,
          options: Options(
            headers: headers,
          ),
          queryParameters: {
            'perusahaan_id': perusahaanId,
          });
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

///////////////////////untuk total cuti tahunan /////////////////////////////////////////
class TotalCutiKhususService {
  final url = 'http://192.168.2.155:8000/cuti_khusus/hr/jumlah_ijin_bulan';
  Dio dio = Dio();

  Future<int> totalCutiKhusus() async {
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

///////////////////////untuk total izin 3 jam /////////////////////////////////////////
class TotalIzin3JamService {
  final url = 'http://192.168.2.155:8000/ijin_3_jam/hr/jumlah_ijin_bulan';
  Dio dio = Dio();

  Future<int> totalIzin3Jam() async {
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

///////////////////////untuk total cuti tahunan /////////////////////////////////////////
class TotalCutiTahunanService {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/hr/jumlah_ijin_bulan';
  Dio dio = Dio();

  Future<int> totalCutiTahunan() async {
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

///////////////////////untuk total izin sakit/////////////////////////////////////////
class TotalIzinSakitService {
  final url = 'http://192.168.2.155:8000/ijin_sakit/hr/jumlah_ijin_bulan';
  Dio dio = Dio();

  Future<int> totalIzinSakit() async {
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

///////////////////////untuk total dinas/////////////////////////////////////////
class TotalDinasService {
  final url = 'http://192.168.2.155:8000/perjalanan_dinas/hr/jumlah_ijin_bulan';
  Dio dio = Dio();

  Future<int> totalDinas() async {
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
class CutiTahunanService {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/hr/jumlah_ijin_tahun';
  Dio dio = Dio();

  Future<int> cutiTahunan() async {
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
class CutiKhususTahunService {
  final url = 'http://192.168.2.155:8000/cuti_khusus/hr/jumlah_ijin_tahun';
  Dio dio = Dio();

  Future<int> cutiKhususTahun() async {
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

///////////////////////untuk Izin 3 Jam pertahun /////////////////////////////////////////
class Izin3JamTahunService {
  final url = 'http://192.168.2.155:8000/ijin_3_jam/hr/jumlah_ijin_tahun';
  Dio dio = Dio();

  Future<int> izin3JamTahun() async {
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

///////////////////////untuk Izin sakit pertahun /////////////////////////////////////////
class IzinSakitTahunService {
  final url = 'http://192.168.2.155:8000/ijin_sakit/hr/jumlah_ijin_tahun';
  Dio dio = Dio();

  Future<int> izinSakitTahun() async {
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

///////////////////////untuk Izin sakit pertahun /////////////////////////////////////////
class PerjalananDinasTahunService {
  final url = 'http://192.168.2.155:8000/perjalanan_dinas/hr/jumlah_ijin_tahun';
  Dio dio = Dio();

  Future<int> perjalananDinasTahun() async {
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
