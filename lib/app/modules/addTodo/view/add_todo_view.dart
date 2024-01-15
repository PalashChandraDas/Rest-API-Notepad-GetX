import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_api_notepad/app/modules/addTodo/controller/add_todo_controller.dart';

class AddTodoView extends GetView<AddTodoController> {
  const AddTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddTodoController());
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.selectedIndex == null ? 'Add Todo' : 'Edit Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          TextField(
            controller: controller.titleController,
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.descriptionController,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: controller.selectedIndex == null
                  ? controller.submitData
                  : controller.updateData,
              child: Text(controller.selectedIndex == null ? 'Submit' : 'Update'))
        ],
      ),
    );
  }
}
