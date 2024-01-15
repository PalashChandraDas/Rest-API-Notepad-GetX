import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:rest_api_notepad/app/modules/addTodo/controller/add_todo_controller.dart';
import 'package:rest_api_notepad/utils/app_constant.dart';

import '../../../../service/todo_service.dart';


class TodoListController extends GetxController {
  RxList items = [].obs;
  RxBool isLoading = true.obs;
  final addTodoController = Get.put(AddTodoController());
  final TodoService _todoService = TodoService();

  @override
  void onInit() {
    super.onInit();
    fetchTodo();
  }

  Future<void> fetchTodo() async {
    // Get.defaultDialog(
    //     content: const Row(children: [
    //       CircularProgressIndicator(),
    //       Text('Loading', style: TextStyle(fontWeight: FontWeight.bold,
    //           fontSize: 20),)
    //     ],)
    // );
    isLoading.value = true;
    var response = await _todoService.readTodo();
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;

      items.value = result;
      isLoading.value = false;

      log('length===== ${items.length}');
    } else {
      //error
      isLoading.value = true;
    }

  }

  Future<void> deleteById({required String id}) async {
    // Delete the item
    var isSuccess = await _todoService.todoDelete(id: id);

    if (isSuccess) {
      // Remove item from the list
      final filtered = items.where((element) => element['_id'] != id).toList();
      items.value = filtered;
      AppConstant.showSuccessMessage(message: 'Successfully Deleted', context: Get.context!);
    } else {
      // Show error
      AppConstant.showErrorMessage(message: 'Deletion Failed', context: Get.context!);
    }
  }


}
