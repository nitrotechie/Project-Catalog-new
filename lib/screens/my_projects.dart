import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project_catalog/screens/project_detail.dart';
import 'package:project_catalog/services/services.dart';
import 'package:project_catalog/utils/methods.dart';
import 'package:project_catalog/utils/themes.dart';
import 'package:project_catalog/widgets/custom_drawer.dart';

class MyProjectScreen extends StatefulWidget {
  const MyProjectScreen({Key? key}) : super(key: key);

  @override
  State<MyProjectScreen> createState() => _MyProjectScreenState();
}

class _MyProjectScreenState extends State<MyProjectScreen> {
  final firebase = FirebaseFirestore.instance;
  var currentUser = FirebaseAuth.instance.currentUser;
  MyTheme theme = MyTheme();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Theme.of(context).cardColor,
                Theme.of(context).canvasColor,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(builder: (context) {
                        return GestureDetector(
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                boxShadow: MyTheme.neumorpShadow,
                                borderRadius: BorderRadius.circular(10)),
                            child: Data.image == "null" || Data.image == ""
                                ? const Icon(Icons.person)
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(Data.image),
                                  ),
                          ),
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                        );
                      }),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    Methods.greeting(),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Methods.greetingIcon(),
                                ],
                              ),
                              Text(
                                Data.userName,
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          boxShadow: MyTheme.neumorpShadow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: Icon(
                              theme.isDark ? Icons.sunny : Icons.dark_mode),
                          onPressed: () {
                            theme.isDark = !theme.isDark;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text(
                    "Your Project",
                    style: TextStyle(
                      fontSize: 30,
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: firebase
                      .collection("data")
                      .doc("All")
                      .collection("data")
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, i) {
                              QueryDocumentSnapshot x = snapshot.data!.docs[i];

                              return x['uid'] == currentUser!.uid
                                  ? FittedBox(
                                      fit: BoxFit.fill,
                                      child: GestureDetector(
                                        onTap: () {
                                          Project.additionalDetails =
                                              x['additionalDetails'];
                                          Project.author = x['author'];
                                          Project.catagory = x['catagory'];
                                          Project.date = x['date'];
                                          Project.pdfUrl = x['pdfUrl'];
                                          Project.imageUrl = x['imageUrl'];
                                          Project.summary = x['summary'];
                                          Project.name = x['name'];
                                          Project.projectId = x['projectId'];
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const ProjectDetailScreen()));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(20),
                                          padding: const EdgeInsets.all(10),
                                          width: size.width,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .cardColor
                                                .withOpacity(0.4),
                                            boxShadow: MyTheme.neumorpShadow,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      x["catagory"],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () async {
                                                      Project.projectId =
                                                          x['projectId'];
                                                      Project.catagory =
                                                          x['catagory'];
                                                      await Project
                                                          .deleteProject();
                                                      setState(() {});
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: FadeInImage.assetNetwork(
                                                  placeholder:
                                                      "assets/images/default.gif",
                                                  image: x['imageUrl'],
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15, bottom: 5),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        x['author'],
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      x['date'],
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                x['name'],
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                x['summary'],
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w100),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container();
                            },
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
