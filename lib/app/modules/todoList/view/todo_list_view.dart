import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_api_notepad/app/modules/todoList/controller/todo_list_controller.dart';

import '../../../routes/app_routes.dart';

class TodoListView extends GetView<TodoListController> {

  const TodoListView({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    Get.put(TodoListController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            controller.addTodoController.clearFields();
            Get.toNamed(AppRoutes.addTodo);

          },
          label: const Text('Add Todo')),
      body: Obx(() => Visibility(
            visible: controller.isLoading.value,
            replacement: RefreshIndicator(
              onRefresh: controller.fetchTodo,
              child: Visibility(
                visible: controller.items.isNotEmpty,
                replacement: Center(
                  child: Text(
                    'No Todo Item',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) {
                    final item = controller.items[index] as Map;
                    final id = item['_id'] as String;
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text(item['title']),
                        subtitle: Text(item['description']),
                        trailing: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 'edit') {
                              // Open Edit Page
                              Get.toNamed(AppRoutes.addTodo, arguments: {
                                'updateItem':item
                              });
                              controller.addTodoController.
                              editTodo(index: index, existTodoList: item);

                            } else if (value == 'delete') {
                              // Delete and remove the item
                              controller.deleteById(id: id);
                            }
                          },
                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ];
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )),
    );
  }
}
