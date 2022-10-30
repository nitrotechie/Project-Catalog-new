import 'package:flutter/material.dart';
import 'package:project_catalog/screens/add_project.dart';
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
  var all = "";
  var computer = "";
  var mechanical = "";
  var robotics = "";
  var civil = "";
  var electrical = "";
  var electronicsAndComm = "";
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
    return Consumer<MyTheme>(builder: (context, MyTheme theme, child) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            size: 40,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AddProjectScreen()));
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
                          setState(() {
                            if (value.isEmpty) {
                              // News.url = News.topHeadlineUrl;
                            } else {
                              String searchUrl = "";
                              // News.url = searchUrl;
                            }
                            // getHeadlines();
                          });
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
                              // News.url = top;
                              // getHeadlines();
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
                              // News.url = business;
                              // getHeadlines();
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
                              // News.url = entertainment;
                              // getHeadlines();
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
                              // News.url = health;
                              // getHeadlines();
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
                              // News.url = science;
                              // getHeadlines();
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
                              // News.url = sports;
                              // getHeadlines();
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
                              // News.url = technology;
                              // getHeadlines();
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
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
