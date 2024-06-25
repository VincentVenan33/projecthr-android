import 'package:flutter/material.dart';
import 'package:project/color.dart';
import 'package:project/home/login/ganti_pw.dart';
import 'package:project/services/lupa_pw_services.dart';

class LupaPw extends StatefulWidget {
  const LupaPw({super.key});

  @override
  State<LupaPw> createState() => _LupaPwState();
}

final formKey = GlobalKey<FormState>();
final emailController = TextEditingController();

class _LupaPwState extends State<LupaPw> {
  // final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  bool sudahdiisi = false;
  String email = '';
  Future<void> kirimEmail() async {
    try {
      print('EMAILLLL : $email');
      await LupapwService().lupapw(email);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(
            top: 150,
            left: 20,
            right: 20,
          ),
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Lupa Password',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: normalgreen,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              textAlign: TextAlign.center,
              'Masukan email yang anda gunakan ketika mendaftar dan kita akan mengirimkan petunjuk untuk mengganti password',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 16,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: darkgray,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email harus diisi';
                        } else if (!value.contains('@') ||
                            !value.contains('.')) {
                          return 'Email harus mengandung "@" dan "."';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.contains('@') && value.contains('.')) {
                          sudahdiisi = true;
                          email = emailController.text;
                          print(email);
                        } else {
                          sudahdiisi = false;
                        }
                        setState(() {});
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.mail,
                        ),
                        hintText: 'Email',
                        hintStyle: const TextStyle(
                          color: darkgray,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: lightgreen,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        fillColor: white0,
                        filled: true,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        backgroundColor: normalgreen,
                        fixedSize: const Size(335, 44),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          kirimEmail();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  width: 278,
                                  height: 310,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
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
                                        'Pesan email telah dikirim ke email anda',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          color: black0,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          text: 'Bila belum menerima klik\n',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: black0,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'kirim lagi',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: normalgreen,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          backgroundColor: darkgreen,
                                          fixedSize: const Size(120, 43),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const GantiPw(),
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
                      },

                      /// untuk syarat
                      // onPressed: sudahdiisi
                      //     ? () {
                      //         if (formKey.currentState!.validate()) {
                      //         }
                      //         // Navigator.push(
                      //         //   context,
                      //         //   MaterialPageRoute(
                      //         //     builder: (context) => const GantiPw(),
                      //         //     // untuk Register yg benar
                      //         //   ),
                      //         // );
                      //       }
                      //     : null,
                      child: const Text(
                        'Kirim',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
