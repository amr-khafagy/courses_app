import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_app/constant/constant_widget.dart';
import 'package:course_app/courses/Course_Category.dart';
import 'package:course_app/courses/course.dart';
import 'package:course_app/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference userref = FirebaseFirestore.instance.collection("users");
  CollectionReference coursecategory =
      FirebaseFirestore.instance.collection("Courses Category");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        FutureBuilder(
            future: userref
                .where("userid",
                    isEqualTo: FirebaseAuth.instance.currentUser.uid)
                .get(),
            builder: (context, asyncsnapshot) {
              if (asyncsnapshot.data == null)
                return Center(child: CircularProgressIndicator());
              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.menu),
                              ),
                              InkWell(
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                      "${asyncsnapshot.data.docs[i].data()["imageurl"]}"),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Profile(),
                                      ));
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Hey ${asyncsnapshot.data.docs[i].data()["name"]}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 30),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                    itemCount: 1,
                  ),
                ],
              );
            }),
        Text(
          "Find a course you want to learn",
          style: TextStyle(fontSize: 28, color: Color(0xFFA0A5BD)),
        ),
        SizedBox(height: 20),
        Textfield(
          suffixicon: Icon(Icons.search),
          hintname: "Search for anyrhing",
          obscure: false,
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Categories",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            InkWell(
              child: Text(
                "See All",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {Navigator.push(context,MaterialPageRoute(builder: (context) => Courses_Category(),));},
            )
          ],
        ),
        Expanded(
            child: FutureBuilder(
          future: coursecategory.get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount:4,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return Suggestion(
                    docid: snapshot.data.docs[i].data(),
                  );
                },
              );
            }
          },
        )),
      ]),
    ));
  }
}

class Suggestion extends StatelessWidget {
  final docid;

  const Suggestion({
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
                        style:
                            TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                    Text(
                      "Number of courses : " + "${docid['Number of courses']}",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                  ],
                ),
SizedBox(width: 15,),
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
          onTap: () {Navigator.push(context,MaterialPageRoute(builder: (context) =>Course(course_id:docid["Id"],),));},
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
