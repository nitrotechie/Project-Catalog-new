import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({Key? key}) : super(key: key);

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final TextEditingController projectSummary = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loadingScreen = false;
  final TextEditingController projectTitle = TextEditingController();
  final firebase = FirebaseFirestore.instance;
  final ImagePicker? _picker = ImagePicker();
  XFile? _imageFile;
  File? file;
  File? pfile;
  var fileName = '';
  var destination = '';
  var currentUser = FirebaseAuth.instance.currentUser;
  String url =
      "https://firebasestorage.googleapis.com/v0/b/movielist-8dc17.appspot.com/o/ml_logo.png?alt=media&token=461e3c32-11c3-467e-90d6-b945d634e5bd";

  // getPdf() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: [
  //       'pdf',
  //     ],
  //   );
  //   if (result != null) {
  //     print(result);
  //   }
  // }

  getImage() async {
    final XFile? pickedFile =
        await _picker?.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
        final path = _imageFile!.path;
        file = File(path);
      });
    }
  }

  uploadImage() async {
    if (file == null) return;

    fileName = basename(file!.path);
    destination = fileName;
    final ref = FirebaseStorage.instance.ref(destination);
    TaskSnapshot uploadFile = await ref.putFile(file!);
    if (uploadFile.state == TaskState.success) {
      url = await ref.getDownloadURL();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Project Detail"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: projectTitle,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Theme.of(context).buttonColor,
                            ),
                          ),
                          hintText: "Enter Project Title",
                          labelText: "Project Title",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter a Project Name";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        maxLines: 10,
                        controller: projectSummary,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Theme.of(context).buttonColor,
                            ),
                          ),
                          hintText: "Enter Project Summary",
                          labelText:
                              "Project Summary \n \n \n \n \n \n \n \n \n \n \n \n",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Project Summary";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: projectSummary,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Theme.of(context).buttonColor,
                            ),
                          ),
                          hintText: "Enter Any Addition details (if any)",
                          labelText: "Additional Detail",
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () async {
                          await getImage();
                        },
                        child: const Text("Choose Image"),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _imageFile == null
                            ? Image.asset(
                                "assets/images/default.gif",
                                fit: BoxFit.fill,
                              )
                            : Image.file(File(_imageFile!.path)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // TextButton(
                      //   onPressed: () async {
                      //     await getPdf();
                      //   },
                      //   child: const Text("Choose PDF"),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
