import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_api_notepad/app/modules/todoList/controller/todo_list_controller.dart';
import 'package:rest_api_notepad/service/todo_service.dart';
import 'package:rest_api_notepad/utils/app_constant.dart';

class AddTodoController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final TodoService _todoService = TodoService();
  Map? _existTodoList;
  int? _selectedIndex;
  int? get selectedIndex => _selectedIndex;

  void submitData(context) async {
    AppConstant.kProgressDialog.show();
    try {
      //Get the data from form
      var isSuccess = await _todoService.todoPost(
          title: titleController.text, description: descriptionController.text);

      if (isSuccess) {
        AppConstant.showSuccessMessage(
            message: 'Todo creation successfully', context: Get.context!);
        // Clear field
        titleController.text = "";
        descriptionController.text = "";
        Get.back();
        log('back++++++++++++');
        //call method from TodoListController using Get.find()
        Get.find<TodoListController>().fetchTodo();
      } else {
        AppConstant.showErrorMessage(
            message: 'Todo creation failed', context: Get.context!);
      }
    } catch (e) {
      log(e.toString());
    } finally {
      AppConstant.kProgressDialog.dismiss();
    }
  }

  void updateData() async {
    log('updateData()-------------');

      //Update the data from form
      _existTodoList = Get.arguments['updateItem'];
      final id = _existTodoList!['_id'];

      //Get the data from form
      var isSuccess = await _todoService.todoUpdate(
          title: titleController.text,
          description: descriptionController.text,
          id: id);
      if (isSuccess) {
        AppConstant.showSuccessMessage(
            message: 'Update creation successfully', context: Get.context!);
        Get.back();
        log('back++++++++++++');
        Get.find<TodoListController>().fetchTodo();
      } else {
        AppConstant.showErrorMessage(
            message: 'Update failed !', context: Get.context!);
      }

  }

  void editTodo({required int index, required Map existTodoList}) {
    log('editNote() called--------------');
    _selectedIndex = index;

    log('existTodoList::$existTodoList');
    var title = existTodoList['title'];
    var description = existTodoList['description'];

    titleController.text = title;
    descriptionController.text = description;
  }

  void clearFields() {
    _selectedIndex = null;
    titleController.text = '';
    descriptionController.text = '';
    log('selectedIndex = $_selectedIndex');
  }
}
