// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:firebase_app/widgets/my_auth_button.dart';
import 'package:firebase_app/widgets/my_textformfield.dart';

class EditCategory extends StatefulWidget {
  final String docId;
  const EditCategory({
    super.key,
    required this.docId,
  });

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  // bool isLoading =
  bool isLoading = false;
  Future<void> editCategory() {
    return categories.doc(widget.docId).update({
      'category_name': nameController.text,
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Category")),
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
                      hintText: "Enter Category New Name",
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
                          await editCategory();
                          isLoading = false;
                          Get.offAllNamed('/homePage');
                        }
                      },
                      color: Colors.amber,
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
