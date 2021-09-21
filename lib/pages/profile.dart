import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_app/constant/constant_widget.dart';
import 'package:course_app/pages/edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  CollectionReference userref = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: userref
            .where("userid", isEqualTo: FirebaseAuth.instance.currentUser.uid)
            .get(),
        builder: (context, asyncsnapshot) {
          if (asyncsnapshot.data == null)
            return Center(child: CircularProgressIndicator());
          return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Stack(children: [
                            CircleAvatar(
                              radius: 100,
                              backgroundImage: NetworkImage(
                                  "${asyncsnapshot.data.docs[i]
                                      .data()["imageurl"]}"),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                    ),
                                    color: Colors.blue),
                                child: IconButton(
                                    icon: Icon(Icons.edit),
                                    color: Colors.white,
                                    onPressed: () {}),
                              ),
                            ),
                          ]),
                          Profilefield(
                            hittext: asyncsnapshot.data.docs[i].data()["name"],
                          ),
                          Profilefield(
                            hittext: asyncsnapshot.data.docs[i].data()["email"],
                          ),
                          Profilefield(
                            hittext: asyncsnapshot.data.docs[i].data()["phone"],
                          ),
                          Button(
                            onpressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Edit(
                                          docid: asyncsnapshot.data.docs[i].id,
                                          userinfo:asyncsnapshot.data.docs[i].data(),),
                                  ));
                            },
                            text: "Edit",
                            backgroundcolor: Colors.blueAccent,
                            edgeInsets: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 150),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
