import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/color.dart';
import 'package:project/services/changepass_service.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isPassword = true;
  bool isPassword2 = true;
  bool isPassword3 = true;

  final formKey = GlobalKey<FormState>();
  final TextEditingController passwordlama = TextEditingController();
  final TextEditingController passwordbaru = TextEditingController();
  final TextEditingController passwordbaru2 = TextEditingController();
  // String? errorPassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                top: 97,
              ),
              child: Text(
                'CHANGE PASSWORD',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: normalgreen,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 47,
                top: 52,
                right: 48,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 2,
                  ),
                  const Text(
                    'Password Lama',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextFormField(
                    controller: passwordlama,
                    // onChanged: (value) {},
                    inputFormatters: [LengthLimitingTextInputFormatter(20)],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password tidak boleh kosong";
                      } else if (value.length < 8 || value.length > 20) {
                        return 'minimal 8 karakter - maksimal 20 karakter';
                        // } else {
                        //   try {
                        //     Response response = await Dio().post('')
                        //   }
                        // } else {
                        //   return errorPassword;
                        // }
                      }
                      return null;
                    },
                    obscureText: isPassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {
                          isPassword = !isPassword;
                          setState(() {});
                        },
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'Password Lama',
                      hintStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Password Baru',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: black0,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    controller: passwordbaru,
                    inputFormatters: [LengthLimitingTextInputFormatter(20)],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password tidak boleh kosong';
                      } else if (value.length < 8 || value.length > 20) {
                        return 'minimal 8 karakter - maksimal 20 karakter';
                      } else if (value != passwordbaru.text) {
                        // return null;
                        return 'Password harus sama';
                      }
                      return null;
                      // return 'Password harus sama';
                    },
                    obscureText: isPassword2,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      hintText: 'Password Baru',
                      hintStyle: const TextStyle(fontSize: 14),
                      suffixIcon: IconButton(
                        onPressed: () {
                          isPassword2 = !isPassword2;
                          setState(() {});
                        },
                        icon: const Icon(Icons.visibility),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: black0,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Konfirmasi Password baru',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: black0,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    controller: passwordbaru2,
                    inputFormatters: [LengthLimitingTextInputFormatter(20)],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Konfirmasi tidak boleh kosong';
                      } else if (value.length < 8 || value.length > 20) {
                        return 'minimal 8 karakter - maksimal 20 karakter';
                      } else if (value != passwordbaru.text) {
                        // return null;
                        return 'Password harus sama';
                      }
                      return null;
                      // return 'Password harus sama';
                    },
                    obscureText: isPassword3,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      hintText: 'Konfirmasi',
                      hintStyle: const TextStyle(fontSize: 14),
                      suffixIcon: IconButton(
                        onPressed: () {
                          isPassword3 = !isPassword3;
                          setState(() {});
                        },
                        icon: const Icon(Icons.visibility),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: black0,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        fixedSize: const Size(265, 43),
                        backgroundColor: normalgreen,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                       onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (passwordbaru.text == passwordbaru2.text) {
                            ChangePassService().change(
                              passwordlama.text,
                              passwordbaru.text,
                              context,
                            );
                          }
                        }
                      })
                      // onPressed: () async {
                      //   if (passwordbaru.text == passwordbaru2.text) {
                      //     final result = await ChangePassService().change(
                      //       passwordlama.text,
                      //       passwordbaru.text,
                      //       context,
                      //     );
                      //     result.fold((l) {
                      //       errorPassword = 'OKE ${l.message}';
                      //     }, (r) => 'Oke');
                      //   }
                      // })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
