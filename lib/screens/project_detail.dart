import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_catalog/services/services.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  openFile(String savePath) {
    OpenFilex.open(savePath);
  }

  var change = false;
  var progress = "";

  @override
  Widget build(BuildContext context) {
    String savePath = "";
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: SizedBox(
          height: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  Project.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  Project.catagory,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Project.author,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    Text(
                      Project.date,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/default.gif",
                    image: Project.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Project.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                        } else {
                          final snackBar = SnackBar(
                            content: const Text(
                                "Please Login to bookmark a project."),
                            action: SnackBarAction(
                              label: "Ok",
                              textColor: Theme.of(context).canvasColor,
                              onPressed: () {},
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      icon: const Icon(
                        Icons.bookmark_border,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                Text(
                  Project.summary,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                Text(
                  Project.additionalDetails,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.picture_as_pdf),
                        const Text(
                          "ProjectDetails.pdf",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        TextButton(
                          child: change == true
                              ? Text("Downloading.... $progress%")
                              : const Text("View File"),
                          onPressed: () async {
                            setState(() {
                              change = true;
                            });
                            Map<Permission, PermissionStatus> statuses = await [
                              Permission.storage,
                            ].request();
                            if (statuses[Permission.storage]!.isGranted) {
                              var dir =
                                  (await DownloadsPath.downloadsDirectory())
                                      ?.path;
                              if (dir != null) {
                                String savename = "${Project.name}.pdf";
                                savePath = "$dir/$savename";

                                try {
                                  await Dio().download(
                                    Project.pdfUrl,
                                    savePath,
                                    onReceiveProgress: (received, total) {
                                      if (total != -1) {
                                        progress = (received / total * 100)
                                            .toStringAsFixed(0);
                                        setState(() {});
                                        print(progress);
                                      }
                                    },
                                  );
                                  setState(() {
                                    change = false;
                                  });
                                  final snackBar = SnackBar(
                                    content: const Text(
                                        "File is saved to download folder."),
                                    action: SnackBarAction(
                                      label: "Ok",
                                      // ignore: use_build_context_synchronously
                                      textColor: Theme.of(context).canvasColor,
                                      onPressed: () {},
                                    ),
                                  );
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } on DioError catch (e) {
                                  final snackBar = SnackBar(
                                    content: Text(e.message),
                                    action: SnackBarAction(
                                      label: "Ok",
                                      // ignore: use_build_context_synchronously
                                      textColor: Theme.of(context).canvasColor,
                                      onPressed: () {},
                                    ),
                                  );
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              }
                            } else {
                              final snackBar = SnackBar(
                                content: const Text(
                                    "No permission to read and write."),
                                action: SnackBarAction(
                                  label: "Ok",
                                  // ignore: use_build_context_synchronously
                                  textColor: Theme.of(context).canvasColor,
                                  onPressed: () {},
                                ),
                              );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                            openFile(savePath);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
