import 'dart:collection';
import 'dart:convert';
import 'dart:ui';

import 'package:bosdyn/screens/test_screen.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_covid_dashboard_ui/config/palette.dart';
//import 'package:flutter_covid_dashboard_ui/config/styles.dart';
//import 'package:flutter_covid_dashboard_ui/data/data.dart';
import 'package:bosdyn/widgets/widgets.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:bosdyn/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class SubmitScreen extends StatefulWidget {
  @override
  _SubmitScreenState createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  FSBStatus status = FSBStatus.FSB_CLOSE;
  @override
  Widget build(BuildContext context) {
    //api();
   
    final screenHeight = MediaQuery.of(context).size.height;
    FSBStatus drawerStatus;
    return SafeArea(
      child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: CustomAppBar(),
      body: SwipeDetector(
        onSwipeRight: (){
          setState(() {
            status = FSBStatus.FSB_OPEN;
          });
        } ,
        onSwipeLeft: (){
          setState(() {
            status = FSBStatus.FSB_CLOSE;
          });
        },
        child: FoldableSidebarBuilder(
        status: status,drawer: CustomDrawer(),screenContents: 
        CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          //_buildHeader(screenHeight),
          //_buildImageShow(screenHeight),
          _buidSubmitTitle(screenHeight),
          _buidSubmitDashBroad(screenHeight),
          //_buidSubmitButton(screenHeight),
          //_buildTopBrandsContent(screenHeight),
          //_buildYourStyle(screenHeight),
          //_buildYourStyleContent(screenHeight),
        ],
        ),
        drawerBackgroundColor: Colors.black,),
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: (){
        setState(() {
          status = status == FSBStatus.FSB_OPEN?FSBStatus.FSB_CLOSE:FSBStatus.FSB_OPEN;
        });
      },child: FaIcon(FontAwesomeIcons.bars,color: Colors.black,),),
    )
      );
    
    
  }
  SliverToBoxAdapter _buidSubmitTitle(double screenHeight) {
    Firebase_content();
    return SliverToBoxAdapter(
      
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child:RichText(
                text: TextSpan(
                
                            children: [
                              TextSpan(
                                text: "Audio Files ",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  )
                              ),
                              WidgetSpan(
                                child:  Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: globals.isLoggedIn?
                                        FaIcon(FontAwesomeIcons.solidCheckCircle,color: Colors.blue):
                                        FaIcon(FontAwesomeIcons.solidTimesCircle,color: Colors.red),
                                      ),
                                )
                            ]
                          )),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
  
    SliverToBoxAdapter _buidSubmitDashBroad(double screenHeight) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    List<ListTile> audio_list = [];
    int i;
    if (globals.Contents_list.length>0){
      for(i =0;i<globals.Contents_list.length;i++){
      audio_list.add(_buidAudioList(screenHeight,i));
      }
      print(i.toString());
    }
  
    return SliverToBoxAdapter(
      child: Center(
        //padding: const EdgeInsets.all(20.0),
        child: 
        !globals.isLoggedIn?
        Text("")
        :
        Container(
          //scrollDirection: Axis.vertical,
          width: mediaQuery.size.width * 0.85,
          height: mediaQuery.size.height,
          child: 
          SingleChildScrollView(
            child: 
            Column(
            children: [ 
                ListView(
                    semanticChildCount: 6,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: audio_list,
                    // children: <Widget>[
                          // ListTile(
                          //   onTap: (){
                          //     debugPrint("Tapped Profile");
                          //   },
                          //   onLongPress: (){
                          //     print('alert dialog');
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       SnackBar(
                          //       backgroundColor: Colors.black,
                          //       content: Column(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //         Text('Fliename : '+globals.Filename_list[0],style: TextStyle(color:Colors.blue)),
                          //         Text('Languages : '+globals.Lang_list[0].toString().toUpperCase(),style: TextStyle(color:Colors.blue)),
                          //         Text('Contents : '+globals.Contents_list[0],style: TextStyle(color:Colors.blue))
                          //         ]
                          //       )
                                
                                
                          //     )
                          //     );
                          //   },
                          //   leading: FaIcon(FontAwesomeIcons.solidFileAudio,color: Colors.blue,),//Icon(Icons.person,color: Colors.blue,),
                          //   title: Text(
                          //     globals.Filename_list[0],
                          //     style: TextStyle(
                          //       color: Colors.blue
                          //     ),
                          //   ),
                          //   subtitle: Text('Lang: '+globals.Lang_list[0].toString().toUpperCase(),style: TextStyle(
                          //     color: Colors.blue
                          //   )),
                          //   trailing: globals.isApiCon?
                          //     IconButton(
                          //     splashColor: Colors.blue,
                          //     highlightColor: Colors.blue,
                          //     onPressed: 
                          //     (){
                          //       print("check button");
                          //     }, icon: FaIcon(
                          //     FontAwesomeIcons.solidPlayCircle,
                          //     color: Colors.blue,)):
                          //     FaIcon(
                          //     FontAwesomeIcons.solidTimesCircle,
                          //     color: Colors.red,),
                          // ),
                          
                          
                          // Container(
                          //    height: screenHeight*0.1,
                          //    width: MediaQuery.of(context).size.width/2,
                          // child: Card(
                          //   semanticContainer: true,
                          //   margin: EdgeInsets.all(10),
                          //   elevation: 10,
                          //   color: Colors.blue,
                          //    shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(10.0),
                          //     ),
                          //   child: InkWell(
                          //     splashColor: Colors.blue.withAlpha(30),
                          //     onLongPress: (){
                          //       print("long");
                          //     },
                          //     onTap: () {
                          //       print('Card  tapped.');
                          //     },
                          //     child: Row(
                                
                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       //crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Text(' data.wav',
                          //         textAlign: TextAlign.center,
                          //         style: TextStyle(
                          //           color: Colors.black
                          //         ),
                          //         ),
                          //         Text('10 seconds',
                          //         textAlign: TextAlign.center,
                          //         style: TextStyle(
                          //           color: Colors.black
                          //         ),
                          //         ),
                          //         // IconButton(onPressed: (){
                          //         // }, icon: FaIcon(FontAwesomeIcons.upload,color: Colors.black)),
                          //         IconButton(onPressed: (){
                          //         }, icon: FaIcon(FontAwesomeIcons.playCircle,color: Colors.black))
                          //       ],
                          //     )
                              
                          //     ),
                          //     ),
                          //   )
                    //],
                  ),
                ],
                )
          ,)
          
        ),
      ),
    );
  }
  ListTile _buidAudioList(double screenHeight,int index) {
    
    return    ListTile(
                      onTap: (){
                        debugPrint("Tapped Profile");
                      },
                      onLongPress: (){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                          backgroundColor: Colors.black,
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text('Fliename : '+globals.Filename_list[index],style: TextStyle(color:Colors.blue)),
                            Text('Languages : '+globals.Lang_list[index].toString().toUpperCase(),style: TextStyle(color:Colors.blue)),
                            Text('Contents : '+globals.Contents_list[index],style: TextStyle(color:Colors.blue)),
                            SizedBox(height: 10,),
                            Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green
                                ),
                                onPressed: (){
                                  
                                },
                                onLongPress: () async{
                                  print("Click button ");
                                  print(globals.Filename_list[index]);
                                  String api_url = globals.API_IP;
                                  String url =  'https://'+api_url+'.ngrok.io/Play_Audio_Firebase';
                                try{
                                  final response = await  http.post(
                                    Uri.parse(url),
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body: jsonEncode(<String, String>{
                                      'user': globals.username,
                                      'password':globals.password,
                                      'ip':globals.IP,
                                      'filename':globals.Filename_list[index],
                                    }),
                                  );
                                  if (response.statusCode == 200) {
                                    
              
                                    var api_result = jsonDecode(response.body);
                                    print(api_result);
                                    // globals.SayByTextResult = api_result['issue'];
                                    // globals.SayByTextContent = globals.statement;
                                    // globals.SayByTextStatus = api_result['result'];
                                    // print(globals.SayByTextContent);
                                    globals.statement = "";
                                    globals.isApiCon = true;
                                    print("works");
                                    //return "work";
                                    } 
                                }catch (error){
                                  print("post error");
                                }
                              },
                              child: 
                              RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  // style: TextStyle(
                                  //   backgroundColor: Colors.green,
                                  // ),
                                  children: [
                                    TextSpan(
                                            text: "PLAY ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              )
                                          ),
                                    WidgetSpan(
                                      child: FaIcon(FontAwesomeIcons.solidPlayCircle,color: Colors.black),
                                    )
                                  ]
                                ),
                              )
                              ),
                            ),
                            Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red
                                ),
                                onPressed: () async{
                                  print("Click  DELETE button ");
                                  print(globals.Filename_list[index]);
                                  String api_url = globals.API_IP;
                                  String url =  'https://'+api_url+'.ngrok.io/Del_Audio_Firebase';
                                try{
                                  final response = await  http.post(
                                    Uri.parse(url),
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body: jsonEncode(<String, String>{
                                      'user':globals.username,
                                      'filename':globals.Filename_list[index],
                                      'contents':globals.Contents_list[index],
                                      'link':globals.Link_list[index]
                                    }),
                                  );
                                  if (response.statusCode == 200) {
                                    
              
                                    var api_result = jsonDecode(response.body);
                                    print(api_result);
                                    // globals.SayByTextResult = api_result['issue'];
                                    // globals.SayByTextContent = globals.statement;
                                    // globals.SayByTextStatus = api_result['result'];
                                    // print(globals.SayByTextContent);
                                    globals.statement = "";
                                    globals.isApiCon = true;
                                    print("works");
                                    globals.Contents_list = [];
                                    //return "work";
                                    } 
                                }catch (error){
                                  print("post error");
                                }
                              },
                              child: 
                              RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  // style: TextStyle(
                                  //   backgroundColor: Colors.green,
                                  // ),
                                  children: [
                                    TextSpan(
                                            text: "DELETE ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              )
                                          ),
                                    WidgetSpan(
                                      child: FaIcon(FontAwesomeIcons.solidTrashAlt,color: Colors.black),
                                    )
                                  ]
                                ),
                              )
                              ),
                            ),
                            ]
                          )
                          
                          
                        )
                        );
                      },
                      leading: FaIcon(FontAwesomeIcons.solidFileAudio,color: Colors.blue,),//Icon(Icons.person,color: Colors.blue,),
                      title: Text(
                        globals.Filename_list[index],
                        style: TextStyle(
                          color: Colors.blue
                        ),
                      ),
                      subtitle: Text('Lang: '+globals.Lang_list[index].toString().toUpperCase(),style: TextStyle(
                        color: Colors.blue
                      )),
                      trailing: globals.isApiCon?
                        IconButton(
                        splashColor: Colors.blue,
                        highlightColor: Colors.blue,
                        onPressed: 
                        () async {
                          print("check button");
                          // play_firebase();
                          final assetsAudioPlayer = AssetsAudioPlayer();
                            try {
                                await assetsAudioPlayer.open(
                                    Audio.network(globals.Link_list[index]),
                                );
                            } catch (t) {
                                //mp3 unreachable
                            }
                          
                        }, icon: FaIcon(
                        FontAwesomeIcons.solidPlayCircle,
                        color: Colors.blue,)):
                        FaIcon(
                        FontAwesomeIcons.solidTimesCircle,
                        color: Colors.red,),
                    
      );
    
  }
  
  SliverToBoxAdapter _buidSubmitButton(double screenHeight) {
    return SliverToBoxAdapter(
      child: Center(
        //padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10.0),
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Column(
            //       children: [
            //         FlatButton.icon(
            //           padding: const EdgeInsets.symmetric(
            //             vertical: 10.0,
            //             horizontal: 20.0,
            //           ),
            //           onPressed: () {},
            //           color: Colors.blue,
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(30.0),
            //           ),
            //           icon: const Icon(
            //             Icons.chat_bubble,
            //             color: Colors.white,
            //           ),
            //           label: Text(
            //             'Self-delivery',
            //             // style: Styles.buttonTextStyle,
            //           ),
            //           textColor: Colors.white,
            //         ),
            //       ],
            //     ),
                
            //   ],
            // ),
            
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  
  
  
  
  
 
  void Firebase_content() async{
              Future<String> fetchApi() async {
                        print("AM IN FireBase API");
                        if(globals.isLoggedIn==true){
                          //print(globals.lang);
                  
                          String api_url = globals.API_IP;
                          String url =  'https://'+api_url+'.ngrok.io/Audio_Firebase';
                          //globals.justSayByText = true;
                          // if(globals.lang==''){
                          //   globals.lang = 'en';
                          // }
                          try{
                            final response = await  http.post(
                              Uri.parse(url),
                              headers: <String, String>{
                                'Content-Type': 'application/json; charset=UTF-8',
                              },
                              body: jsonEncode(<String, String>{
                                'user': globals.username,
                              }),
                            );
                            if (response.statusCode == 200) {
                              // If the server did return a 200 OK response,
                              // then parse the JSON.
                              //return Album.fromJson(jsonDecode(response.body));
                              var api_result = jsonDecode(response.body);
                              if( api_result['filename'][0]== ''){
                                
                              }
                              else{
                              globals.Filename_list = api_result['filename'];
                              globals.Lang_list = api_result['lang'];
                              globals.Contents_list = api_result['contents'];
                              globals.Link_list = api_result['link'];
                              print(api_result['contents']);
                              }
                              return "work";
                              } 
                          }catch (error){
                            print("post error");
                          }
                          
                          
                          
                        }
                        //globals.isApiCon = false;
                        print('api not working');
                        return "api not working";
                        
                      }
          await fetchApi();  
    }
    void play_firebase() async{
              Future<String> fetchApi() async {
                        print("AM IN FireBase play API");
                        if(globals.isLoggedIn==true){
                          //print(globals.lang);
                  
                          String api_url = globals.API_IP;
                          String url =  'https://'+api_url+'.ngrok.io/Play_Audio_Firebase';
                          //globals.justSayByText = true;
                          // if(globals.lang==''){
                          //   globals.lang = 'en';
                          // }
                          try{
                            final response = await  http.post(
                              Uri.parse(url),
                              headers: <String, String>{
                                'Content-Type': 'application/json; charset=UTF-8',
                              },
                              body: jsonEncode(<String, String>{
                                'user': globals.username,
                              }),
                            );
                            if (response.statusCode == 200) {
                              // If the server did return a 200 OK response,
                              // then parse the JSON.
                              //return Album.fromJson(jsonDecode(response.body));
                              var api_result = jsonDecode(response.body);
                              print("works");
                              return "work";
                              } 
                          }catch (error){
                            print("post error");
                          }
                          
                          
                          
                        }
                        //globals.isApiCon = false;
                        print('api not working');
                        return "api not working";
                        
                      }
          await fetchApi();  
    }

}