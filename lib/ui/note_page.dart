// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/auth/login.dart';
import 'package:firebase_app/ui/add_note.dart';
import 'package:firebase_app/ui/edit_note.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_app/ui/edit_category.dart';

class NotePage extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  const NotePage({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  bool isLoading = true;

  List<QueryDocumentSnapshot> data = [];
  getData() async {
    setState(() {
      isLoading = true;
    });
    print(FirebaseAuth.instance.currentUser!.uid);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryId)
        .collection('notes')
        .get();
    data.addAll(querySnapshot.docs);
    print("fetched notes");
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.categoryName} Notes"),
        actions: [
          IconButton(
            tooltip: "Clear All Notes",
            icon: const Icon(Icons.cleaning_services),
            onPressed: () {
              AwesomeDialog(
                alignment: Alignment.center,
                animType: AnimType.rightSlide,
                dialogType: DialogType.warning,
                desc: "Are You Sure You Want To Delete All Notes ?",
                context: context,
                btnCancelText: "Cancel",
                btnCancelOnPress: () {},
                btnOkText: "Clear All",
                btnOkOnPress: () async {
                  setState(() {
                    isLoading = true;
                  });
                  CollectionReference<Map<String, dynamic>> notes =
                      FirebaseFirestore.instance
                          .collection("categories")
                          .doc(widget.categoryId)
                          .collection('notes');
                  for (int index = 0; index < data.length; index++) {
                    await notes.doc(data[index].id).delete();
                  }
                  data.clear();
                  setState(() {
                    isLoading = false;
                  });
                },
              ).show();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) => InkWell(
                onTap: () async {
                  await Get.to(
                    () => EditNote(
                      docId: data[index].id,
                      categoryId: widget.categoryId,
                      oldText: data[index]['note_text'],
                      imagePath: data[index]['image_path'],
                    ),
                  );
                },
                onLongPress: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: 'Delete',
                    desc: "Are You Sure You want To Delete This Note ?",
                    btnOkText: "Delete",
                    btnCancelText: "Cancel",
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      print("delete button");
                      setState(() {
                        isLoading = true;
                      });
                      await FirebaseFirestore.instance
                          .collection('categories')
                          .doc(widget.categoryId)
                          .collection('notes')
                          .doc(data[index].id)
                          .delete();
                      setState(() {
                        data.removeAt(index);
                        isLoading = false;
                      });
                    },
                  ).show();
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(data[index]['note_text']),
                          data[index]['image_path'] == null ||
                                  data[index]['image_path'] == ''
                              ? const SizedBox()
                              : Image.file(
                                  File(data[index]['image_path']),
                                  fit: BoxFit.contain,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
            () => AddNote(
              categoryId: widget.categoryId,
            ),
            transition: Transition.fadeIn,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
