import 'package:e_recycling/provider/detail_screen_provider.dart';
import 'package:e_recycling/worker_side/worker_side_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckPop extends StatefulWidget {
  @override
  _CheckPopState createState() => _CheckPopState();
}

class _CheckPopState extends State<CheckPop> {
  @override
  Widget build(BuildContext context) {
    DetailScreenProvider detailScreenProvider=Provider.of<DetailScreenProvider>(context);
    return WillPopScope(
        onWillPop: () async{
          context.read<WorkerSideProvider>().navBack(context);
          return true;
        },

        child: Scaffold());
  }
}
