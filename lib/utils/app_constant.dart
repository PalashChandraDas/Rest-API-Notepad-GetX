import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:get/get.dart';

class AppConstant{


  static showSuccessMessage({required String message, required BuildContext context}){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static showErrorMessage({required String message, required BuildContext context}){
    final snackBar = SnackBar(content: Text(message,
      style: const TextStyle(color: Colors.white),),
      backgroundColor: Colors.red,

    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

 // ignore: missing_required_param
 static ProgressDialog kProgressDialog = ProgressDialog(Get.context!, message: const Text('Loading...'));

}