import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/color.dart';
import 'package:project/home/login/login.dart';

class GantiPw extends StatefulWidget {
  const GantiPw({super.key});

  @override
  State<GantiPw> createState() => _GantiPwState();
}

class _GantiPwState extends State<GantiPw> {
  bool isPassword = true;
  bool isPassword2 = true;

  final formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
//     if (_passwordController.text == _confirmpasswordController.text) {
// //berhasil
//     } else {
//       //gagal
//     }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 47,
            left: 48,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Lupa Password',
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
                const Text(
                  'Password',
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
                  controller: _passwordController,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password wajib di isi';
                    } else if (value.length < 8 || value.length > 20) {
                      return 'minimal 8 karakter - maksimal 20 karakter';
                    } else if (value != _confirmpasswordController.text) {
                      // return null;
                      return 'Password harus sama';
                    }
                    return null;
                    // return 'Password harus sama';
                  },
                  obscureText: isPassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                    ),
                    hintText: 'Password baru',
                    hintStyle: const TextStyle(color: black0, fontSize: 14),
                    suffixIcon: IconButton(
                      onPressed: () {
                        isPassword = !isPassword;
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
                  controller: _confirmpasswordController,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Konfirmasi password wajib di isi';
                    } else if (value.length < 8 || value.length > 20) {
                      return 'minimal 8 karakter - maksimal 20 karakter';
                    } else if (value != _passwordController.text) {
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
                    hintText: 'Konfirmasi',
                    hintStyle: const TextStyle(color: black0, fontSize: 14),
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
                      if (_passwordController.text ==
                          _confirmpasswordController.text) {
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
                                      'Password berhasil di ubah',
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
                                            builder: (context) => const Login(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Save',
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
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
