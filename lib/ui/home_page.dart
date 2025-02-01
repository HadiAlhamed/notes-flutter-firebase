import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/auth/login.dart';
import 'package:firebase_app/ui/edit_category.dart';
import 'package:firebase_app/ui/note_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  List<QueryDocumentSnapshot> data = [];
  getData() async {
    setState(() {
      isLoading = true;
    });
    print(FirebaseAuth.instance.currentUser!.uid);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
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
    print(Get.routing.current);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            tooltip: "sign out",
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              print(Get.routing.current);
              Get.offUntil(
                GetPageRoute(
                  page: () => const Login(),
                ),
                (route) => false,
              );
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
                onTap: () {
                  Get.to(
                    () => NotePage(
                      categoryId: data[index].id,
                      categoryName: data[index]['category_name'],
                    ),
                    transition: Transition.fade,
                  );
                },
                onLongPress: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: 'Edit',
                    desc: "Do You Want To Delete Or Edit ?",
                    btnCancelText: "Delete",
                    btnOkText: "Edit",
                    btnCancelOnPress: () async {
                      print("delete button");
                      setState(() {
                        isLoading = true;
                      });
                      await FirebaseFirestore.instance
                          .collection('categories')
                          .doc(data[index].id)
                          .delete();
                      setState(() {
                        data.removeAt(index);
                        isLoading = false;
                      });
                    },
                    btnOkOnPress: () async {
                      Get.to(
                        () => EditCategory(
                          docId: data[index].id,
                        ),
                      );
                    },
                  ).show();
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/folder.png',
                          width: 100,
                          height: 100,
                        ),
                        Text(data[index]['category_name']),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/addCategory');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
