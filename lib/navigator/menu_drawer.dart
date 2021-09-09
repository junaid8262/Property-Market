import 'package:overlay_support/overlay_support.dart';
import 'package:propertymarket/admin/User_Adds.dart';
import 'package:propertymarket/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propertymarket/data/img.dart';
import 'package:propertymarket/data/my_colors.dart';
import 'package:propertymarket/navigator/bottom_navigation.dart';
import 'package:propertymarket/screens/MyAdds.dart';
import 'package:propertymarket/screens/My_Chats.dart';
import 'package:propertymarket/screens/My_Profile.dart';
import 'package:propertymarket/screens/Notify.dart';
import 'package:propertymarket/screens/chat.dart';
import 'package:propertymarket/screens/favourites.dart';
import 'package:propertymarket/screens/home.dart';
import 'package:propertymarket/values/constants.dart';
import 'package:propertymarket/widget/my_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

import '../privacy_webview.dart';
class MenuDrawer extends StatefulWidget {


  @override
  MenuDrawerState createState() => new MenuDrawerState();
}


class MenuDrawerState extends State<MenuDrawer> {


  void onDrawerItemClicked(String name){
    Navigator.pop(context);
  }

  Future<void> _showInfoDailog() async {
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
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("Contact Information",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text("Phone Number"),
                ),
                ListTile(
                  leading: Icon(Icons.email_outlined),
                  title: Text("Email"),
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

  Future<void> _showChangeLanguageDailog() async {
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
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text('changeLanguage'.tr(),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600),),
                ),
                ListTile(
                  onTap: (){
                    context.locale = Locale('ar', 'EG');
                    Navigator.pop(context);
                  },
                  title: Text('arabic'.tr()),
                ),
                ListTile(
                  onTap: (){
                    context.locale = Locale('en', 'US');
                    Navigator.pop(context);
                  },
                  title: Text("English"),
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

  void _launchURL() async => await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';




  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[



          SizedBox(height: 30,),
          InkWell(
            onTap: (){
              Navigator.pushReplacement(context, new MaterialPageRoute(
                  builder: (context) => BottomBar()));
            },
            child: Container(
              alignment: Alignment.center,
              child: Image.asset('icon'.tr(),height: 150,),
            ),
          ),

          SizedBox(height: 30,),
          InkWell(
            onTap: (){
              User user=FirebaseAuth.instance.currentUser;
              if(user == null)
                {
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => Login()));
                }
              else
                {
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => MyProfile()));
                }

            },
            child:  Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.person, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text("myProfile".tr(),)),
                ],
              ),
            ),
          ),

          SizedBox(height: 10,),
          InkWell(
            onTap: (){

              User user=FirebaseAuth.instance.currentUser;
              if(user == null)
              {
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => Login()));
              }
              else
              {
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => MyAdds()));
              }

            },
            child:  Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.receipt, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text("myAdds".tr(),)),
                ],
              ),
            ),
          ),

          SizedBox(height: 10,),
          InkWell(
            onTap: (){
              User user=FirebaseAuth.instance.currentUser;
              if(user == null)
              {
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => Login()));
              }
              else
              {
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => MyChats()));
              }

            },
            child:  Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.chat_sharp, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text("myChat".tr(),)),
                ],
              ),
            ),
          ),

          SizedBox(height: 10,),
          InkWell(
            onTap: (){
              User user=FirebaseAuth.instance.currentUser;
              if(user == null)
              {
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => Login()));
              }
              else
              {
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => Chat(peerId: adminId,name: "Admin",)));
              }

            },
            child:  Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.admin_panel_settings, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text('contactAdmin'.tr(),)),
                ],
              ),
            ),
          ),

          SizedBox(height: 10,),
          InkWell(
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => Notify()));
            },
            child:  Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.notifications, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text('notification'.tr(),)),
                ],
              ),
            ),
          ),

          SizedBox(height: 10,),
          InkWell(
            onTap: ()async{
              await canLaunch(url) ? await launch(url) : throw  'Could not launch $url';
            },
            child: Container(height: 40, padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Icon(Icons.assignment_outlined, color: MyColors.grey_20, size: 20),
                  Container(width: 20),
                  Expanded(child: Text('privacy'.tr(), style: MyText.body2(context).copyWith(color: MyColors.grey_80))),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
