import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_catalog/screens/add_project.dart';
import 'package:project_catalog/screens/project_detail.dart';
import 'package:project_catalog/services/services.dart';
import 'package:project_catalog/utils/methods.dart';
import 'package:project_catalog/utils/themes.dart';
import 'package:project_catalog/widgets/catagory_card.dart';
import 'package:project_catalog/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final firebase = FirebaseFirestore.instance;
  var currentUser = FirebaseAuth.instance.currentUser;
  MyTheme theme = MyTheme();
  Data d = Data();
  List newslist = [];
  bool loading = false;
  bool select = true;
  var zero = true;
  var one = false;
  var two = false;
  var thr = false;
  var fur = false;
  var fiv = false;
  var six = false;
  var display = "All";
  var search = false;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getUserName();
    getImage();
  }

  getUserName() async {
    await Data.getUsername();
  }

  getImage() async {
    await Data.getImage();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<MyTheme>(builder: (context, MyTheme theme, child) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            size: 40,
          ),
          onPressed: () {
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddProjectScreen()));
            } else {
              final snackBar = SnackBar(
                content: const Text("Please Login to Add a Project."),
                action: SnackBarAction(
                  label: "Ok",
                  textColor: Theme.of(context).canvasColor,
                  onPressed: () {},
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
        ),
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
                                      borderRadius: BorderRadius.circular(23),
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
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
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
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      "Explore",
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      "Engineering Projects",
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).canvasColor,
                          ],
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: TextField(
                        controller: searchController,
                        textAlign: TextAlign.justify,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              search = false;
                            });
                          } else {
                            setState(() {
                              search = true;
                            });
                          }
                        },
                        style: TextStyle(
                          color: Colors.grey.shade300,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            size: 25,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                          hintText: "Search Projects",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade300,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        CategoryCard(
                          title: "All",
                          onTap: () {
                            setState(() {
                              display = "All";
                              zero = true;
                              one = false;
                              two = false;
                              thr = false;
                              fur = false;
                              fiv = false;
                              six = false;
                            });
                          },
                          selected: zero,
                        ),
                        CategoryCard(
                          title: "Computer",
                          onTap: () {
                            setState(() {
                              display = "Computer";
                              zero = false;
                              one = true;
                              two = false;
                              thr = false;
                              fur = false;
                              fiv = false;
                              six = false;
                            });
                          },
                          selected: one,
                        ),
                        CategoryCard(
                          title: "Mechanical",
                          onTap: () {
                            setState(() {
                              display = "Mechanical";
                              zero = false;
                              one = false;
                              thr = false;
                              fur = false;
                              fiv = false;
                              six = false;
                              two = true;
                            });
                          },
                          selected: two,
                        ),
                        CategoryCard(
                          title: "Robotics",
                          onTap: () {
                            setState(() {
                              display = "Robotics";
                              zero = false;
                              one = false;
                              two = false;
                              thr = true;
                              fur = false;
                              fiv = false;
                              six = false;
                            });
                          },
                          selected: thr,
                        ),
                        CategoryCard(
                          title: "Civil",
                          onTap: () {
                            setState(() {
                              display = "Civil";
                              zero = false;
                              one = false;
                              two = false;
                              thr = false;
                              fur = true;
                              fiv = false;
                              six = false;
                            });
                          },
                          selected: fur,
                        ),
                        CategoryCard(
                          title: "Electronics",
                          onTap: () {
                            setState(() {
                              display = "Electronics";
                              zero = false;
                              one = false;
                              two = false;
                              thr = false;
                              fur = false;
                              fiv = true;
                              six = false;
                            });
                          },
                          selected: fiv,
                        ),
                        CategoryCard(
                          title: "Elec&Comm",
                          onTap: () {
                            setState(() {
                              display = "Electronics & Communication";
                              zero = false;
                              one = false;
                              two = false;
                              thr = false;
                              fur = false;
                              fiv = false;
                              six = true;
                            });
                          },
                          selected: six,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: firebase
                        .collection("data")
                        .doc(display)
                        .collection("data")
                        .snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? ListView.builder(
                              shrinkWrap: true,
                              reverse: true,
                              physics: const ScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, i) {
                                QueryDocumentSnapshot x =
                                    snapshot.data!.docs[i];
                                String name = x['name'];
                                String projectName = name.toLowerCase();
                                print(projectName);
                                String summary = x['summary'];
                                String projectSummary = summary.toLowerCase();
                                String keyword = x['additionalDetails'];
                                String projectKeyword = keyword.toLowerCase();
                                String author = x['author'];
                                String projectAuthor = author.toLowerCase();
                                print(projectAuthor);
                                String date = x['date'];
                                String projectDate = date.toLowerCase();
                                String catagory = x['catagory'];
                                String projectCatagory = catagory.toLowerCase();
                                return search == false
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
                                                    Project.bookmark.contains(
                                                            x['projectId'])
                                                        ? IconButton(
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                Project.projectId =
                                                                    x['projectId'];
                                                              });
                                                              await Project
                                                                  .deleteBookmark();
                                                              setState(() {});
                                                            },
                                                            icon: const Icon(
                                                              Icons.bookmark,
                                                              size: 30,
                                                            ),
                                                          )
                                                        : IconButton(
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                Project.projectId =
                                                                    x['projectId'];
                                                              });
                                                              User? user =
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser;
                                                              if (user !=
                                                                  null) {
                                                                await Project
                                                                    .addBookmark();
                                                                await Project
                                                                    .getBookmark();
                                                                setState(() {});
                                                              } else {
                                                                final snackBar =
                                                                    SnackBar(
                                                                  content:
                                                                      const Text(
                                                                          "Please Login to bookmark a project."),
                                                                  action:
                                                                      SnackBarAction(
                                                                    label: "Ok",
                                                                    textColor: Theme.of(
                                                                            context)
                                                                        .canvasColor,
                                                                    onPressed:
                                                                        () {},
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        snackBar);
                                                              }
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .bookmark_border,
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
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        "assets/images/default.gif",
                                                    image: x['imageUrl'],
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15, bottom: 5),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          x['author'],
                                                          style:
                                                              const TextStyle(
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
                                    : (projectName.contains(
                                                searchController
                                                    .text
                                                    .toLowerCase()) ||
                                            projectSummary
                                                .contains(
                                                    searchController
                                                        .text
                                                        .toLowerCase()) ||
                                            projectKeyword
                                                .contains(
                                                    searchController
                                                        .text
                                                        .toLowerCase()) ||
                                            projectCatagory
                                                .contains(
                                                    searchController
                                                        .text
                                                        .toLowerCase()) ||
                                            projectDate.contains(
                                                searchController.text
                                                    .toLowerCase()) ||
                                            projectAuthor.contains(
                                                searchController.text
                                                    .toLowerCase()))
                                        ? FittedBox(
                                            fit: BoxFit.fill,
                                            child: GestureDetector(
                                              onTap: () {
                                                Project.additionalDetails =
                                                    x['additionalDetails'];
                                                Project.author = x['author'];
                                                Project.catagory =
                                                    x['catagory'];
                                                Project.date = x['date'];
                                                Project.pdfUrl = x['pdfUrl'];
                                                Project.imageUrl =
                                                    x['imageUrl'];
                                                Project.summary = x['summary'];
                                                Project.name = x['name'];
                                                Project.projectId =
                                                    x['projectId'];
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            const ProjectDetailScreen()));
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(20),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                width: size.width,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .cardColor
                                                      .withOpacity(0.4),
                                                  boxShadow:
                                                      MyTheme.neumorpShadow,
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
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            x["catagory"],
                                                          ),
                                                        ),
                                                        Project.bookmark
                                                                .contains(x[
                                                                    'projectId'])
                                                            ? IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  setState(() {
                                                                    Project.projectId =
                                                                        x['projectId'];
                                                                  });
                                                                  await Project
                                                                      .deleteBookmark();
                                                                  setState(
                                                                      () {});
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .bookmark,
                                                                  size: 30,
                                                                ),
                                                              )
                                                            : IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  setState(() {
                                                                    Project.projectId =
                                                                        x['projectId'];
                                                                  });
                                                                  User? user =
                                                                      FirebaseAuth
                                                                          .instance
                                                                          .currentUser;
                                                                  if (user !=
                                                                      null) {
                                                                    await Project
                                                                        .addBookmark();
                                                                    await Project
                                                                        .getBookmark();
                                                                    setState(
                                                                        () {});
                                                                  } else {
                                                                    final snackBar =
                                                                        SnackBar(
                                                                      content:
                                                                          const Text(
                                                                              "Please Login to bookmark a project."),
                                                                      action:
                                                                          SnackBarAction(
                                                                        label:
                                                                            "Ok",
                                                                        textColor:
                                                                            Theme.of(context).canvasColor,
                                                                        onPressed:
                                                                            () {},
                                                                      ),
                                                                    );
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            snackBar);
                                                                  }
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .bookmark_border,
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
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: FadeInImage
                                                          .assetNetwork(
                                                        placeholder:
                                                            "assets/images/default.gif",
                                                        image: x['imageUrl'],
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 15,
                                                              bottom: 5),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              x['author'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            x['date'],
                                                            style:
                                                                const TextStyle(
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
                                            ))
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
    });
  }
}
