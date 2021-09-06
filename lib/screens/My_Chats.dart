import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:propertymarket/model/PeerUser_Model.dart';
import 'package:propertymarket/screens/chat.dart';
import 'package:propertymarket/values/constants.dart';

class MyChats extends StatefulWidget {
  const MyChats({Key key}) : super(key: key);

  @override
  _MyChatsState createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var uId;
  List id;
  String peerId;
  String userName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
  }

  void getUid() {
    final User user = auth.currentUser;
    uId = user.uid;
    // here you write the codes to input the data into firestore
  }

  int _limit = 20;
  final ScrollController listScrollController = ScrollController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'My Chats',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where(
                      "id",
                      arrayContains: uId,
                    )
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        children: [Text("Something Went Wrong")],
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data.size != 0) {
                    List<Offset> pointList = <Offset>[];

                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        print("user Id $uId");
                        print("yes user has data ");
                        DocumentSnapshot document =  snapshot.data?.docs[index];
                        id = List.from(document['id']);
                        if (id[0] == uId) {
                          peerId = id[1];
                          print("user Id  :$uId");
                          print("Peer Id : $peerId");
                          return buildItem(context, snapshot.data?.docs[index]);

                        } else if (id[1] == uId) {
                          peerId = id[0];
                          print("user Id  :$uId");
                          print("Peer Id : $peerId");
                          return buildItem(context, snapshot.data?.docs[index]);

                        }
                        else
                          {
                            return null;
                          }

                      },
                      itemCount: snapshot.data?.docs.length,
                      controller: listScrollController,
                    );
                  } else if (snapshot.data.size == 0) {
                    print("user Id $uId");
                    print("user data not found");
                    return Center(
                      child: Container(
                        child: Text("No Previous Chat"),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    );
                  }
                },
              ),
            ),

            // Loading
            Positioned(
              child: isLoading ? const Loading() : Container(),
            )
          ],
        ),
        /*onWillPop: onBackPress,*/
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => {
          print(document.get('id')),
          print(document.id),

              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          Chat(peerId: peerId, name: "Chat" ))),

        },
        child: FutureBuilder<List<PeerUser>>(
          future: userData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null && snapshot.data.length > 0) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      print(snapshot.data[index].profilePic);
                      return Container(
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.grey.shade300,
                        ),
                        child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey,
                                        border: Border.all(color: Colors.grey),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              snapshot.data[index].profilePic),
                                          fit: BoxFit.contain,
                                        )),
                                  ),
                                ),
                                Text(
                                  snapshot.data[index].username,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                      );
                    });
              } else {
                return new Center(
                  child: Container(child: Text("no data")),
                );
              }
            } else if (snapshot.hasError) {
              return Text('Error : ${snapshot.error}');
            } else {
              return new Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<PeerUser>> userData() async {
    List<PeerUser> list = [];
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference
        .child("userData")
        .orderByChild('id')
        .equalTo(peerId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        var KEYS = dataSnapshot.value.keys;
        var DATA = dataSnapshot.value;

        for (var individualKey in KEYS) {
          PeerUser peerUser = new PeerUser(
            DATA[individualKey]["token"],
            DATA[individualKey]["username"],
            DATA[individualKey]["email"],
            DATA[individualKey]["profile"],
            DATA[individualKey]["id"],
          );

            list.add(peerUser);
        }
      }
    });
    return list;
  }
}

class Loading extends StatelessWidget {
  const Loading();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      ),
      color: Colors.white.withOpacity(0.8),
    );
  }
}
