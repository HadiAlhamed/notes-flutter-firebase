// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/ui/note_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:firebase_app/widgets/my_auth_button.dart';
import 'package:firebase_app/widgets/my_textformfield.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddNote extends StatefulWidget {
  final String categoryId;
  const AddNote({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  final TextEditingController noteController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  File? imageFile;
  // CollectionReference? categoryNotes;
  // bool isLoading =

  bool isLoading = false;
  void getImage({required bool camera}) async {
    XFile? photo = await imagePicker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery);

    if (photo == null) return;
    imageFile = File(photo.path);
    setState(() {});
  }

  Future<void> addNote() {
    // Call the user's CollectionReference to add a new user

    return FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection('notes')
        .add({
          'note_text': noteController.text,
          'image_path': imageFile == null ? '' : imageFile!.path,
        })
        .then((value) => print("Note Added"))
        .catchError((error) => print("Failed to add Note: $error"));
  }

  @override
  void dispose() {
    super.dispose();
    noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Note")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: formState,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: MyTextformfield(
                        addImageIcons: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                getImage(camera: true);
                              },
                              icon: const Icon(Icons.camera_enhance),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                getImage(camera: false);
                              },
                              icon: const Icon(Icons.image),
                            ),
                          ],
                        ),
                        imageFile: imageFile,
                        fieldHeight: 500,
                        expand: true,
                        mycontroller: noteController,
                        hintText: "Enter Your Note",
                        label: "Note",
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

                            await addNote();
                            isLoading = false;

                            DocumentSnapshot documentSnapshot =
                                await FirebaseFirestore.instance
                                    .collection('categories')
                                    .doc(widget.categoryId)
                                    .get();
                            print(
                                "category name is ${documentSnapshot['category_name']}");
                            Get.offUntil(
                              GetPageRoute(
                                page: () => NotePage(
                                  categoryId: widget.categoryId,
                                  categoryName:
                                      documentSnapshot['category_name'],
                                ),
                              ),
                              (route) {
                                print("hi hi");
                                print(route.settings.name);
                                return route.settings.name == '/homePage' ||
                                    route.settings.name == '/';
                              }, // Will clear all previous routes
                            );
                          }
                        },
                        color: Colors.amber,
                        child: const Text("Add Note"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
