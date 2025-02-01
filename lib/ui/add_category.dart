import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/widgets/my_auth_button.dart';
import 'package:firebase_app/widgets/my_textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  // bool isLoading =
  bool isLoading = false;
  Future<void> addCategory() {
    // Call the user's CollectionReference to add a new user

    return categories
        .add({
          'category_name': nameController.text,
          'user_id': FirebaseAuth.instance.currentUser!.uid,
        })
        .then((value) => print("Category Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Category")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: formState,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: MyTextformfield(
                      mycontroller: nameController,
                      hintText: "Enter Category Name",
                      label: "Catergory Name",
                      validator: (val) {
                        if (val == null || val == '') {
                          return "Cannot Be Empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyAuthButton(
                      onPressed: () async {
                        if (formState.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          await addCategory();
                          isLoading = false;
                          Get.offAllNamed('/homePage');
                        }
                      },
                      color: Colors.amber,
                      child: const Text("Add"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
