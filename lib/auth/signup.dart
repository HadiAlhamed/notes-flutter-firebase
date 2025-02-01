import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_app/auth/login.dart';
import 'package:firebase_app/widgets/my_auth_button.dart';
import 'package:firebase_app/widgets/my_auth_logo.dart';
import 'package:firebase_app/widgets/my_textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // final TextEditingController cPasswordController = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: formState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      const MyAuthLogo(),
                      const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Register to start using the app",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyTextformfield(
                        mycontroller: usernameController,
                        hintText: "Enter your username",
                        label: "Username",
                        validator: (String? val) {
                          if (val == null || val == '') {
                            return "Cannot Be Empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyTextformfield(
                        mycontroller: emailController,
                        hintText: "Enter your email",
                        label: "Email",
                        validator: (String? val) {
                          if (val == null || val == '') {
                            return "Cannot Be Empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyTextformfield(
                        mycontroller: passwordController,
                        hintText: "Enter your password",
                        label: "Password",
                        validator: (String? val) {
                          if (val == null || val == '') {
                            return "Cannot Be Empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      //forget password
                      MyAuthButton(
                        onPressed: () async {
                          if (formState.currentState!.validate()) {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              final credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );

                              await FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification();
                              setState(() {
                                isLoading = false;
                              });

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                animType: AnimType.rightSlide,
                                title: 'Email Verification',
                                desc:
                                    'An Email Verification Has Been Sent To Your Email , Please Verify To Login',
                              ).show();
                              await Get.off(
                                () => const Login(),
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                log('The password provided is too weak.');
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc: 'The password provided is too weak.',
                                ).show();
                              } else if (e.code == 'email-already-in-use') {
                                log('The account already exists for that email.');
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc:
                                      'The account already exists for that email.',
                                ).show();
                              }
                            } catch (e) {
                              log(e.toString());
                            }
                          } else {
                            print("!!Not valid input!!");
                          }
                        },
                        color: Colors.amber,
                        child: const Text("Register"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already Have An Account ?"),
                          const SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () async {
                              await Get.offNamed('/');
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
