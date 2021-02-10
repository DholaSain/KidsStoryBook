import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Chapters.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  String categoryName;

//Function that is creating Category

  createCategory() {
    if (categoryName != null) {
      //   profileImageView.images;

      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("Category").doc(categoryName);

      Map<String, dynamic> categories = {
        "categoryName": categoryName,
      };
      documentReference
          .set(categories)
          .whenComplete(() => {print("$categoryName Document Created")});
      //  print("The image is $images");
    }
  }

  //Function that is deleting Category
  deleteData(String data) {
    if (categoryName != null) {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("Category").doc(data);
      documentReference
          .delete()
          .whenComplete(() => {print("$categoryName document Deleted")});
    }
  }

//Forwarding Catefory Name to Function
  getCategoryName(categoryName) {
    this.categoryName = categoryName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Add Category"),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddChapters()));
              },
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Builder(
              builder: (context) => Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Category Name",
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                            ),
                          ),
                          onChanged: (String categoryName) {
                            getCategoryName(categoryName);
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: RaisedButton(
                                  color: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Text(
                                    "Create",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    createCategory();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Category Name',
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            ),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Category")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot documentSnapshot =
                                    snapshot.data.documents[index];
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      documentSnapshot["categoryName"],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: IconButton(
                                          color: Colors.red,
                                          icon: Icon(
                                            Icons.delete,
                                            size: 30.0,
                                          ),
                                          onPressed: () {
                                            deleteData(documentSnapshot[
                                                'categoryName']);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            return Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
