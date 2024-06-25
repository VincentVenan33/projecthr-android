import 'dart:convert';

// import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
// import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project/home/login/login.dart';
import 'package:project/services/pref_helper.dart';

import '../color.dart';

// class ErrorMessage extends Equatable {
//   final String message;
//   const ErrorMessage(this.message);

//   @override
//   List<Object?> get props => [message];
// }

class ChangePassService {
  final url = 'http://192.168.2.155:8000/user/change_password';
  Dio dio = Dio();
  Future change(String passwordlama, String passwordbaru, context) async {
    // Future<Either<ErrorMessage, String>> change(
    //     String passwordlama, String passwordbaru, context) async {
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
          'password_lama': passwordlama,
          'password_baru': passwordbaru,
        },
      );
      print('RESPONSE : ${response.data}');
      print('RESPONSE : ${response.statusCode}');

      if (response.statusCode == 200) {
        // return response.data.toString();
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  width: 278,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: white0,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 31,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          color: darkgreen,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Icon(
                        Icons.check_circle,
                        color: normalgreen,
                        size: 80,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Password Berhasil di Ubah',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: black0,
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
                          backgroundColor: darkgreen,
                          fixedSize: const Size(120, 45),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: const Text(
                          'Oke',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: white0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  width: 278,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: white0,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 31,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          color: lightred,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: lightred,
                        size: 80,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Password Gagal di ubah',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: black0,
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
                          backgroundColor: lightred,
                          fixedSize: const Size(120, 45),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Oke',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: white0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return 'Failed to change password';
      }
    } catch (e) {
      // menangani kesalahan yang terjadi saat melakukan permintaan
      if (e is DioError) {
        if (e.response != null) {
          // jika server memberikan respons, cetak pesan kesalahan dari server
          print(e.response!.data);
        } else {
          // jika tidak ada respons dari server, cetak pesan kesalahan dari Dio
          print(e.message);
        }
      } else {
        // jika kesalahan bukan berasal dari Dio, cetak pesan kesalahan secara umum
        print(e.toString());
      }
    }
  }

  //   return const Right('Failed to change password');
  // } on DioError catch (e) {
  //   return Left(ErrorMessage(e.response!.data['detail']));
  // }
}
