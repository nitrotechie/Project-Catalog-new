import 'dart:io';
import 'dart:typed_data';
// ignore: depend_on_referenced_packages
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_catalog/screens/home_screen.dart';
import 'package:project_catalog/services/services.dart';
import 'package:project_catalog/utils/themes.dart';
import 'package:uuid/uuid.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({Key? key}) : super(key: key);

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final TextEditingController projectSummary = TextEditingController();
  final TextEditingController additionalDetails = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loadingScreen = false;
  final TextEditingController projectTitle = TextEditingController();
  final firebase = FirebaseFirestore.instance;
  final ImagePicker? _picker = ImagePicker();
  PlatformFile? imageFile;
  File? pFile;
  File? iFile;
  PlatformFile? pdfResult;
  var fileName = '';
  var destination = '';
  var currentUser = FirebaseAuth.instance.currentUser;
  var uuid = const Uuid();
  var projectId = "";
  String pdfUrl = "";
  String imageUrl =
      "https://firebasestorage.googleapis.com/v0/b/project-catalog-modified.appspot.com/o/download.png?alt=media&token=7c52bb3c-a6a7-4000-a325-d56419b165a1";
  String date = DateTime.now().toString();
  var wordCount = 0;
  var changeButton = false;

  List<String> list = <String>[
    'Please Select Catagory',
    'Computer',
    'Mechanical',
    'Robotics',
    'Civil',
    'Electronics',
    'Electronics & Communication',
  ];
  var dropDownValue = 'Please Select Catagory';
  @override
  void initState() {
    super.initState();
    projectId = uuid.v1();
    Data.getUsername();
  }

  getPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
      ],
    );
    if (result != null) {
      setState(() {
        pdfResult = result.files.first;
        final path = pdfResult!.path;
        pFile = File(path!);
      });
    }
  }

  getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg',
        'gif',
      ],
    );

    if (result != null) {
      setState(() {
        imageFile = result.files.first;
        final path = imageFile!.path;
        iFile = File(path!);
      });
    }
  }

  uploadPdf() async {
    if (pFile == null) return;
    fileName = projectId + basename(pFile!.path);
    destination = fileName;
    final ref = FirebaseStorage.instance.ref(destination);
    TaskSnapshot uploadFile = await ref.putFile(pFile!);
    if (uploadFile.state == TaskState.success) {
      pdfUrl = await ref.getDownloadURL();
    }
  }

  uploadImage() async {
    if (iFile == null) return;
    fileName = projectId + basename(iFile!.path);
    destination = fileName;
    final ref = FirebaseStorage.instance.ref(destination);
    TaskSnapshot uploadFile = await ref.putFile(iFile!);
    if (uploadFile.state == TaskState.success) {
      imageUrl = await ref.getDownloadURL();
    }
  }

  addData() async {
    await firebase.collection("data").doc(projectId).set({
      "projectId": projectId,
      "name": projectTitle.text,
      "author": Data.userName,
      "summary": projectSummary.text,
      "additionalDetails": additionalDetails.text,
      "imageUrl": imageUrl,
      "pdfUrl": pdfUrl,
      "date": Data.getDate(date),
      "catagory": dropDownValue,
      "uid": currentUser!.uid,
    });
    var info = firebase
        .collection("data")
        .doc(currentUser!.uid)
        .collection("data")
        .snapshots();
    print(info);
  }

  openFile(PlatformFile file) {
    OpenFilex.open(file.path);
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
                        maxLines: 5,
                        controller: projectSummary,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Theme.of(context).buttonColor,
                            ),
                          ),
                          hintText: "Enter Project Summary",
                          labelText: "Project Summary",
                        ),
                        onChanged: (value) {
                          RegExp regExp = RegExp(" ");
                          wordCount = regExp.allMatches(value).length + 1;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Project Summary";
                          } else if (wordCount < 50) {
                            return "Please Write Atleast 50 Words";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: additionalDetails,
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
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                              value: dropDownValue,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  dropDownValue = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          ],
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
                        child: imageFile == null
                            ? Image.asset(
                                "assets/images/default.gif",
                                fit: BoxFit.fill,
                              )
                            : Image.file(File(imageFile!.path!)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () async {
                          await getPdf();
                        },
                        child: const Text("Choose PDF"),
                      ),
                      pdfResult == null
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.lightBlue.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                        child: Icon(Icons.picture_as_pdf)),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pdfResult!.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            print("object");
                                            openFile(pdfResult!);
                                          },
                                          child: const Text("View File"),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                        child: IconButton(
                                      icon: const Icon(Icons.cancel),
                                      onPressed: () {
                                        setState(() {
                                          pdfResult = null;
                                        });
                                      },
                                    ))
                                  ],
                                ),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: Container(
                          width: changeButton == true ? 35 : 300,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                  MyTheme.gradientColor1,
                                  MyTheme.gradientColor2,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25)),
                          child: changeButton == true
                              ? const CircularProgressIndicator()
                              : TextButton(
                                  child: const Text(
                                    "Add Project",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  onPressed: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    if (dropDownValue ==
                                        'Please Select Catagory') {
                                      final snackBar = SnackBar(
                                        content: const Text(
                                            "Please Select Catagory"),
                                        action: SnackBarAction(
                                          label: "Ok",
                                          textColor:
                                              Theme.of(context).canvasColor,
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                    if (imageFile == null) {
                                      final snackBar = SnackBar(
                                        content: const Text(
                                            "Please Upload An Image."),
                                        action: SnackBarAction(
                                          label: "Ok",
                                          textColor:
                                              Theme.of(context).canvasColor,
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                    if (pdfResult == null) {
                                      final snackBar = SnackBar(
                                        content:
                                            const Text("Please Upload A Pdf."),
                                        action: SnackBarAction(
                                          label: "Ok",
                                          textColor:
                                              Theme.of(context).canvasColor,
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                    if (_formKey.currentState!.validate() &&
                                        imageFile != null &&
                                        pdfResult != null &&
                                        dropDownValue !=
                                            'Please Select Catagory') {
                                      setState(() {
                                        changeButton = true;
                                      });
                                      await uploadImage();
                                      await uploadPdf();
                                      addData();
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen(),
                                        ),
                                      );
                                    }
                                  },
                                ),
                        ),
                      ),
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
