import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;

  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if(todo != null){
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isEdit
                ? 'Edit Todo'
        :'Add Todo'),
      ),


      body: ListView(
        padding: EdgeInsets.all(30),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Title',
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: 'Description',

            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20,),
          ElevatedButton(
              onPressed: isEdit
                  ?updateData
                  :submitData,
              child: Text(
              isEdit
              ?'Update'
              :'Submit'))
        ],
      ),

    );
  }


  void submitData()async{
    //Get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    //Submit data to the server
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: jsonEncode(body),
    headers: {
      'Content-Type': 'application/json'
    });
    //show success or fail message based on status

    if(response.statusCode == 201){
      print('Creation success---------');
      print(jsonDecode(response.body));
      showSuccessMessage('Creation success');
      titleController.text = "";
      descriptionController.text = "";
    } else{
      print('Creation failed!!!!!!!!!');
      print(response.statusCode);
      print(jsonDecode(response.body));
      showErrorMessage('Creation failed');
    }
  }


  void updateData() async{
    //Get the data from form
    final todo = widget.todo;
    if(todo == null){
      print('You can not call updated without todo data');
      return;
    }

    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    //Submit data to the server
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri, body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json'
        });

    //show success or fail message based on status

    if(response.statusCode == 200){
      print('Update success---------');
      print(jsonDecode(response.body));
      showSuccessMessage('Update success');
    } else{
      print('Update failed!!!!!!!!!');
      print(response.statusCode);
      print(jsonDecode(response.body));
      showErrorMessage('Update failed');
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
