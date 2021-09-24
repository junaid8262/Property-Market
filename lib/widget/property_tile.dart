import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:propertymarket/model/property.dart';
import 'package:propertymarket/screens/chat.dart';
import 'package:propertymarket/values/constants.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
class PropertyTile extends StatefulWidget {
  Property property;
  bool lang;

  PropertyTile(this.property,this.lang);

  @override
  _PropertyTileState createState() => _PropertyTileState();
}

class _PropertyTileState extends State<PropertyTile> {


  static String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    DateTime date = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} ${'yearAgo'.tr()}';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1yearAgo'.tr() : 'lastYear'.tr();
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} ${'monthsAgo'.tr()}';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month ago'.tr() : 'lastMonth'.tr();
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} ${'weeksAgo'.tr()}';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1weekAgo'.tr() : 'lastWeek'.tr();
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} ${'daysAgo'.tr()}';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1dayAgo'.tr() : 'yesterday'.tr();
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} ${'hoursAgo'.tr()}';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1hourAgo'.tr() : 'anHourAgo'.tr();
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} ${'minutesAgo'.tr()}';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1minuteAgo'.tr() : 'aminuteAgo'.tr();
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} ${'secondsAgo'.tr()}';
    } else {
      return 'justNow'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Container(
                    height: 120,
                    margin: EdgeInsets.only(left: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.property.image[0],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  )
              ),
              Expanded(
                  flex: 7,
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(timeAgoSinceDate(widget.property.datePosted),style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300),),

                            widget.property.sponsered?Row(
                              children: [
                                Image.asset("assets/images/sponsor.png",width: 20,height: 20,),
                                SizedBox(width: 5,),
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(right: 5),
                                  child: Text('sponsored'.tr(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
                                )
                              ],
                            ):Container(),
                          ],
                        ),


                        Text(widget.lang?widget.property.name:widget.property.name_ar,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.black),),
                        SizedBox(height: 5,),
                        Text(widget.lang?widget.property.location:"${widget.property.area_ar}, ${widget.property.city_ar}, ${widget.property.country_ar}",style: TextStyle(fontSize: 15,color: Colors.black),),
                        SizedBox(height: 5,),
                        Text(widget.lang?"${widget.property.price_en.toString()}":"${widget.property.price_ar.toString()}",style: TextStyle(fontSize: 15,color: Colors.black),),
                        SizedBox(height: 5,),
                        Text(widget.lang?"${widget.property.payment.toString()}":"${widget.property.payment_ar.toString()}",style: TextStyle(fontSize: 15,color: Colors.black),),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(

                              children: [
                                Row(
                                  children: [
                                    Image.asset("assets/images/bed.png",width: 15,height: 15,),
                                    SizedBox(width: 5,),
                                    Text(widget.property.beds),
                                    SizedBox(width: 5,),
                                    Image.asset("assets/images/bath.png",width: 15,height: 15,),
                                    SizedBox(width: 5,),
                                    Text(widget.property.bath),
                                    SizedBox(width: 5,),
                                    Image.asset("assets/images/square.png",width: 15,height: 15,),
                                    SizedBox(width: 5,),
                                    Text("${widget.property.measurementArea} m"),
                                  ],
                                ),
                              ],
                            ),
                            Text(widget.lang?"${widget.property.propertyCategory}":"${widget.property.propertyCategoryAr}  ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),),
                          ],
                        ),
                        SizedBox(height: 10,),


                      ],
                    ),
                  )
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)
              )
            ),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    launch("tel://${widget.property.whatsapp}");
                  },
                  child: Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.phone_outlined,color: Colors.white,),
                          SizedBox(width: 5,),
                          Text('call'.tr(),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.white),),
                        ],
                      )
                  ),
                ),
                VerticalDivider(color: Colors.white,),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.email_outlined,color: Colors.white,),
                        SizedBox(width: 5,),
                        Text('email'.tr(),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.white),),
                      ],
                    )
                  ),
                  onTap: (){

                    final Uri _emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: widget.property.email,
                        queryParameters: {
                          'subject': 'Hi there, I am looking to list a property'
                        }
                    );
                    launch(_emailLaunchUri.toString());

                  },
                ),
                VerticalDivider(color: Colors.white,),
                InkWell(
                  onTap: (){

                    User user = FirebaseAuth.instance.currentUser;
                    if(user.uid != widget.property.addPublisherId)
                    {
                      FirebaseDatabase.instance.reference().child("userData").child(widget.property.addPublisherId).once().then((DataSnapshot peerSnapshot){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    Chat(peerId: widget.property.addPublisherId, name: peerSnapshot.value['username'])));
                      }
                        //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Chat(peerId: widget._property.addPublisherId,name: widget._property.agentName,)));
                      );}
                    else
                    {
                      Toast.show("Cant Chat With Yourself", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP,textColor: Colors.white , backgroundColor: primaryColor);
                      print("cant chat with your self");
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.message,color: Colors.white,),
                        SizedBox(width: 5,),
                        Text('message'.tr(),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.white),),
                      ],
                    )
                  ),
                ),



              ],
            ),
          )
        ],
      )
    );
  }
}
