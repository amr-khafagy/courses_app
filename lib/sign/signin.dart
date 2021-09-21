import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_app/constant/tools.dart';
import 'package:course_app/pages/Home_Page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:course_app/constant/constant_widget.dart';
import 'package:course_app/sign/login.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Sign extends StatefulWidget {
  const Sign({Key key}) : super(key: key);

  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<Sign> {
  Validation validation = Validation();
  Reference ref;
  var imgurl;
  File file;
  var name, email, password, phone;
  CollectionReference signref = FirebaseFirestore.instance.collection("users");
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  pickimage() async {
    var picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        file = File(picked.path);
      });
      var rand = Random().nextInt(100000);
      var nameimg = "$rand" + basename(picked.path);
      ref = FirebaseStorage.instance.ref("images").child("$nameimg");
      imgurl = await ref.getDownloadURL();
    }
  }

  signup(context) async {
    if (file == null) {
      return AwesomeDialog(
          context: context,
          title: "Important",
          body: Text("please choose image for note"),
          dialogType: DialogType.ERROR)
        ..show();
    }
    var formdata = formstate.currentState;
    if (formdata.validate()) {
      formdata.save();
      try {
        showLoading(context);
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("Password is too weak"))
            ..show();
          print("password weak");
        }
        if (e.code == "email-already-in-use") {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("email already found"))
            ..show();
          print("email found");
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formstate,
              child: Column(
                children: [
                  Text(
                    "Sign UP",
                    style: TextStyle(
                        color: Color(0xFF0D1333),
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Textfield(
                    saved: (val) {
                      name = val;
                    },
                    validator: (val) {
                      return validation.namevalidation(val);
                    },
                    hintname: "Name",
                    suffixicon: Icon(Icons.person),
                    obscure: false,
                  ),
                  Textfield(
                    saved: (val) {
                      email = val;
                    },
                    validator: (val) {
                      return validation.emailvalidation(val);
                    },
                    obscure: false,
                    hintname: "email",
                    suffixicon: Icon(Icons.alternate_email),
                  ),
                  Textfield(
                    saved: (val) {
                      phone = val;
                    },
                    validator: (val) {
                      return validation.phonevalidation(val);
                    },
                    hintname: "phone",
                    suffixicon: Icon(Icons.phone_android),
                    obscure: false,
                  ),
                  Textfield(
                    validator: (val) {
                      return validation.passwordvalidation(val);
                    },
                    saved: (val) {
                      password = val;
                    },
                    hintname: "password",
                    suffixicon: Icon(Icons.lock),
                    obscure: true,
                  ),
                  Button(
                      text: "Your Profile image",
                      onpressed: pickimage,
                      edgeInsets:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                      backgroundcolor: Color(0xff48cc96)),
                  SizedBox(height: 20),
                  file == null
                      ? Text("Not choosen")
                      : CircleAvatar(
                          backgroundImage: FileImage(file),
                          radius: 100,
                        ),
                  Button(
                    text: "Sign Up",
                    onpressed: () async {
                      UserCredential response = await signup(context);
                      if (response != null) {
                        await ref.putFile(file);
                        imgurl = await ref.getDownloadURL();
                        await signref.add({
                          "name": name,
                          "phone": phone,
                          "email": email,
                          "imageurl": imgurl,
                          "userid": FirebaseAuth.instance.currentUser.uid,
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ));
                      }
                    },
                    backgroundcolor: Color(0xff6e8af9),
                    edgeInsets:
                        EdgeInsets.symmetric(vertical: 18, horizontal: 150),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 13, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          "If you have account you can",
                          style: TextStyle(fontSize: 19),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ));
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
