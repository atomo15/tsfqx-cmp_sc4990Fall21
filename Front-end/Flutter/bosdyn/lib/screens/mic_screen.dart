import 'dart:collection';
import 'dart:convert';

import 'package:bosdyn/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:highlight_text/highlight_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:bosdyn/screens/screens.dart';
import 'package:bosdyn/globals.dart' as globals;
import 'package:http/http.dart' as http;

class micScreen extends StatefulWidget {
  const micScreen({ Key? key }) : super(key: key);

  @override
  _micScreenState createState() => _micScreenState();
}

class _micScreenState extends State<micScreen> {
  
  final Map<String, HighlightedWord> _highlights = {
      'hello': HighlightedWord(
        onTap: () => print('hello'),
        textStyle: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
      'hey': HighlightedWord(
        onTap: () => print('voice'),
        textStyle: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      'spot': HighlightedWord(
        onTap: () => print('subscribe'),
        textStyle: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      'good': HighlightedWord(
        onTap: () => print('like'),
        textStyle: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
      'comment': HighlightedWord(
        onTap: () => print('comment'),
        textStyle: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    };
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;
  
  late FSBStatus status = FSBStatus.FSB_CLOSE;
  
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }
  
  @override
  Widget build(BuildContext context) {
    api();
    FSBStatus drawerStatus;
    double screenHeight = MediaQuery.of(context).size.height;
    return 
    SafeArea(
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
        SingleChildScrollView(
          reverse: true,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0,500),
            //child: Text(_text,style: TextStyle(color: Colors.blue),),
            child: TextHighlight(
              text: _text,
              words: LinkedHashMap.from(_highlights),
              textStyle: const TextStyle(
                fontSize: 32.0,
                color: Colors.blue,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        drawerBackgroundColor: Colors.black,)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 10000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: false,
        child: FloatingActionButton(
          onPressed: _listen,
          child: !_isListening?FaIcon(FontAwesomeIcons.microphoneAlt,color: Colors.black,):FaIcon(FontAwesomeIcons.solidPlayCircle,color: Colors.black,)
          //Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      )
    
    );
  }
void _listen() async {
    if (!_isListening) {
      
      bool available = await _speech.initialize(
        
        onStatus: (val) => {
          print('onStatus: $val'),
            if(val=='done'){
              print("post api"),
              print("Result : $_text"),
              //speak_api(_text.toString())
            }
          },
        onError: (val) => print('onError: $val'),
      );
      print(available);
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          listenFor: Duration(seconds: 120),
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print(_text);
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
       print("final post api");
       speak_api(_text.toString());
       //print(_text);
      _speech.stop();
    }
  }
  void speak_api(String contents) async{
              Future<String> fetchApi(String contents) async {
                        print("AM IN SPEECH API");
                        if(globals.isLoggedIn==true){
                          print(globals.lang);
                          // globals.isApiCon = false;
                          // globals.isCamCon = false;
                          // globals.isSpotCon = false;
                          // globals.Temp = "";
                          // globals.battery="";
                          String api_url = globals.API_IP;
                          String url =  'https://'+api_url+'.ngrok.io/speak';
                          globals.justSayByText = true;
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
                                'statement':contents,
                                'lang':'en'
                              }),
                            );
                            if (response.statusCode == 200) {
                              
        
                              var api_result = jsonDecode(response.body);
                              print(api_result);
                              globals.SayByTextResult = api_result['issue'];
                              globals.SayByTextContent = globals.statement;
                              globals.SayByTextStatus = api_result['result'];
                              print(globals.SayByTextContent);
                              // globals.battery = api_result['battery'].toString();
                              // globals.Temp =  api_result['temperature'].toString();
                              // globals.isSpotCon = api_result['spot'];
                              // globals.isCamCon = api_result['payload'];
                              globals.statement = "";
                              globals.isApiCon = true;
                              return "work";
                              } 
                          }catch (error){
                            print("post error");
                          }
                          
                          
                          
                        }
                        globals.isApiCon = false;
                        print('api not working');
                        return "api not working";
                        
                      }
          await fetchApi(contents);  
  }
}


