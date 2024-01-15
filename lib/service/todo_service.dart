import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import '../utils/apis.dart';

class TodoService {
  final todoHeader = {'Content-Type': 'application/json'};
  final fullUrl = Apis.baseUrl + Apis.endPoint;


  ///*******METHOD*****//////
  ///////////////////
  todoPost({required title, required description}) async {
    log('****todoPost() called****');
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    //Submit data to the server
    final uri = Uri.parse(fullUrl);
    final response = await http.post(uri, body: jsonEncode(body), headers: todoHeader);
    log('ALL POST DATA: ${jsonDecode(response.body)}');
    return response.statusCode == 201;
  }

  //UPDATE DATA
  todoUpdate({required title, required description, required id}) async {
    log('****updateTodo() called****');
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    //Update data to the server
    final uri = Uri.parse(fullUrl+id);
    final response = await http.put(uri, body: jsonEncode(body), headers: todoHeader);
    log('ALL UPDATE DATA: ${jsonDecode(response.body)}');
    return response.statusCode == 200;
  }

  //READ DATA
  readTodo() async {
    log('****readTodo() called****');
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    var response = await http.get(uri);
    return response;
  }

  // DELETE DATA
  todoDelete({required id}) async {
    log('****todoDelete() called****');
    // Delete data by id from server/List
    final uri = Uri.parse(fullUrl+id);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

}
