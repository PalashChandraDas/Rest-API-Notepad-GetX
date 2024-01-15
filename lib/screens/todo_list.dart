import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rest_api_notepad/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {

  const TodoListPage({super.key,});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {

  List items = [];
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),

      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage,
          label: Text('Add Todo')),

      body: Visibility  (
       visible: isLoading,
        child: Center(child: CircularProgressIndicator(),),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(child: Text('No Todo Item',style: Theme.of(context).textTheme.headlineLarge,),),

            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${index+1}')),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if(value == 'edit'){
                        // Open Edit Page
                        navigateToEditPage(item);
                      } else if(value == 'delete'){
                        // Delete and remove the item
                        deleteById(id);
                      }
                    },

                    itemBuilder: (context) {
                    return [
                      PopupMenuItem(child: Text('Edit'),
                      value: 'edit',

                      ),
                      PopupMenuItem(child: Text('Delete'),
                      value: 'delete',),
                    ];
                  },),
                ),
              );
            },),
          ),
        ),
      ),


    );
  }


  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => AddTodoPage(),);
    await Navigator.push(context, route);
    print('back---------');
    setState(() {
      isLoading = true;
    });
    fetchTodo();

  }
  Future<void> navigateToEditPage(Map item) async{
    final route = MaterialPageRoute(builder: (context) => AddTodoPage(
      todo:item
    ),);
    await Navigator.push(context, route);
    print('back---------');
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }



  Future<void> fetchTodo() async {
    isLoading = true;
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200){
      final json = jsonDecode(response.body)  as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
        isLoading = false;
      });
      print('length===== ${items.length}');
    } else{
      //error

    }

    final myres = jsonDecode(response.body);
    print(response.statusCode);
    print(myres);


  }

  Future<void> deleteById(String id) async {
    // Delete the item
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if(response.statusCode == 200) {
      // Remove item from the list
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;

      });
      showSuccessMessage('Successfully Deleted');


    } else{
      // Show error
      showErrorMessage('Deletion Failed!');
    }


  }



  void showSuccessMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void showErrorMessage(String message){
    final snackBar = SnackBar(content: Text(message,
      style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.red,

    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
