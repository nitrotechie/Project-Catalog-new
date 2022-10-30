import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project_catalog/utils/themes.dart';
import 'package:project_catalog/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyTheme>(builder: (context, MyTheme theme, child) {
      return Scaffold(
        drawer: const CustomDrawer(),
        body: SafeArea(
          child: Container(),
        ),
      );
    });
  }
}
