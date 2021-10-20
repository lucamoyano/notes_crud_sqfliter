import 'package:flutter/material.dart';
import 'package:notes_crud/pages/list_page.dart';
import 'package:notes_crud/pages/save_page.dart';


Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) =>  const ListPage(),
    'newnote': (BuildContext context) => SavePage(),
    //'alert': (BuildContext context) => AlertPage(),
  };
}