import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_app/auth/signup.dart';
import 'package:firebase_app/widgets/my_auth_button.dart';
import 'package:firebase_app/widgets/my_auth_logo.dart';
import 'package:firebase_app/widgets/my_textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;
  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Get.offNamed('/homePage');
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
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
                        "Login",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Login to continue using the app",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[400],
                        ),
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
                        obsecure: !showPassword,
                        suffixIconButton: IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: Icon(
                            !showPassword
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye,
                          ),
                        ),
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
                      InkWell(
                        splashColor: Colors.white,
                        onTap: () async {
                          if (emailController.text == '') {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: "Please Write Your Email First",
                            ).show();
                          } else {
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                      email: emailController.text);
                              AwesomeDialog(
                                // ignore: use_build_context_synchronously
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Password Reset',
                                desc:
                                    "Password Reset Link Has Been Sent To Your Email",
                              ).show();
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        child: const Align(
                          alignment: Alignment(1, 0),
                          child: Text(
                            "Forget Password?",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyAuthButton(
                        onPressed: () async {
                          if (formState.currentState!.validate()) {
                            try {
                              print(emailController.text);

                              print(passwordController.text);
                              setState(() {
                                isLoading = true;
                              });
                              final credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              setState(() {
                                isLoading = false;
                              });
                              if (credential.user!.emailVerified) {
                                String? token =
                                    await FirebaseMessaging.instance.getToken();
                                print("======================= TOKEN : ");
                                print(token);
                                Get.offNamed('/homePage');
                              } else {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc:
                                      "An Email Verification Link Has Been Sent To Your Email , Please Verifiy To Login",
                                ).show();
                              }
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: "Incorrect Email Or Password",
                              ).show();
                            }
                          } else {
                            print("!! Invalid Input values!!");
                          }
                        },
                        color: Colors.amber,
                        child: const Text("Login"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyAuthButton(
                        onPressed: () async {
                          await signInWithGoogle();
                        },
                        color: Colors.red[700]!,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Login With Google"),
                            const SizedBox(width: 5),
                            Image.asset(
                              "assets/images/google_logo.png",
                              width: 30,
                              height: 30,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't Have An Account ?"),
                          const SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () async {
                              await Get.offNamed('/signUp');
                            },
                            child: const Text(
                              "Register",
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
