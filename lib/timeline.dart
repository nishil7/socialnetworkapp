import 'package:flutter/material.dart';
import 'package:flutter_social/widgets/header.dart';
import 'package:flutter_social/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference users_Reference = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<dynamic> users=[];

  void initState(){

    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, title: "FlutterSocial"),
      body: Text("Timeline")
    );
  }
}