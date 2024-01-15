import 'package:get/get.dart';
import 'package:rest_api_notepad/app/modules/addTodo/view/add_todo_view.dart';
import 'package:rest_api_notepad/app/modules/todoList/view/todo_list_view.dart';
import 'package:rest_api_notepad/app/routes/app_routes.dart';

class AppPages{
  static var pageList = [
    GetPage(name: AppRoutes.todoList, page: () => TodoListView(),),
    GetPage(name: AppRoutes.addTodo, page: () =>AddTodoView())
  ];


}