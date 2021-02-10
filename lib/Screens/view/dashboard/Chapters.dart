import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddChapters extends StatefulWidget {
  @override
  _AddChaptersState createState() => _AddChaptersState();
}

class _AddChaptersState extends State<AddChapters> {
  var selectedBook, selectedType;
  File images;
  final ImagePicker _picker = ImagePicker();
  String chapterTitle, id, chapterText, imageUrl, chapterNumber, lastUpdated;

  createData() {
    print(selectedBook);
    if (chapterTitle != null) {
      //   profileImageView.images;
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("Books")
          .doc(selectedBook)
          .collection('Chapters')
          .doc(chapterNumber);

      Map<String, dynamic> chapters = {
        "chapterTitle": chapterTitle,
        "image": imageUrl,
        "chapterText": chapterText,
        "chapterNumber": chapterNumber,
        "selectedBook": selectedBook,
        "lastUpdated": Timestamp.now(),
      };
      documentReference
          .set(chapters)
          .whenComplete(() => {print("$chapterTitle Document Created")});
    }
  }

  createChapter() {
    print(selectedBook);
    if (chapterTitle != null) {
      //   profileImageView.images;
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('Chapters').doc(chapterNumber);

      Map<String, dynamic> chapters = {
        "chapterTitle": chapterTitle,
        "image": imageUrl,
        "chapterText": chapterText,
        "chapterNumber": chapterNumber,
        "selectedBook": selectedBook,
        "lastUpdated": Timestamp.now(),
      };
      documentReference
          .set(chapters)
          .whenComplete(() => {print("$chapterTitle Document Created")});
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
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Profile Picture Uploaded $images')));
    });
  }

  deleteData(String data) {
    if (chapterTitle != null) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("Books")
          .doc(selectedBook)
          .collection('Chapters')
          .doc(chapterTitle);
      documentReference
          .delete()
          .whenComplete(() => {print("$chapterTitle document Deleted")});
    }
  }

  getChapterTitle(chapterTitle) {
    this.chapterTitle = chapterTitle;
  }

  getChapterSubTitle(chapterNumber) {
    this.chapterNumber = chapterNumber;
  }

  getChapterText(chapterText) {
    this.chapterText = chapterText;
  }

  // ignore: non_constant_identifier_names
  getTimestamp(TimesStamp) {
    this.lastUpdated = TimesStamp.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Add Chapter"),
          ),
        ),
        body: Padding(
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
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Text(
                                  "Upload Image",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                textColor: Colors.white,
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
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Chapter Title",
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                        ),
                        onChanged: (String chapterTitle) {
                          getChapterTitle(chapterTitle);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Capter No.",
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                        ),
                        onChanged: (String chapterNumber) {
                          getChapterSubTitle(chapterNumber);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Chapter Text",
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                        ),
                        onChanged: (String chapterText) {
                          getChapterText(chapterText);
                        },
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Books')
                          .snapshots(),
                      // ignore: missing_return
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          Text('Loading');
                        } else {
                          List<DropdownMenuItem> bookItems = [];
                          for (int i = 0; i < snapshot.data.docs.length; i++) {
                            DocumentSnapshot snap = snapshot.data.docs[i];
                            bookItems.add(DropdownMenuItem(
                              child: Text(
                                snap.id,
                                style: TextStyle(color: Colors.pink),
                              ),
                              value: "${snap.id}",
                            ));
                          }
                          return Container(
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
                                        hint: Text('Chose Book'),
                                        items: bookItems,
                                        onChanged: (bookValue) {
                                          final snackBar = SnackBar(
                                            content: Text(
                                                'Selected Book is $bookValue'),
                                          );
                                          Scaffold.of(context)
                                              // ignore: deprecated_member_use
                                              .showSnackBar(snackBar);
                                          setState(() {
                                            selectedBook = bookValue;
                                          });
                                        },
                                        value: selectedBook,
                                        isExpanded: false,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      },
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
        ));
  }
}
