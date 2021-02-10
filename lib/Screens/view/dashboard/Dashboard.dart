import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ustaadian/Screens/view/dashboard/AddArticles.dart';
import 'package:ustaadian/Screens/view/dashboard/AddBooks.dart';
import 'package:ustaadian/Screens/view/dashboard/category.dart';

import 'AddEmails.dart';

class DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ustaadian DashBoard"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                color: Colors.purpleAccent,
                onPressed: () {
                  Get.to(AddBooks());
                },
                child: Container(
                  width: 200,
                  child: Center(
                    child: Text(
                      'Add A Book',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ),
              RaisedButton(
                color: Colors.purpleAccent,
                onPressed: () {
                  Get.to(AddArticles());
                },
                child: Container(
                  width: 200,
                  child: Center(
                    child: Text(
                      'Add An Article',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ),
              RaisedButton(
                color: Colors.purpleAccent,
                onPressed: () {
                  Get.to(AddEmails());
                },
                child: Container(
                  width: 200,
                  child: Center(
                    child: Text(
                      'Add An Email',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ),
              RaisedButton(
                color: Colors.purpleAccent,
                onPressed: () {
                  Get.to(Category());
                },
                child: Container(
                  width: 200,
                  child: Center(
                    child: Text(
                      'Add A Category',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
