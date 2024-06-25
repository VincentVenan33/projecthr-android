import 'package:flutter/material.dart';
import 'package:project/services/pref_helper.dart';

import '../color.dart';
import '../home/login/change_pass.dart';
import '../home/login/login.dart';
import '../services/user_service.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: UserNameService().userName('') as Future<Map<String, dynamic>>?,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        String namaKaryawan = "";
        if (snapshot.hasData) {
          namaKaryawan = snapshot.data!['nama_karyawan'];
        }
        print(namaKaryawan);
        return AppBar(
          title: Align(
            alignment: Alignment.centerRight,
            child: Text(namaKaryawan),
          ),
          actions: [
            PopupMenuButton<String>(
              offset: const Offset(0, 50),
              itemBuilder: (_) {
                return [
                  PopupMenuItem<String>(
                    padding: EdgeInsets.zero,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.zero,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangePassword(),
                            ),
                          );
                        },
                        child: const Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: black0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem<String>(
                    padding: EdgeInsets.zero,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.zero,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          PrefHelper().removeToken();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: const Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: black0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ];
              },
            ),
          ],
          backgroundColor: const Color(0xff2B60C6),
        );
      },
    );
  }
}
