import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:propertymarket/model/User_Notificactions.dart';
import 'package:propertymarket/model/location.dart';
import 'package:propertymarket/values/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:propertymarket/values/shared_prefs.dart';
import 'package:easy_localization/easy_localization.dart';
enum rentOrBuy { rent, buy }

class Notify extends StatefulWidget {
  const Notify({Key key}) : super(key: key);

  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  SharedPref sharedPref=new SharedPref();
  final _scrollController = ScrollController();
  final ScrollController listScrollController = ScrollController();


  String userid;
  var rng = new Random();
  var notificationId ;
  String selectedCountryId="";
  String selectedCityId="";
  String selectedAreaId="";

  String engCountry="";
  String engCity="";
  String engArea="";

  String arCountry="";
  String arCity="";
  String arArea="";

  String selectedCountryName='selectCountry'.tr();
  String selectedCityName='selectCity'.tr();
  String selectedAreaName='selectArea'.tr();

  bool isRent=true;
  rentOrBuy _rentOrBuy = rentOrBuy.rent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'notification'.tr(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body : SingleChildScrollView(
        child: Container(
          //height: MediaQuery.of(context).size.height*0.42,
          margin: EdgeInsets.only(left: 10,right: 10,top: 10),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Radio(
                    value: rentOrBuy.rent,
                    groupValue: _rentOrBuy,
                    onChanged: (rentOrBuy value) {
                      setState(() {
                        isRent = true;
                        _rentOrBuy = value;
                        print(context.locale);
                      });
                    },
                  ),
                  new Text(
                    'rent'.tr(),
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  new Radio(
                    value: rentOrBuy.buy,
                    groupValue: _rentOrBuy,
                    onChanged: (rentOrBuy value) {
                      setState(() {
                        isRent = false;
                        _rentOrBuy = value;
                      });
                    },
                  ),
                  new Text(
                    'buy'.tr(),
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey,),

              ListTile(
                onTap: ()=>sharedPref.getPref().then((value) => _showCountryDailog(value)),
                leading: Image.asset("assets/images/country.png",width: 30,height: 30,),
                title: Text(selectedCountryName,style: TextStyle(color: Colors.grey[600]),),
                trailing: Icon(Icons.keyboard_arrow_down),
              ),
              Divider(color: Colors.grey,),
              ListTile(
                onTap: (){
                  if(selectedCountryId!=null){
                    sharedPref.getPref().then((value) => _showCityDailog(value));
                  }
                  else{
                    //Toast.show("Please select above", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                  }
                },
                leading: Image.asset("assets/images/city.png",width: 30,height: 30,),
                title: Text(selectedCityName,style: TextStyle(color: Colors.grey[600]),),
                trailing: Icon(Icons.keyboard_arrow_down),
              ),
              Divider(color: Colors.grey,),
              ListTile(
                onTap: (){
                  if(selectedCountryId!=null && selectedCityId!=null){
                    sharedPref.getPref().then((value) => _showAreaDailog(value));

                  }
                  else{
                    //Toast.show("Please select above", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                  }
                },
                leading: Image.asset("assets/images/area.png",width: 30,height: 30,),
                title: Text(selectedAreaName,style: TextStyle(color: Colors.grey[600]),),
                trailing: Icon(Icons.keyboard_arrow_down),
              ),

              SizedBox(height: 10,),
              InkWell(
                onTap: ()async{
                if(selectedCityId!=null  && selectedCityId!="" && selectedCountryId!=null && selectedCountryId!=""  && selectedAreaName!=null  && selectedAreaName!="") {
                  randNumber();
                  makeNotificationRequest().whenComplete(() {
                    setState(() {
                    });
                  });

                }

                },
                child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        stops: [
                          0.4,
                          0.6,
                        ],
                        colors: [
                          Color(0xff307bd6),
                          Color(0xff2895fa),
                        ],
                      )
                  ),
                  child: Text('Notify'.tr(),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20),),
                ),
              ),

              SizedBox(height: 10,),
              Container(
                height: MediaQuery.of(context).size.height*0.36,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Text("myNotification".tr(),style: TextStyle(
                          fontSize: 20,
                          color: primaryColor,
                          fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                    Container(
                      color: primaryColor,
                      height: 1.5,
                      width: MediaQuery.of(context).size.width*0.4,
                    ),
                    Container(
                      height: 7,
                    ),
                    Container(
                       height: MediaQuery.of(context).size.height*0.27,

          child: FutureBuilder<List<UserNotificationModel>>(
                        future: getUserNotifications(),
                        builder: (context,snapshot){
                          if (snapshot.hasData ) {
                            if (snapshot.data != null && snapshot.data.length>0  ) {
                              print(userid);
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: MediaQuery.of(context).size.height*0.1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Text("Address : " + snapshot.data[index].country + " , " + snapshot.data[index].city + " , " + snapshot.data[index].area + "\nCategory : " + snapshot.data[index].propertyCategory ,style: TextStyle(
                                                        fontSize: 14
                                                      ),),
                                                    ),

                                                  ],
                                                ),
                                                width: MediaQuery.of(context).size.width*0.8,
                                                alignment: Alignment.centerLeft,
                                              ),
                                              IconButton(onPressed:()async{
                                                FirebaseDatabase.instance.reference()
                                                    .child('userNotification')
                                                    .orderByChild('notificationId')
                                                    .equalTo(snapshot.data[index].notificationId)
                                                    .once()
                                                    .then((DataSnapshot snapshot) {
                                                  Map<dynamic, dynamic> children = snapshot.value;
                                                  children.forEach((key, value) {
                                                    FirebaseDatabase.instance.reference()
                                                        .child('userNotification')
                                                        .child(key)
                                                        .remove();
                                                  });
                                                }).whenComplete(()  {
                                                setState(() {
                                                });
                                                });


                                              }, icon: Icon(Icons.delete,color: Colors.red,))
                                            ],
                                          ),
                                          Container(
                                            height: 1,
                                            width: MediaQuery.of(context).size.width*0.87,
                                            color: Colors.black54,
                                          )
                                        ],
                                      )
                                    );
                                  });
                            }
                            else {
                              print("user id :$userid");

                              return new Center(
                                child: Container(
                                    child: Text("No Notification Request")
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
                    ),
                  ],
                ),

              )
            ],
          ),
        ),
      ),


    );
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  void getUid() {
    final User user = auth.currentUser;
    userid = user.uid;
    // here you write the codes to input the data into firestore
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
  }

  Future<List<LocationModel>> getCountryList() async {
    List<LocationModel> list=new List();
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("country").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          LocationModel locationModel = new LocationModel(
            individualKey,
            DATA[individualKey]['name'],
            DATA[individualKey]['name_ar'],
          );
          list.add(locationModel);

        }
      }
    });
    list.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return list;
  }
  Future<List<LocationModel>> getCityList() async {
    List<LocationModel> list=new List();
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("country").child(selectedCountryId).child("city").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          LocationModel locationModel = new LocationModel(
            individualKey,
            DATA[individualKey]['name'],
            DATA[individualKey]['name_ar'],
          );
          list.add(locationModel);

        }
      }
    });

    list.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return list;
  }
  Future<List<LocationModel>> getAreaList() async {
    List<LocationModel> list=new List();
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("country").child(selectedCountryId).child("city").child(selectedCityId).child("area").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          LocationModel locationModel = new LocationModel(
            individualKey,
            DATA[individualKey]['name'],
            DATA[individualKey]['name_ar'],
          );
          list.add(locationModel);

        }
      }
    });
    list.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return list;
  }

  Future<void> _showCountryDailog(bool val) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          insetAnimationDuration: const Duration(seconds: 1),
          insetAnimationCurve: Curves.fastOutSlowIn,
          elevation: 2,

          child: Container(
            height: MediaQuery.of(context).size.height*0.4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text('country'.tr(),textAlign: TextAlign.center,style: TextStyle(fontSize: 25,color:Colors.black,fontWeight: FontWeight.w600),),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: IconButton(
                          icon: Icon(Icons.close,color: Colors.grey,),
                          onPressed: ()=>Navigator.pop(context),
                        ),
                      ),
                    )
                  ],
                ),

                Expanded(
                  child: FutureBuilder<List<LocationModel>>(
                    future: getCountryList(),
                    builder: (context,snapshot){
                      if (snapshot.hasData) {
                        if (snapshot.data != null && snapshot.data.length>0) {
                          return Container(
                            margin: EdgeInsets.all(10),
                            child: Scrollbar(
                              controller: _scrollController,
                              isAlwaysShown: snapshot.data.length>3?true:false,
                              child: ListView.separated(
                                controller: _scrollController,
                                separatorBuilder: (context, index) {
                                  return Divider(color: Colors.grey,);
                                },
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context,int index){
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        !val?selectedCountryName=snapshot.data[index].name_ar:selectedCountryName=snapshot.data[index].name;
                                        engCountry=snapshot.data[index].name;
                                        arCountry=snapshot.data[index].name_ar;
                                        selectedCountryId=snapshot.data[index].id;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      child: Text(!val?snapshot.data[index].name_ar:snapshot.data[index].name,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color:Colors.black),),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                        else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Lottie.asset(
                                  'assets/json/empty.json',
                                  width: MediaQuery.of(context).size.width*0.4,
                                  height: MediaQuery.of(context).size.height*0.2,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                  child: Text('noData'.tr(),style: TextStyle(fontSize: 16),)
                              ),
                            ],
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
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showCityDailog(bool val) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          insetAnimationDuration: const Duration(seconds: 1),
          insetAnimationCurve: Curves.fastOutSlowIn,
          elevation: 2,

          child: Container(
            height: MediaQuery.of(context).size.height*0.4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text('city'.tr(),textAlign: TextAlign.center,style: TextStyle(fontSize: 25,color:Colors.black,fontWeight: FontWeight.w600),),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: IconButton(
                          icon: Icon(Icons.close,color: Colors.grey,),
                          onPressed: ()=>Navigator.pop(context),
                        ),
                      ),
                    )
                  ],
                ),

                Expanded(
                  child: FutureBuilder<List<LocationModel>>(
                    future: getCityList(),
                    builder: (context,snapshot){
                      if (snapshot.hasData) {
                        if (snapshot.data != null && snapshot.data.length>0) {
                          return Container(
                            margin: EdgeInsets.all(10),
                            child: Scrollbar(
                              controller: _scrollController,
                              isAlwaysShown: snapshot.data.length>3?true:false,
                              child: ListView.separated(
                                controller: _scrollController,
                                separatorBuilder: (context, index) {
                                  return Divider(color: Colors.grey,);
                                },
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context,int index){
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        !val?selectedCityName=snapshot.data[index].name_ar:selectedCityName=snapshot.data[index].name;
                                        engCity=snapshot.data[index].name;
                                        arCity=snapshot.data[index].name_ar;
                                        selectedCityId=snapshot.data[index].id;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      child: Text(!val?snapshot.data[index].name_ar:snapshot.data[index].name,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color:Colors.black),),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                        else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Lottie.asset(
                                  'assets/json/empty.json',
                                  width: MediaQuery.of(context).size.width*0.4,
                                  height: MediaQuery.of(context).size.height*0.2,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                  child: Text('noData'.tr(),style: TextStyle(fontSize: 16),)
                              ),
                            ],
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
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAreaDailog(bool val) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          insetAnimationDuration: const Duration(seconds: 1),
          insetAnimationCurve: Curves.fastOutSlowIn,
          elevation: 2,

          child: Container(
            height: MediaQuery.of(context).size.height*0.4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text('areaSelect'.tr(),textAlign: TextAlign.center,style: TextStyle(fontSize: 25,color:Colors.black,fontWeight: FontWeight.w600),),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: IconButton(
                          icon: Icon(Icons.close,color: Colors.grey,),
                          onPressed: ()=>Navigator.pop(context),
                        ),
                      ),
                    )
                  ],
                ),

                Expanded(
                  child: FutureBuilder<List<LocationModel>>(
                    future: getAreaList(),
                    builder: (context,snapshot){
                      if (snapshot.hasData) {
                        if (snapshot.data != null && snapshot.data.length>0) {
                          return Container(
                              margin: EdgeInsets.all(10),
                              child: Scrollbar(
                                controller: _scrollController,
                                isAlwaysShown: snapshot.data.length>3?true:false,
                                child: ListView.separated(
                                  controller: _scrollController,
                                  separatorBuilder: (context, index) {
                                    return Divider(color: Colors.grey,);
                                  },
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context,int index){
                                    return GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          !val?selectedAreaName=snapshot.data[index].name_ar:selectedAreaName=snapshot.data[index].name;
                                          engArea=snapshot.data[index].name;
                                          arArea=snapshot.data[index].name_ar;
                                          selectedAreaId=snapshot.data[index].id;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        child: Text(!val?snapshot.data[index].name_ar:snapshot.data[index].name,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color:Colors.black),),
                                      ),
                                    );
                                  },
                                ),
                              )
                          );
                        }
                        else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Lottie.asset(
                                  'assets/json/empty.json',
                                  width: MediaQuery.of(context).size.width*0.4,
                                  height: MediaQuery.of(context).size.height*0.2,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                  child: Text('noData'.tr(),style: TextStyle(fontSize: 16),)
                              ),
                            ],
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
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> makeNotificationRequest() async {
    final ProgressDialog pr = ProgressDialog(context);
    await pr.show();
    final databaseReference = FirebaseDatabase.instance.reference();
    User user=FirebaseAuth.instance.currentUser;

    databaseReference.child("userNotification").push().set({
      'userid' : user.uid.toString(),
      'country': selectedCountryName,
      'city' : selectedCityName,
      'area': selectedAreaName,
      'notificationId' : notificationId,
      'propertyCategory' : isRent?"rent":"buy",
    }).whenComplete(() => pr.hide());
  }

  Future<List<UserNotificationModel>> getUserNotifications() async {
    List<UserNotificationModel> list=[];
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("userNotification").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null  ){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          UserNotificationModel userNotificationModel = new UserNotificationModel(
            DATA[individualKey]['userid'],
            DATA[individualKey]['city'],
            DATA[individualKey]['country'],
            DATA[individualKey]['area'],
            DATA[individualKey]['notificationId'],
            DATA[individualKey]['propertyCategory']

          );
          if(DATA[individualKey]['userid']==userid)
            {
              list.add(userNotificationModel);

            }
        }
      }
    });
    return list;
  }

  String randNumber()
  {
    return notificationId = rng.nextInt(100000).toString();
  }


}
