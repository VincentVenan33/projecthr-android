import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project/color.dart';
import 'package:project/pengajuan/pengajuan_cuti_tahunan.dart';

import '../../pref_helper.dart';

class DeleteCutiTahunanService {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/delete';
  Dio dio = Dio();

  Future deleteCutiTahunan(int id, BuildContext context) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {"Authorization": 'Bearer $token'};
      final response = await dio.delete(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: {
          'id_ijin': id,
        },
        data: {
          'id_ijin': id,
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('sukses hapus');
        if (context.mounted) {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Container(
                    width: 278,
                    height: 270,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: white0,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 31,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(6)),
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
                          height: 24,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            backgroundColor: darkgreen,
                            fixedSize: const Size(120, 45),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PengajuanCutiTahunan(),
                              ),
                            );
                          },
                          child: const Text(
                            'Oke',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: white0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        }
      }
    } on DioError catch (e) {
      print('data gagall dihapus');
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
