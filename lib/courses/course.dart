import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_app/courses/choosen_course.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Course extends StatefulWidget {
  final course_id;

  const Course({Key key, this.course_id}) : super(key: key);

  @override
  _CourseState createState() => _CourseState();
}

class _CourseState extends State<Course> {
  CollectionReference coursecategory =
      FirebaseFirestore.instance.collection("Course");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future:
            coursecategory.where("Cat_id", isEqualTo: widget.course_id).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, i) {
                return Course_Info(
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

class Course_Info extends StatelessWidget {
  final docid;

  const Course_Info({
    Key key,
    this.docid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("Name of this course: " + "${docid['Name']}",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15)),
                    Text(
                      "Number of videos : " + "${docid['No of Videos']}",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    Text(
                      "Number of Hours : " + "${docid['No of Hours']}",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    Text(
                      "Price : " + "${docid['Price']}",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    Text(
                      "Name of teacher : " + "${docid['Teacher name']}",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("${docid['Image']}"),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white70),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Choosen(
                    image: docid['Image'],
                    name: docid['Name'],
                    price: docid['Price'],
                    previous_price: docid['prev price'],
                    rating: docid['Rating'],
                    views: docid['views'],
                    id: docid["Id"],
                  ),
                ));
          },
        ),
        Divider(
          color: Colors.blueAccent,
          thickness: .5,
          height: 30,
        )
      ],
    );
  }
}
