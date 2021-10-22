import 'dart:convert';
import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:propertymarket/model/location.dart';
import 'package:propertymarket/values/constants.dart';
import 'package:propertymarket/values/shared_prefs.dart';
import 'package:toast/toast.dart';


enum rentOrBuy { rent, buy }
class AddProperty extends StatefulWidget {

  @override
  _AddPropertyState createState() => _AddPropertyState();
}

class _AddPropertyState extends State<AddProperty> {

  final FirebaseAuth auth = FirebaseAuth.instance;


  SharedPref sp = SharedPref();
  bool lang ;

  String getUserId() {
    // getting current user id
    final User user = auth.currentUser;
    return user.uid;
  }

  @override
  void initState() {
    final User user = auth.currentUser;
    if(user != null)
      {
        if(user.uid == adminId)
          {
            lang = true;
            print ("language is : $lang");

          }
        else {
          sp.getPref().then((value) {
            lang = value;
            print ("language is : $lang");

          });
        }
      }

    super.initState();

  }

  rentOrBuy _rentOrBuy = rentOrBuy.rent;
  String arBuy="بيع";
  String arRent="تاجير";
  String status,addPublisherId;
  bool isRent=true ;
  final enpriceController=TextEditingController();
  final arpriceController=TextEditingController();
  final numpriceController=TextEditingController();
  final wordPriceController=TextEditingController();
  final bedController=TextEditingController();
  final bathController=TextEditingController();
  final areaSqrftController=TextEditingController();
  final phoneController=TextEditingController();
  final emailController=TextEditingController();
  final countryController=TextEditingController();
  final cityController=TextEditingController();
  final areaController=TextEditingController();
  final typeController=TextEditingController();
  final descriptionController=TextEditingController();
  final paymentController=TextEditingController();
  final furnishController=TextEditingController();
  final agentNameController=TextEditingController();
  final floorController=TextEditingController();
  final snoController=TextEditingController();


  //arabic text field


  final arwordPriceController=TextEditingController();
  final ardescriptionController=TextEditingController();
  final arpaymentController=TextEditingController();
  final arfurnishController=TextEditingController();
  final aragentNameController=TextEditingController();

  String selectedCountryId="";
  String selectedCityId="";
  String selectedAreaId="";
  String selectedTypeId="";

  String selectedCountryAR="";
  String selectedCityAR="";
  String selectedAreaAR="";
  String selectedTypeAR="";
  bool isSponsered=false;





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
  Future<List<LocationModel>> getTypeList() async {
    List<LocationModel> list=new List();
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("type").once().then((DataSnapshot dataSnapshot){
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

  Future<void> _showCountryDailog() async {
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
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("Countries",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                Expanded(child: FutureBuilder<List<LocationModel>>(
                  future: getCountryList(),
                  builder: (context,snapshot){
                    if (snapshot.hasData) {
                      if (snapshot.data != null && snapshot.data.length>0) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context,int index){
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    countryController.text=snapshot.data[index].name;
                                    selectedCountryAR=snapshot.data[index].name_ar;
                                    selectedCountryId=snapshot.data[index].id;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Text(snapshot.data[index].name,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color:Colors.black),),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      else {
                        return new Center(
                          child: Container(
                              child: Text("No data found")
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
                )),
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
  Future<void> _showCityDailog() async {
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
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("City", textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),),
                ),
                Expanded(child: FutureBuilder<List<LocationModel>>(
                  future: getCityList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null && snapshot.data.length > 0) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    cityController.text =
                                        snapshot.data[index].name;
                                    selectedCityAR =snapshot.data[index].name_ar;
                                    selectedCityId = snapshot.data[index].id;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Text(snapshot.data[index].name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      else {
                        return new Center(
                          child: Container(
                              child: Text("No data found")
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
                ),),
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
  Future<void> _showAreaDailog() async {
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
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("Area",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                Expanded(child: FutureBuilder<List<LocationModel>>(
                  future: getAreaList(),
                  builder: (context,snapshot){
                    if (snapshot.hasData) {
                      if (snapshot.data != null && snapshot.data.length>0) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context,int index){
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    areaController.text=snapshot.data[index].name;
                                    selectedAreaAR=snapshot.data[index].name_ar;
                                    selectedAreaId=snapshot.data[index].id;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Text(snapshot.data[index].name,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color:Colors.black),),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      else {
                        return new Center(
                          child: Container(
                              child: Text("No data found")
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
                ),),
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
  Future<void> _showTypeDailog() async {
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
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("Property Type",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                Expanded(child: FutureBuilder<List<LocationModel>>(
                  future: getTypeList(),
                  builder: (context,snapshot){
                    if (snapshot.hasData) {
                      if (snapshot.data != null && snapshot.data.length>0) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context,int index){
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    typeController.text=snapshot.data[index].name;
                                    selectedTypeAR=snapshot.data[index].name_ar;
                                    selectedTypeId=snapshot.data[index].id;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Text(snapshot.data[index].name,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color:Colors.black),),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      else {
                        return new Center(
                          child: Container(
                              child: Text("No data found")
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
                )),
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

  String photoUrl="";
  final _formKey = GlobalKey<FormState>();

  submitData(){
    final databaseReference = FirebaseDatabase.instance.reference();
    print("url item ${imageURLs.length}");
    databaseReference.child("property").push().set({
      'addPublisherId' : addPublisherId,
      'status' : status,
      'name': wordPriceController.text,
      'price_ar': arpriceController.text,
      'price_en': enpriceController.text,
      'numericalPrice': int.parse(numpriceController.text),
      'beds': bedController.text,
      'bath': bathController.text,
      'call': phoneController.text,
      'city': cityController.text,
      'country': countryController.text,
      'datePosted': DateTime.now().toString(),
      'description': descriptionController.text,
      'email': emailController.text,
      'image': imageURLs,
      'location': "${areaController.text}, ${cityController.text}, ${countryController.text}",
      'measurementArea': areaSqrftController.text,
      'area': areaController.text,
      'coverImage':imageURLs[0],
      'typeOfProperty': typeController.text,
      'propertyCategory': isRent?"rent":"buy",
      'propertyCategoryAr': isRent?arRent:arBuy,
      'whatsapp': phoneController.text,
      'payment': paymentController.text,
      'furnish': furnishController.text,
      'agentName': agentNameController.text,
      'sponsered': isSponsered,
      'floor': floorController.text,
      'serial': snoController.text,
      'description_ar': ardescriptionController.text,
      'name_ar': arwordPriceController.text,
      'agentName_ar': aragentNameController.text,
      'payment_ar': arpaymentController.text,
      'furnish_ar': arfurnishController.text,
      'city_ar': selectedCityAR,
      'country_ar': selectedCountryAR,
      'area_ar': selectedAreaAR,
      'typeOfProperty_ar': selectedTypeAR,

    }).then((value) {
      if(getUserId() == adminId)
        {
          sendNotification();
          Toast.show("Submitted", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => AddProperty()));
        }
      else
        {
          Toast.show("Submitted", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        }



    }).catchError((onError){
      Toast.show(onError.toString(), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

    });
  }

  sendNotification() async{
    String url='https://fcm.googleapis.com/fcm/send';
    Uri myUri = Uri.parse(url);
    await http.post(
      myUri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'New Property Added',
            'title': 'New property added in ${areaController.text}, ${cityController.text}, ${countryController.text} at ${enpriceController.text}'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': "/topics/user",
        },
      ),
    );
  }

  List<File> imageFiles=[];
  List<String> imageURLs=[];
  List<String> _progress=[];
  File imagefile;
  void fileSet(File file){
    setState(() {
      if(file!=null){
        imagefile=file;
        imageFiles.add(file);
        _progress.add("Uploading");
      }
    });
    uploadImageToFirebase(context);
  }
  Future<File> _chooseGallery() async{
    await ImagePicker().getImage(source: ImageSource.gallery).then((value) => fileSet(File(value.path)));

  }
  Future<File> _choosecamera() async{
    await ImagePicker().getImage(source: ImageSource.camera).then((value) => fileSet(File(value.path)));

  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _chooseGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _choosecamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  int photoIndex=-1;

  Future uploadImageToFirebase(BuildContext context) async {
    firebase_storage.Reference firebaseStorageRef = firebase_storage.FirebaseStorage.instance.ref().child('uploads/${DateTime.now().millisecondsSinceEpoch}');
    firebase_storage.UploadTask uploadTask = firebaseStorageRef.putFile(imagefile);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
          (value) {
            photoUrl=value;
            imageURLs.add(value);
            print("value $value");
            setState(() {
              _progress[_progress.length-1]="";
            });
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            imageFiles.length>0?
            Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[300],
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Container(
                      child: GestureDetector(
                        onTap: (){
                          if(_progress[_progress.length-1]==""){
                            _showPicker(context);
                          }
                          else
                            Toast.show("Image Uploading", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                        },
                        child: Image.asset("assets/images/add.png",width: 50,height: 50,),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      margin: EdgeInsets.all(10),
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageFiles.length,
                        itemBuilder: (BuildContext context,int index){
                          return GestureDetector(
                            onTap: (){

                            },
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                              return FullScreenImage(
                                                imageUrl: imageFiles[index],
                                                tag: "generate_a_unique_tag",
                                              );
                                            }));
                                      },
                                      child: Hero(
                                        child : Container(
                                          height: 85,
                                          width: 85,
                                          margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: FileImage(imageFiles[index]),
                                                fit: BoxFit.cover,
                                              )
                                          ),
                                        ),

                                        tag: "generate_a_unique_tag",
                                      ),
                                    ),
                                    Positioned(
                                        top : 5,
                                        right : 10,
                                        child: InkWell(
                                          onTap : ()  {
                                            print("button press");
                                             setState(() {
                                                   imageFiles.removeAt(index);
                                                   imageFiles.sort();
                                                   imageURLs.removeAt(index);
                                                   imageURLs.sort();
                                             });
                                            },

                                            child: Icon(Icons.delete,color: Colors.red,))
                                    ),
                                  ],
                                ),
                                Text(_progress[index],style: TextStyle(fontSize: 12),)
                              ],
                            )
                          );
                        },
                      ),
                    )
                  ],
                )
            ):
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: GestureDetector(
                    onTap: (){
                      _showPicker(context);
                    },
                    child: Image.asset("assets/images/add.png",width: 50,height: 50,),
                  ),
                ),

            Table(
              columnWidths: {0: FractionColumnWidth(.3), 1: FractionColumnWidth(.7)},
              border: TableBorder.all(width: 0.5,color: Colors.grey),
              children: [
                TableRow(
                    children: [
                      Container(
                        child: Text('Name',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5),
                      ),
                      Column(
                        children: [
                          Container(
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              maxLines: 1,
                              controller: arwordPriceController,
                              decoration: InputDecoration(hintText:"Enter Name (arabic)",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                            ),
                          ),
                          Divider(color: Colors.grey[600],),
                          Container(
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              maxLines: 1,
                              controller: wordPriceController,
                              decoration: InputDecoration(hintText:"Enter Name (English)",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                            ),
                          ),

                        ],
                      )


                    ]),
                TableRow(
                    children: [
                      Container(
                        child: Text('Price',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5),
                      ),
                      Column(
                        children: [
                          Container(
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller:enpriceController,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              decoration: InputDecoration(hintText:"Price (English)",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                            ),
                          ),
                          Divider(color: Colors.grey[600],),
                          Container(
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller:arpriceController,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              decoration: InputDecoration(hintText:"Price (Arabic)",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                            ),
                          ),
                          Divider(color: Colors.grey[600],),
                          Container(
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller:numpriceController,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              decoration: InputDecoration(hintText:"Number only (for sorting)",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                            ),
                          ),
                        ],
                      )


                    ]),
                TableRow(
                    children: [
                      Container(
                        child: Text('Serial Number',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5),
                      ),

                      Container(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller:snoController,
                          maxLines: 1,
                          decoration: InputDecoration(hintText:"Enter Serial No (Any Number)",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                        ),
                      ),
                    ]),
                TableRow(
                    children: [
                      Container(
                        child: Text('Beds',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5),
                      ),

                      Container(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          controller: bedController,
                          decoration: InputDecoration(hintText:"0",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                        ),
                      ),
                    ]),
                TableRow(
                    children: [
                      Container(
                        child: Text('Baths',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5),
                      ),

                      Container(
                        child: TextFormField(
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: bathController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText:"0",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                        ),
                      ),
                    ]),
                TableRow(
                    children: [
                      Container(
                        child: Text('Area',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5),
                      ),
                      Container(
                        child: TextFormField(
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: areaSqrftController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText:"In meters",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                        ),
                      ),

                    ]),
                TableRow(
                    children: [
                      Container(
                        child: Text('Floors',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5),
                      ),
                      Container(
                        child: TextFormField(
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: floorController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText:"0",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                        ),
                      ),

                    ]),
                TableRow(
                    children: [
                      Container(

                        child: Text('Description',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5),
                      ),
                      Column(
                        children: [
                          Container(
                            child: TextFormField(
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: descriptionController,
                              decoration: InputDecoration(hintText:"Property Description (English)",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                            ),
                          ),
                          Divider(color: Colors.grey[600],),
                          Container(
                            child: TextFormField(
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: ardescriptionController,
                              decoration: InputDecoration(hintText:"Property Description (arabic)",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                            ),
                          ),

                        ],
                      )

                    ]),

                TableRow(
                    children: [
                      Container(
                        child: Text('Phone Number',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5),
                      ),

                      Container(
                        child: TextFormField(
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(hintText:"Enter Phone Number",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                        ),
                      ),
                    ]),
                TableRow(
                    children: [
                      Container(
                        child: Text('Email',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5),
                      ),
                      Container(
                        child: TextFormField(
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: emailController,
                          decoration: InputDecoration(hintText:"Enter Email",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                        ),
                      ),
                    ]),
                TableRow(
                    children: [
                      Container(
                        child: Text('Agent Name',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5),
                      ),
                      Column(
                        children: [
                          Container(
                            child: TextFormField(
                              maxLines: 1,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: agentNameController,

                              decoration: InputDecoration(hintText:"Enter Agent Name",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                            ),
                          ),
                          Divider(color: Colors.grey[600],),
                          Container(
                            child: TextFormField(
                              maxLines: 1,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: aragentNameController,

                              decoration: InputDecoration(hintText:"Enter Agent Name (arabic)",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                            ),
                          ),

                        ],
                      )

                    ]),
                TableRow(
                    children: [
                      Container(
                        child: Text('Country',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5),
                      ),
                      Container(
                        child: TextFormField(
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: countryController,
                          readOnly: true,
                          onTap: (){
                            _showCountryDailog();
                          },
                          decoration: InputDecoration(hintText:"Enter Country",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                        ),
                      ),
                    ]),
                TableRow(
                    children: [
                      Container(
                        child: Text('City',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5),
                      ),
                      Container(
                        child: TextFormField(
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: cityController,
                          readOnly: true,
                          onTap: (){
                            _showCityDailog();
                          },
                          decoration: InputDecoration(hintText:"Enter City",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                        ),
                      ),
                    ]),
                TableRow(
                    children: [
                      Container(
                        child: Text('Area',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5),
                      ),
                      Container(
                        child: TextFormField(
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: areaController,
                          readOnly: true,
                          onTap: (){
                            _showAreaDailog();
                          },
                          decoration: InputDecoration(hintText:"Enter Area",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                        ),
                      ),
                    ]),
                TableRow(
                    children: [
                      Container(
                        child: Text('Property Type',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5),
                      ),
                      Container(
                        child: TextFormField(
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          readOnly: true,
                          controller: typeController,
                          onTap: (){
                            _showTypeDailog();
                          },
                          decoration: InputDecoration(hintText:"Enter Property Type",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                        ),
                      ),
                    ]),
                TableRow(
                    children: [
                      Container(
                        child: Text('Payment Type',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5),
                      ),
                      Column(
                        children: [
                          Container(
                            child: TextFormField(
                              maxLines: 1,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: paymentController,

                              decoration: InputDecoration(hintText:"Enter Payment Type",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                            ),
                          ),
                          Divider(color: Colors.grey[600],),
                          Container(
                            child: TextFormField(
                              maxLines: 1,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: arpaymentController,

                              decoration: InputDecoration(hintText:"Enter Payment Type (arabic)",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                            ),
                          ),

                        ],
                      )

                    ]),
                TableRow(
                    children: [
                      Container(
                        child: Text('Furnishing',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w600),),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5),
                      ),
                      Column(
                        children: [
                          Container(
                            child: TextFormField(
                              maxLines: 1,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: furnishController,

                              decoration: InputDecoration(hintText:"Enter Furnish details",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                            ),
                          ),
                          Divider(color: Colors.grey[600],),
                          Container(
                            child: TextFormField(
                              maxLines: 1,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: arfurnishController,

                              decoration: InputDecoration(hintText:"Enter Furnish details (arabic)",contentPadding: EdgeInsets.only(left: 10), border: InputBorder.none,),
                            ),
                          ),

                        ],
                      )

                    ]),






              ],
            ),

            CheckboxListTile(
                title: Text("Sponsered Property"),
                value: isSponsered,
                activeColor: primaryColor,
                onChanged: (bool value){
                  setState(() {
                    isSponsered=value;

                  });
                }
            ),

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
                    });
                  },
                ),
                new Text(
                  'Rent',
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
                  'Buy',
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: RaisedButton(
                onPressed: (){
                  print("url lenght : ${imageURLs.length}");
                  if (_formKey.currentState.validate()) {
                    if(imageURLs.length>0)
                      {
                        if( getUserId() == adminId  )
                          {
                            status = "approved";
                            addPublisherId = getUserId();
                            submitData();
                            getNotificationUser();
                          }
                        else{
                          status = "pending";
                          addPublisherId = getUserId();
                          submitData();
                        }
                      }
                    else
                      {
                        Toast.show("Please add atleast on image", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                      }
                  }
                  else{
                    Toast.show("Enter all the fields", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                  }


                },
                color: primaryColor,
                child: Text("Add Property",style: TextStyle(color: Colors.white),),
              ),
            )
          ],
        ),
      )
    );
  }
  Future getNotificationUser ()async
  {
    String category ;
    isRent ? category = "rent" : category = "buy" ;
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("userNotification").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null ){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {

          if( DATA[individualKey]['country'] == countryController.text && DATA[individualKey]['city']  == cityController.text && DATA[individualKey]['area'] == areaController.text &&  DATA[individualKey]['propertyCategory'] == category && DATA[individualKey]['type'] == typeController.text )
            {
              FirebaseDatabase.instance.reference().child("userData").child(DATA[individualKey]['userid']).once().then((DataSnapshot userSnapshot)
                  {
                    sendPropertyNotification(userSnapshot.value['token']);
                  });
            }

        }
      }
    });
  }
  sendPropertyNotification(String token) async{
    String url='https://fcm.googleapis.com/fcm/send';
    Uri myUri = Uri.parse(url);
    await http.post(
      myUri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'The Property Type You Have Asked For Is Added',
            'title': 'Your Wish list Property Is Added'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': '$token',
        },
      ),
    );
  }


}


class FullScreenImage extends StatelessWidget {
  final File imageUrl;
  final String tag;

  const FullScreenImage({Key key, this.imageUrl, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: tag,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                 image : FileImage(
                     imageUrl,
                  ),
                  fit: BoxFit.contain,

                )
              ),
            )
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}