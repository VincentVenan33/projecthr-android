import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/home/dashboard/dashboard.dart';

import '../home/dashboard/dashboard_karyawan.dart';
import 'pref_helper.dart';

class ApiService {
  final url = 'http://192.168.2.155:8000/login';
  Future login(String email, String password, context) async {
    final response = await http.post(Uri.parse(url), body: {
      'username': email,
      'password': password,
    });
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      await PrefHelper().setToken(response.body);
      final responseData = json.decode(response.body);
      print(responseData);
      UserMeModel data = await userMe(responseData['access_token']);
      if (data.level == 'HR') {
        // Jika pengguna adalah HR
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
      } else {
        // Jika pengguna adalah karyawan
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const DashboarKaryawan()));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: 400,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 30,
                      decoration: const BoxDecoration(
                          color: Color(0xffFF8B8B),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          )),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Icon(
                      Icons.warning_rounded,
                      color: Color(0xffFF8B8B),
                      size: 120,
                    ),
                    const Text(
                      'Email Belum Terdaftar di Master Karyawan!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: const Color(0xffFF8B8B),
                        fixedSize: const Size(120, 43),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Oke',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }
  }
}

Future<UserMeModel> userMe(String token) async {
  final dataToken = token;
  final result = await Dio().get(
    'http://192.168.2.155:8000/user/me',
    options: Options(
      headers: {'Authorization': 'Bearer $dataToken'},
    ),
  );

  return UserMeModel.fromJson(result.data);
}

// To parse this JSON data, do
//
//     final userMeModel = userMeModelFromJson(jsonString);

class UserMeModel {
  UserMeModel({
    required this.namaKaryawan,
    required this.email,
    required this.alamat,
    required this.noHp,
    required this.level,
    required this.posisi,
    required this.tanggalBergabung,
    required this.status,
  });

  final String namaKaryawan;
  final String email;
  final String alamat;
  final String noHp;
  final String level;
  final String posisi;
  final DateTime tanggalBergabung;
  final String status;

  factory UserMeModel.fromRawJson(String str) =>
      UserMeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserMeModel.fromJson(Map<String, dynamic> json) => UserMeModel(
        namaKaryawan: json["nama_karyawan"],
        email: json["email"],
        alamat: json["alamat"],
        noHp: json["no_hp"],
        level: json["level"],
        posisi: json["posisi"],
        tanggalBergabung: DateTime.parse(json["tanggal_bergabung"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "nama_karyawan": namaKaryawan,
        "email": email,
        "alamat": alamat,
        "no_hp": noHp,
        "level": level,
        "posisi": posisi,
        "tanggal_bergabung":
            "${tanggalBergabung.year.toString().padLeft(4, '0')}-${tanggalBergabung.month.toString().padLeft(2, '0')}-${tanggalBergabung.day.toString().padLeft(2, '0')}",
        "status": status,
      };
}

// class ApiService2 {
//  final url = 'http://192.168.2.158:8000/user/change_password';
//   Future change(String passwordlama, String passwordbaru, context) async {
//     final response = await http.patch(Uri.parse(url), body: {
//       'password_lama': passwordlama,
//       'password_baru': passwordbaru,
      
//     });
//     final headers = {
//         "Authorization": 'Bearer $url',
//       };
//     print(response.body);
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       //menyimpan token ke lokal storage, lalu melakukan navigasi
//       await PrefHelper().setToken(response.body);
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => const Login()));
//     } else {
//       showDialog(
//           context: context,
//           builder: (context) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Container(
//                 width: 278,
//                 height: 250,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.white,
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       height: 31,
//                       decoration: const BoxDecoration(
//                         borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(8),
//                         ),
//                         color: Color(0xffFF8B8B),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     const Icon(
//                       Icons.warning_rounded,
//                       color: Color(0xffFF8B8B),
//                       size: 80,
//                     ),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     const Text(
//                       'Password gagal di ubah',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 20,
//                         color: black0,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 24,
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         backgroundColor: const Color(0xffFF8B8B),
//                         fixedSize: const Size(120, 43),
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Text(
//                         'Oke',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 20,
//                           color: white0,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           });
//     }
//   }
// }
