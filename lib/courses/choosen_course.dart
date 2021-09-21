import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_app/courses/session_video.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Choosen extends StatefulWidget {
  final image;
  final name;
  final price;
  final previous_price;
  final views;
  final rating;
final id;
  const Choosen(
      {Key key,
      this.image,
      this.name,
      this.price,
      this.previous_price,
      this.views,
      this.rating, this.id})
      : super(key: key);

  @override
  _ChoosenState createState() => _ChoosenState();
}

class _ChoosenState extends State<Choosen> {
  CollectionReference sessions=FirebaseFirestore.instance.collection("Choosen Course");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color(0xFFF5F4EF),
            image: DecorationImage(
                image: NetworkImage(widget.image),
                alignment: Alignment.topRight)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.more_vert,
                          size: 30,
                        ),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(widget.name,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0d1333))),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.views,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Icon(
                        Icons.star_sharp,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.rating,
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                        TextSpan(
                          text: widget.price,
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: widget.previous_price,
                          style: TextStyle(
                              color: Colors.black.withOpacity(.5),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.lineThrough),
                        ),
                      ])),
                ],
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Text(
                              "Course Content",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            FutureBuilder(
                              future:sessions.where("course_id",isEqualTo:widget.id,).get(),
                              builder: (context, snapshot) {
                                if(snapshot.data==null){
                                  return Center(child: CircularProgressIndicator());

                                }else{
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:snapshot.data.docs.length,
                                    itemBuilder: (context, i) {
                                      return Coursecontent(docid:snapshot.data.docs[i].data());
                                    },
                                  );
                                }
                            },
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Coursecontent extends StatelessWidget {
 final docid;

  const Coursecontent({Key key, this.docid}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          docid["id"].toString(),
          style: TextStyle(
              fontSize: 30,
              color: Color(0xFF0D1333),
              fontWeight: FontWeight.w500),
        ),
        RichText(
            text: TextSpan(children: [
          TextSpan(
            text: "${docid["time"]}\n",
            style: TextStyle(
                color: Color(0xFF0D1333).withOpacity(.5), fontSize: 18),
          ),
          TextSpan(
              text: docid["session_title"],
              style: TextStyle(
                  color: Color(0xFF0D1333),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.5))
        ])),
        IconButton(
          icon: Icon(Icons.play_circle_fill),
          iconSize: 45,
          onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) =>Video(session_link: docid["session_link"],) ,));},
          color: Colors.greenAccent,
        )
      ],
    );
  }
}
//session_link