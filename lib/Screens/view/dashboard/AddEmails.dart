import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'category.dart';

class AddEmails extends StatefulWidget {
  @override
  _AddEmailsState createState() => _AddEmailsState();
}

class _AddEmailsState extends State<AddEmails> {
  var selectedCategory, selectedType;
  var selectedTag;
  File images;
  final ImagePicker _picker = ImagePicker();
  String emailTitle, autherName, id, imageUrl;

  createData() {
    print(selectedCategory);
    if (emailTitle != null) {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("Emails").doc(emailTitle);

      Map<String, dynamic> books = {
        "emailTitle": emailTitle,
        "autherName": autherName,
        "image": imageUrl,
        "category": selectedCategory,
        "tag": selectedTag,
      };
      documentReference
          .set(books)
          .whenComplete(() => {print("$images Document Created")});
      //  print("The image is $images");
    }
  }

  Future getImage() async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      images = File(image.path);
      print('Image Path $images');
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(images.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(images);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    imageUrl = await taskSnapshot.ref.getDownloadURL();

    setState(() {
      print("Profile Picture uploaded $images");
      Scaffold.of(context)
          // ignore: deprecated_member_use
          .showSnackBar(SnackBar(content: Text('Book Cover Uploaded $images')));
    });
  }

  updateData() {
    if (emailTitle != null) {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("Emails").doc(id);
      Map<String, dynamic> students = {
        "bookName": emailTitle,
        "autherName": autherName,
      };
      documentReference
          .set(students)
          .whenComplete(() => {print("$emailTitle document Updated")});
    }
  }

  deleteData(String data) {
    if (emailTitle != null) {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("Emails").doc(data);
      documentReference
          .delete()
          .whenComplete(() => {print("$emailTitle document Deleted")});
    }
  }

  getEmailTitle(name) {
    this.emailTitle = name;
  }

  getAutherName(writerName) {
    this.autherName = writerName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Add Email"),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Category()));
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Builder(
              builder: (context) => Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        child: Column(children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: (images != null)
                                    ? Image.file(
                                        images,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 100.0,
                                ),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  color: Colors.green,
                                  child: Text(
                                    "Upload Image",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  onPressed: () async {
                                    await getImage();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, top: 50.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email Title",
                            fillColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                          ),
                          onChanged: (String name) {
                            getEmailTitle(name);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, top: 20.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Auther Name",
                            fillColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                          ),
                          onChanged: (String writerName) {
                            getAutherName(writerName);
                          },
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Category')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return LinearProgressIndicator();
                          } else {
                            List<DropdownMenuItem> categoryItems = [];
                            for (int i = 0;
                                i < snapshot.data.docs.length;
                                i++) {
                              DocumentSnapshot snap = snapshot.data.docs[i];
                              categoryItems.add(DropdownMenuItem(
                                child: Text(
                                  snap.id,
                                  style: TextStyle(color: Colors.pink),
                                ),
                                value: "${snap.id}",
                              ));
                            }
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                          child: DropdownButton(
                                            hint: Text('Category'),
                                            items: categoryItems,
                                            onChanged: (categoryValue) {
                                              final snackBar = SnackBar(
                                                content: Text(
                                                    'Selected Category Value is $categoryValue'),
                                              );
                                              Scaffold.of(context)
                                                  // ignore: deprecated_member_use
                                                  .showSnackBar(snackBar);
                                              setState(() {
                                                selectedCategory =
                                                    categoryValue;
                                              });
                                              //cn.getValue(categoryValue);
                                            },
                                            value: selectedCategory,
                                            isExpanded: false,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),

                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Tags')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return LinearProgressIndicator();
                          } else {
                            List<DropdownMenuItem> categoryItems = [];
                            for (int i = 0;
                                i < snapshot.data.docs.length;
                                i++) {
                              DocumentSnapshot snap = snapshot.data.docs[i];
                              categoryItems.add(DropdownMenuItem(
                                child: Text(
                                  snap.id,
                                  style: TextStyle(color: Colors.blue),
                                ),
                                value: "${snap.id}",
                              ));
                            }
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                          child: DropdownButton(
                                            hint: Text('Tags'),
                                            items: categoryItems,
                                            onChanged: (tagValue) {
                                              final snackBar = SnackBar(
                                                content: Text(
                                                    'Selected Tag is $tagValue'),
                                              );
                                              Scaffold.of(context)
                                                  // ignore: deprecated_member_use
                                                  .showSnackBar(snackBar);
                                              setState(() {
                                                selectedTag = tagValue;
                                              });
                                              //cn.getValue(categoryValue);
                                            },
                                            value: selectedTag,
                                            isExpanded: false,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),

                      //ToDo: Add Tag Fuction Here

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
                                  onPressed: () async {
                                    await uploadPic(context);
                                    createData();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
