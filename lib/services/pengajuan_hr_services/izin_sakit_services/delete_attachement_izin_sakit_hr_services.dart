import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project/color.dart';

import '../../pref_helper.dart';

class IzinSakitDeleteAttachmentHRServices {
  final url = '';
  Dio dio = Dio();

  Future izinSakitDeleteAttachmentHR(
      int id, int attachmentId, BuildContext context) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headerss = {"Authorization": 'Bearer $token'};
      final response = await dio.delete(
        url,
        options: Options(
          headers: headerss,
        ),
        queryParameters: {
          'id_ijin': id,
          'hapus_id': attachmentId,
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Sukses menghapus file');
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
                  height: 270,
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
                            top: Radius.circular(6),
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
                        'Attachment Berhasil dihapus',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: black0,
                        ),
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
                        },
                        child: const Text(
                          'Oke',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
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
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
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
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                        color: normalred,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Icon(
                      Icons.warning_amber,
                      color: normalred,
                      size: 80,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Attachment gagal dihapus',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: black0,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        backgroundColor: normalred,
                        fixedSize: const Size(120, 45),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Oke',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
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
    }
  }
}
