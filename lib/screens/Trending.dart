import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:propertymarket/admin/view_Trending.dart';
import 'package:propertymarket/model/trending_model.dart';
import 'package:propertymarket/navigator/admin_drawer.dart';
import 'package:propertymarket/values/constants.dart';
import 'package:propertymarket/values/shared_prefs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class Trending extends StatefulWidget {

  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  SharedPref sharedPref=new SharedPref();

  bool playing = false ;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  videoNetworkUrl(String data){
    _controller = VideoPlayerController.network(data,);

    _initializeVideoPlayerFuture = _controller.initialize();
  }
  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    super.initState();
  }
  deleteItem(String id)async{
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("trending").child(id).remove().then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (BuildContext context) => ViewTrending()));
    });
  }

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

  Future<List<TrendingModel>> getTrendingList() async {
    List<TrendingModel> list=new List();
    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference.child("trending").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value!=null){
        var KEYS= dataSnapshot.value.keys;
        var DATA=dataSnapshot.value;

        for(var individualKey in KEYS) {
          TrendingModel trendingModel = new TrendingModel(
            individualKey,
            DATA[individualKey]['video'],
            DATA[individualKey]['title'],
            DATA[individualKey]['title_ar'],
            DATA[individualKey]['details'],
            DATA[individualKey]['details_ar'],
            DATA[individualKey]['blog_link'],
            DATA[individualKey]['date'],

          );
          list.add(trendingModel);

        }
      }
    });

    return list;
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer () {
    _drawerKey.currentState.openDrawer();
  }
  bool addContainer=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body:SafeArea(
        child: Container(
          child: Column(
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
                      child: Text('Trending',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13),),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<TrendingModel>>(
                  future: getTrendingList(),
                  builder: (context,snapshot){
                    if (snapshot.hasData) {
                      if (snapshot.data != null && snapshot.data.length>0) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {

                              return InkWell(
                                  onTap: (){
                                    /* Navigator.push(
                                      context, MaterialPageRoute(builder: (BuildContext context) => NewsDetails(snapshot.data[index], true)));*/
                                  },
                                  child: Container(
/*
                                  margin: EdgeInsets.all(5),
*/
                                    child: Column(
                                      children: [

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(snapshot.data[index].title,maxLines: 2,style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500
                                            ),),
                                          ),
                                        ),
                                        Container(
                                          height: MediaQuery.of(context).size.height*0.4,
                                          width: double.infinity,
                                          child: VideoWidget(
                                            play: true,
                                            url: snapshot.data[index].video,
                                          ),
                                        ),

                                        Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(snapshot.data[index].details,style: TextStyle(
                                                    fontSize: 16,

                                                  ),)
                                                ]
                                            )
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),

                                        InkWell(
                                          onTap: ()async {
                                            await canLaunch(snapshot.data[index].blog_link)
                                                ? await launch(snapshot.data[index].blog_link)
                                                : throw 'Could not launch $snapshot.data[index].blog_link';},
                                          child: Container(
                                            height: 40,
                                            width: 300,
                                            decoration: BoxDecoration(
                                              borderRadius : BorderRadius.circular(12),
                                              color: primaryColor,

                                            ),
                                            child: Center(child: Text("Show More Details",style: TextStyle(
                                              color: Colors.white,
                                            ),)),
                                          ),
                                        ),

                                        SizedBox(
                                          height: 20,
                                        ),





                                      ],
                                    ),

                                  )                              );
                            });
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
              ),

            ],
          ),
        ),
      ),
    );
  }
}


class VideoWidget extends StatefulWidget {

  final bool play;
  final String url;

  const VideoWidget({Key key, @required this.url, @required this.play})
      : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}


class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController videoPlayerController ;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoPlayerController = new VideoPlayerController.network(widget.url);

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
  } // This closing tag was missing

  @override
  void dispose() {
    videoPlayerController.dispose();
    //    widget.videoPlayerController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return new Padding(
            padding: const EdgeInsets.all(0.0),
            child: Chewie(
              key: new PageStorageKey(widget.url),
              controller: ChewieController(

                videoPlayerController: videoPlayerController,
                aspectRatio: 2/1.6,
                // Prepare the video to be played and display the first frame
                autoInitialize: true,
                looping: false,
                autoPlay: false,
                // Errors can occur for example when trying to play a video
                // from a non-existent URL
                errorBuilder: (context, errorMessage) {
                  return Center(
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          );
        }
        else {
          return Container(
            height: size.height*0.45,
            width: size.width*0.95,
            decoration: BoxDecoration(
              //border: Border.all(color: Colors.black),
              color: Colors.grey.shade300,
            ),
            child: Center(
              child: CircularProgressIndicator(),),
          );
        }
      },
    );
  }
}
