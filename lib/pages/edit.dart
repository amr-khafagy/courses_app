import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_app/constant/constant_widget.dart';
import 'package:course_app/pages/Home_Page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Edit extends StatefulWidget {
  final  docid;
  final  userinfo;

  const Edit({Key key, this.docid, this.userinfo}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {

  var username, password, phone, email, imgurl;
  var authid = FirebaseAuth.instance.currentUser.uid;
  GlobalKey<FormState> editformstate = GlobalKey<FormState>();
  File imgfile;
  Reference imgref;
  CollectionReference coll = FirebaseFirestore.instance.collection("users");

  edituserinfo() async {
    var formdata = editformstate.currentState;
    if (imgfile == null) {
      showLoading(context);
      formdata.save();
      await coll.doc(widget.docid).update({
        "name": username,
        "email": email,
        "phone": phone,
        "userid": authid,
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ));
    } else {
      showLoading(context);
      formdata.save();
      await imgref.putFile(imgfile);
      imgurl = await imgref.getDownloadURL();
      await coll.doc(widget.docid).update({
        "name": username,
        "email": email,
        "phone": phone,
        "imageurl": imgurl,
        "userid": authid
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: editformstate,
              child: Column(
                children: [
                  Stack(children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage:
                          NetworkImage("${widget.userinfo["imageurl"]}"),
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
                  Textfield(
                    hintname: "${widget.userinfo["name"]}",
                    label: "name",
                    saved: (val) {
                      username = val;
                    },
                  ),
                  Textfield(
                    hintname: "${widget.userinfo["email"]}",
                    label: "email",
                    saved: (val) {
                      email = val;
                    },
                  ),
                  Textfield(
                    hintname: "${widget.userinfo["phone"]}",
                    label: "phone",
                    saved: (val) {
                      phone = val;
                    },
                  ),
                  Textfield(
                    hintname: "Password",
                    label: "Password",
                    obscure: true,
                    saved: (val) {
                      password = val;
                    },
                  ),
                  Button(
                    text: "Login",
                    onpressed: () async {
                      await edituserinfo();
                    },
                    backgroundcolor: Color(0xff6e8af9),
                    edgeInsets:
                        EdgeInsets.symmetric(vertical: 18, horizontal: 150),
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
