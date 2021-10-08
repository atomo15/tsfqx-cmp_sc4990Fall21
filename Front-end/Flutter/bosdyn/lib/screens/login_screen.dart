import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:bosdyn/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:bosdyn/globals.dart' as globals;
import 'package:bosdyn/screens/screens.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:swipedetector/swipedetector.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({ Key? key }) : super(key: key);

  @override
  _Login_ScreenState createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FSBStatus status = FSBStatus.FSB_CLOSE;
  
  @override
  Widget build(BuildContext context) {
    api();
    FSBStatus drawerStatus;
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black,
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
            _buidTitle(screenHeight),
            _buildForm(screenHeight),
          ]
        ),
        drawerBackgroundColor: Colors.black,)
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: (){
        setState(() {
          status = status == FSBStatus.FSB_OPEN?FSBStatus.FSB_CLOSE:FSBStatus.FSB_OPEN;
        });
      },child: FaIcon(FontAwesomeIcons.bars,color: Colors.black,),),
      )
    )
    ;
  }
  SliverToBoxAdapter _buidTitle(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        child: Center(
          child: 
          Column(
            children: [
              SizedBox(height: 20,),
              Text(globals.isLoggedIn?"ACCOUNT":
                  "LOGIN",
                  style: 
                  TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    ),
                  ),
              SizedBox(height: 20,),
            ],
          )
          
         
          )
      )
    );
  }
  SliverToBoxAdapter _buildForm(double screenHeight) {
    var username = "";
    var passwords = "";
    var ip="";
    var api_ip = "";
    return SliverToBoxAdapter(
      child: Container(
        child: Center(
          child: 
          globals.isLoggedIn?
          // Text('Usename : '+globals.username
          // +'\n'+'IP Address : '+globals.IP
          // +'\n'+'API IP Address : '+globals.API_IP,
          // style: TextStyle(
          //   fontSize: 20),)
          Column(
            children: [
              
              FaIcon(FontAwesomeIcons.userAlt,color: Colors.blue),
              SizedBox(height: screenHeight*0.01,),
              Container(
                //width: MediaQuery.of(context).size.width*0.5,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5)
                    )
                  ),
                child: Text(
                      ' '+globals.username+' ',
                      style: 
                      TextStyle(
                        //backgroundColor: Colors.green,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      ),
              ),
              
              SizedBox(height: screenHeight*0.01,),

              FaIcon(FontAwesomeIcons.robot,color: Colors.blue),
              SizedBox(height: screenHeight*0.01,),
              Container(
                //width: MediaQuery.of(context).size.width*0.5,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5)
                    )
                  ),
                child: Text(
                        ' '+globals.IP+' ',
                        style: 
                        TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
              ),
              
              SizedBox(height: screenHeight*0.01,),
              FaIcon(FontAwesomeIcons.server,color: Colors.blue),
              SizedBox(height: screenHeight*0.01,),
              Container(
                //width: MediaQuery.of(context).size.width*0.5,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5)
                    )
                  ),
                child: Text(
                        ' '+globals.API_IP+' ',
                        style: 
                        TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )
              ),
              
              
            ],
          )
          :Form(
            key: _formKey,
            child: Column(
            children: [
              SizedBox(height: 20,),
              FaIcon(FontAwesomeIcons.robot,size: screenHeight*0.1,color: Colors.blue,),
              SizedBox(height: 20,),
              Container(
                width: 300,
                child: 
                TextFormField(
                scrollPadding: const EdgeInsets.all(20.0),
                style: TextStyle(
                  color: Colors.blue,
                  ),
                decoration: const InputDecoration(
                  //icon: Icon(Icons.person),
                  hintText: 'username',
                  labelText: 'username *',
                  labelStyle: TextStyle(
                    color: Colors.blue,
                    decorationColor: Colors.blue
                  ),
                  hintStyle: TextStyle(
                    color: Colors.blue
                  ),
                  // fillColor: Colors.blue,
                  // filled: true
                  //contentPadding: EdgeInsets.all(10)
                ),
                onSaved: (String? value) {
                  username = value!;
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                  //return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                },
              ),
              ),
              SizedBox(height: 20,),
              
              Container(
                width: 300,
                child: TextFormField(
                scrollPadding: const EdgeInsets.all(20.0),
                style: TextStyle(
                  color: Colors.blue,
                  ),
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'password',
                  labelText: 'password *',
                  labelStyle: TextStyle(
                    color: Colors.blue
                  ),
                  hintStyle: TextStyle(
                    color: Colors.blue
                  ),
                  // suffixIcon: Padding(
                  //   padding: const EdgeInsetsDirectional.only(top: 20.0,start:10),
                  //   child: FaIcon(FontAwesomeIcons.eye),),
                ),
                onSaved: (String? value) {
                  //print('Submit ${value}');
                  passwords = value!;
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                  
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                  //return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                },
              ),
              ),
              SizedBox(height: 20,),
              Container(
                width: 300,
                child: TextFormField(
                scrollPadding: const EdgeInsets.all(20.0),
                style: TextStyle(
                  color: Colors.blue,
                  ),
                decoration: const InputDecoration(
                  //icon: Icon(Icons.person),
                  hintText: '192.168.80.3',
                  labelText: 'IP Address *',
                  labelStyle: TextStyle(
                    color: Colors.blue
                  ),
                  hintStyle: TextStyle(
                    color: Colors.blue
                  ),
                  //contentPadding: EdgeInsets.all(10)
                ),
                onSaved: (String? value) {
                  if(value=='default'){
                    ip = '192.168.80.3';
                  }
                  else{
                    ip = value!; 
                  }
                },
                validator: (String? value) {
                  if(value == null || value.isEmpty){
                    return 'Please enter some text';                    
                  }
                  else{
                    if(value=='default'){
                      ip = "192.168.80.3";
                    }else{
                      var dot = 0;
                      for(var i =0;i<value.length;i++){
                        if(value[i]=='.'){
                          if(dot<3){
                            dot++;
                          }
                          return '. cannot have more than 3';
                        }
                      }
                    }
                  }
                  return null;
                },
              ),
              ),
              SizedBox(height: 20,),
              Container(
                width: 300,
                child: TextFormField(
                scrollPadding: const EdgeInsets.all(20.0),
                style: TextStyle(
                  color: Colors.blue,
                  ),
                decoration: const InputDecoration(
                  //icon: Icon(Icons.person),
                  hintText: '192.168.80.3',
                  labelText: 'API KEYS *',
                  labelStyle: TextStyle(
                    color: Colors.blue
                  ),
                  hintStyle: TextStyle(
                    color: Colors.blue
                  ),
                  //contentPadding: EdgeInsets.all(10)
                ),
                onSaved: (String? value) {
                  api_ip = value!;
                },
                validator: (String? value) {
                  if(value == null || value.isEmpty){
                    return 'Please enter some text';                    
                  }
                  return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                },
              ),
              ),
              SizedBox(height: 20,),
              Text.rich(
                TextSpan(
                  text: globals.loginissue!=''?globals.loginissue:'',
                  style: TextStyle(
                    color: Colors.red,
                  )
                  )
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState!.validate()) {
                       _formKey.currentState?.save();
                       //print(globals.isLoggedIn);
                       //globals.isLoggedIn = true;
                       globals.username = username;
                       globals.password = passwords;
                       globals.IP = ip;
                       globals.API_IP = api_ip;
                       globals.statement = "";
                       check_user_authen();
                       print('check ip');
                       print(globals.IP);
                         Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BottomNavScreen(pages_index: 4,)),
                          );
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
              
            ],
          )
            
          ),
          
          )
      )
    );
  }
   void check_user_authen() async{
              Future<String> fetchApi() async {
                        print("AM IN AUTHEN USER");
                        if(globals.isLoggedIn!=true){
                          print(globals.lang);
                          // globals.isApiCon = false;
                          // globals.isCamCon = false;
                          // globals.isSpotCon = false;
                          String api_url = globals.API_IP;
                          String url =  'https://'+api_url+'.ngrok.io/authen';
    
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
                              }),
                            );
                            if (response.statusCode == 200) {
                              
        
                              var api_result = jsonDecode(response.body);
                              print(api_result);
                              var issue = api_result['issue'];
                              var login_check = api_result['login_status'];
                              //print("\n\n"+login_check.toString());
                              
                              //globals.isLoggedIn = api_result['login_status'];
                              // print(globals.SayByTextContent);
                              // globals.battery = api_result['battery'].toString();
                              // globals.Temp =  api_result['temperature'].toString();
                              // globals.isSpotCon = api_result['spot'];
                              // globals.isCamCon = api_result['payload'];
                              globals.statement = "";
                              globals.isApiCon = true;
                              if(login_check.toString()=='true'){
                                print("Pass");
                                globals.isLoggedIn = true;
                                globals.isSpotCon = true;
                                globals.loginissue = '';
                              }else{
                                globals.loginissue = issue.toString();
                              }
                              
                              return "API work";
                              } 
                          }catch (error){
                            print("post error"+error.toString());
                          }
                          
                          
                          
                        }
                        globals.isApiCon = false;
                        print('api not working');
                        return "api not working";
                        
                      }
          await fetchApi();  
  }
}
