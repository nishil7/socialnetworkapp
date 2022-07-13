import 'package:flutter/material.dart';

AppBar header(context, {String title=""}) {
  return AppBar(
    title: Text(
       title,
      style: TextStyle(
        color: Colors.white,
        fontSize:40.0,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
