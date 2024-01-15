import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rest_api_notepad/app/routes/app_pages.dart';
import 'package:rest_api_notepad/app/routes/app_routes.dart';

void main(){
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      // home: TodoListView(),
      initialRoute: AppRoutes.todoList,
      getPages: AppPages.pageList,
    );
  }
}
