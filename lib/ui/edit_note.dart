// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_app/ui/note_page.dart';
import 'package:firebase_app/widgets/my_auth_button.dart';
import 'package:firebase_app/widgets/my_textformfield.dart';

class EditNote extends StatefulWidget {
  final String categoryId;
  final String docId;
  final String oldText;
  final String? imagePath;
  const EditNote({
    Key? key,
    required this.categoryId,
    required this.docId,
    required this.oldText,
    this.imagePath,
  }) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController noteController = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  File? imageFile;
  // bool isLoading =
  bool isLoading = false;
  Future<void> editNote() {
    return FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection('notes')
        .doc(widget.docId)
        .update({
      'note_text': noteController.text,
      'image_path': imageFile == null ? '' : imageFile!.path,
    });
  }

  void getImage({required bool camera}) async {
    XFile? photo = await imagePicker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery);

    if (photo == null) return;
    imageFile = File(photo.path);

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noteController.text = widget.oldText;
    if (widget.imagePath != null && widget.imagePath != '') {
      imageFile = File(widget.imagePath!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Note")),
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
                              onPressed: () async {
                                getImage(camera: true);
                              },
                              icon: const Icon(Icons.camera_enhance),
                            ),
                            IconButton(
                              onPressed: () async {
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
                        hintText: "change your note",
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
                            await editNote();
                            isLoading = false;
                            DocumentSnapshot documentSnapshot =
                                await FirebaseFirestore.instance
                                    .collection('categories')
                                    .doc(widget.categoryId)
                                    .get();
                            Get.offUntil(
                              GetPageRoute(
                                page: () => NotePage(
                                  categoryId: widget.categoryId,
                                  categoryName:
                                      documentSnapshot['category_name'],
                                ),
                              ),
                              (route) =>
                                  route.settings.name == '/homePage' ||
                                  route.settings.name == '/',
                            );
                          }
                        },
                        color: Colors.amber,
                        child: const Text("Save"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
