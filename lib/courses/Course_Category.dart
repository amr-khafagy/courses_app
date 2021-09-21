import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_app/pages/Home_Page.dart';
import 'package:flutter/material.dart';

class Courses_Category extends StatefulWidget {
  const Courses_Category({Key key}) : super(key: key);

  @override
  _Courses_CategoryState createState() => _Courses_CategoryState();
}

class _Courses_CategoryState extends State<Courses_Category> {
  CollectionReference coursecategory =
      FirebaseFirestore.instance.collection("Courses Category");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: coursecategory.get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.data == null) {
        return Center(child: CircularProgressIndicator());
      } else {
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, i) {
            return Suggestion(
              docid: snapshot.data.docs[i].data(),
            );
          },
        );
      }
        },
      ),
    );
  }
}
