import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gari_admin/widgets/statscard.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _carsNumber;
  int _usersNumber;
  int _locationNumber;

  Future getStats() async {
    QuerySnapshot _myCars =
        await Firestore.instance.collection('cars').getDocuments();
    QuerySnapshot _myUsers =
        await Firestore.instance.collection('users').getDocuments();
    QuerySnapshot _myBooks =
        await Firestore.instance.collection("books").getDocuments();

    setState(() {
      _locationNumber = _myBooks.documents.length;
      _carsNumber = _myCars.documents.length;
      _usersNumber = _myUsers.documents.length;
    });
  }

  @override
  void initState() {
    super.initState();
    getStats();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double heigth = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///
              ///
              StatsCard(
                  subName: 'Locations',
                  icon: Icon(
                    Icons.attach_money,
                    color: Color(0xff723CDC),
                  ),
                  iconColor: Color(0xffF2EBFB),
                  data: StreamBuilder(
                    stream: Firestore.instance.collection("books").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data.documents.length.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        );
                      }
                      return Text("...");
                    },
                  )),

              ///
              ///
              StatsCard(
                  subName: 'Utilisateur',
                  icon: Icon(
                    Icons.account_circle,
                    color: Color(0xff4AB7FF),
                  ),
                  iconColor: Color(0xffEEF9FF),
                  data: StreamBuilder(
                    stream: Firestore.instance.collection("users").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data.documents.length.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        );
                      }
                      return Text("...");
                    },
                  )),

              ///
              ///
              StatsCard(
                  subName: 'Voitures',
                  icon: Icon(
                    Icons.local_car_wash,
                    color: Color(0xffFF8B58),
                  ),
                  iconColor: Color(0xffFEF3EF),
                  data: StreamBuilder(
                    stream: Firestore.instance.collection("cars").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data.documents.length.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        );
                      }
                      return Text("...");
                    },
                  )),

              ///
              ///
              // StatsCard(
              //   subName: 'Cotisation du Jour',
              //   icon: Icon(
              //     Icons.attach_money,
              //     color: Color(0xffFD5181),
              //   ),
              //   iconColor: Color(0xffFFEFF2),
              //   data: Text(
              //     "23",
              //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //   ),
              // ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "Reservations:  ",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 30,
        ),
        StreamBuilder(
          stream: Firestore.instance.collection("books").snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 30,
                  );
                },
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot products = snapshot.data.documents[index];
                  void onClick() async {
                    Map<String, dynamic> l = {"reserved": false};
                    await Firestore.instance
                        .collection("books")
                        .document(products.documentID.trim())
                        .delete();
                    await Firestore.instance
                        .collection("cars")
                        .document(products["car_id"].trim())
                        .updateData(l);
                    snapshot.data.document.removeAt(index);
                  }

                  return ClipRRect(
                    borderRadius:
                        BorderRadius.all(Radius.circular(width * 0.04)),
                    child: Container(
                      padding: EdgeInsets.only(left: 30),
                      height: 50,
                      width: width * 0.04,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[200],
                                blurRadius: 20,
                                spreadRadius: 3,
                                offset: Offset(0, 3))
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Nom  :" + products["car_name"].toString()),
                          IconButton(
                              icon: Icon(
                                Icons.restore_from_trash,
                                color: Colors.red,
                              ),
                              onPressed: onClick)
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Container(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ]),
    ));
  }
}
