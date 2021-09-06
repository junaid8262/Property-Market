import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propertymarket/model/location.dart';
import 'package:propertymarket/model/property.dart';
import 'package:propertymarket/navigator/menu_drawer.dart';
import 'package:propertymarket/screens/property_detail.dart';
import 'package:propertymarket/values/constants.dart';
import 'package:propertymarket/values/shared_prefs.dart';
import 'package:propertymarket/widget/property_tile.dart';
import 'package:toast/toast.dart';
import 'package:easy_localization/easy_localization.dart';
class FavouriteList extends StatefulWidget {

  FavouriteList();

  @override
  _FavouriteListState createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getFavourites();
  }
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
  }
  bool isLoaded=false;

  Future<List<Property>> getPropertyList() async {
    List<Property> list=[];
    User user=FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("favourites").child(user.uid).once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          Property property = new Property(
              individualKey,
              DATA[individualKey]['status'],
              DATA[individualKey]['addPublisherId'],
              DATA[individualKey]['image'],
              DATA[individualKey]['name'].toString(),
              DATA[individualKey]['location'],
              DATA[individualKey]['country'],
              DATA[individualKey]['city'],
              DATA[individualKey]['area'],
              DATA[individualKey]['typeOfProperty'],
              DATA[individualKey]['propertyCategory'],
              DATA[individualKey]['whatsapp'].toString(),
              DATA[individualKey]['call'].toString(),
              DATA[individualKey]['email'],
              DATA[individualKey]['beds'].toString(),
              DATA[individualKey]['bath'].toString(),
              DATA[individualKey]['measurementArea'].toString(),
              DATA[individualKey]['datePosted'],
              DATA[individualKey]['description'],
              DATA[individualKey]['numericalPrice'],
              DATA[individualKey]['payment'],
              DATA[individualKey]['furnish'],
              DATA[individualKey]['agentName'],
              DATA[individualKey]['sponsered'],
              DATA[individualKey]['floor'],
              DATA[individualKey]['serial'],
              DATA[individualKey]['name_ar'],
              DATA[individualKey]['agentName_ar'],
              DATA[individualKey]['area_ar'],
              DATA[individualKey]['city_ar'],
              DATA[individualKey]['country_ar'],
              DATA[individualKey]['description_ar'],
              DATA[individualKey]['furnish_ar'],
              DATA[individualKey]['payment_ar'],
              DATA[individualKey]['typeOfProperty_ar'],
              DATA[individualKey]['propertyCategoryAr'],
            DATA[individualKey]['price_en'],
            DATA[individualKey]['price_ar'],
          );
          list.add(property);


        }
      }
    });
    return list;
  }
  SharedPref sharedPref=new SharedPref();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
            child: FutureBuilder<bool>(
              future: sharedPref.getPref(),
              builder: (context,prefshot){
                if (prefshot.hasData) {
                  if (prefshot.data != null) {
                    return Column(
                      children: [
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(width: 0.2, color: Colors.grey[500]),
                            ),

                          ),
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Text('favourite'.tr(),style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: FutureBuilder<List<Property>>(
                            future: getPropertyList(),
                            builder: (context,snapshot){
                              if (snapshot.hasData) {
                                if (snapshot.data != null && snapshot.data.length>0) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (BuildContext context,int index){
                                      return GestureDetector(
                                          onTap: (){
                                            Navigator.push(
                                                context, MaterialPageRoute(builder: (BuildContext context) => PropertyDetail(snapshot.data[index],prefshot.data)));
                                          },
                                          child: PropertyTile(snapshot.data[index],prefshot.data)
                                      );
                                    },
                                  );
                                }
                                else {
                                  return new Center(
                                    child: Container(
                                        child: Text("no data")
                                    ),
                                  );
                                }
                              }
                              else if (snapshot.hasError) {
                                return Text('Error : ${snapshot.error}');
                              } else {
                                return new Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        )


                      ],
                    );
                  }
                  else {
                    return new Center(
                      child: Container(
                          child: Text("no data")
                      ),
                    );
                  }
                }
                else if (prefshot.hasError) {
                  return Text('Error : ${prefshot.error}');
                } else {
                  return new Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
        )

    );
  }
}
