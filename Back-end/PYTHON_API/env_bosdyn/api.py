# Run Services Packages
from flask import Flask,jsonify,request
from flask_cors import CORS #Handle CORS on Web browser
# Run Services Packages

# Boston Dynamics Packages
import bosdyn.client
from bosdyn.client.spot_cam.audio import AudioClient
from bosdyn.client.spot_cam.ptz import PtzClient
from bosdyn.client import spot_cam
from bosdyn.api.spot_cam import ptz_pb2
from bosdyn.api.spot_cam import service_pb2_grpc
from bosdyn.api.spot_cam import audio_pb2
from bosdyn.api import data_chunk_pb2
from google.protobuf.wrappers_pb2 import FloatValue
from bosdyn.client.spot_cam.media_log import MediaLogClient
from bosdyn.api import image_pb2
from bosdyn.api.spot_cam import logging_pb2, camera_pb2
import asyncio
# Boston Dynamics Packages

# Sound Packages
from gtts import gTTS
from pydub import AudioSegment
import speech_recognition as sr
import wave
from playsound import playsound # For Debuging
# Sound Packages

# Firebase Packages
import pyrebase
# Firebase Packages

# Utility Packages
import os
import json
import urllib3
import inspect
from ping3 import ping, verbose_ping
# Utility Packages

#External Bosdyn Packages
from BD import Bosdyn
#External Bosdyn Packages

app = Flask(__name__)
CORS(app)
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

config = {
    "apiKey": "AIzaSyBSS5MdGRL9wdlRg2_f8Kw68v3z9QXPWMA",
    "authDomain": "bosdyn-abc38.firebaseapp.com",
    "projectId": "bosdyn-abc38",
    "storageBucket": "bosdyn-abc38.appspot.com",
    "messagingSenderId": "652003906486",
    "appId": "1:652003906486:web:041f5aa8ad0093075b2717",
    "measurementId": "G-9PXRR749Z8",
    "databaseURL":"https://bosdyn-abc38-default-rtdb.firebaseio.com"}

firebase = pyrebase.initialize_app(config)
storage = firebase.storage()

@app.route('/', methods=['GET'])
def test_api():
    status_spot = False
    print("Test API Called")
    if isSpotCon('192.168.80.3') == True:
        status_spot = True
    return {'Api_status':'works','spot_status':status_spot}

@app.route('/api', methods=['GET','POST'])
def main():
    username = "atom"
    password = "atom29589990"
    ip = "192.168.80.3"
    if request.method == 'POST':
        if request.get_json() != "":
            data = request.get_json()
            print("data => ",data)
            usernmae = data['user']
            password = data['password']
            ip = data['ip']
    # spot_status = False
    payload_status = False
    spot_status = isSpotCon(ip)
    if spot_status == True:
        spot = Bosdyn(username,password,'general')
        robot = spot.setup()
        if robot == "Failed authenticated":
            return {'battery':'-99','temperature':'-99','spot':False,'payload':False,'login_status':False}
        battery,temperature = spot.getBatteryTemPercent(robot)
        payload_check = Bosdyn(username,password,'payload')
        payload_status = payload_check.setup()
        #spot_status = True
    else:
        battery = int(99)
        temperature = int(37)
    #print(battery,temperature)
    return {'battery':battery,'temperature':temperature,'spot':spot_status,'payload':payload_status,'login_status':True}

@app.route('/authen', methods=['GET','POST'])
def authen():
    username = "atom"
    password = "atom29589990"
    ip = "192.168.80.3"
    demo = True
    if request.method == 'POST':
        if request.get_json() != "":
            data = request.get_json()
            print("data => ",data)
            usernmae = data['user']
            password = data['password']
            ip = data['ip']
            spot_status = isSpotCon(ip)
            if spot_status == True or demo == True:
                spot = Bosdyn(username,password,'general')
                robot = spot.setup()
                if robot == "Failed authenticated":
                    if demo == True:
                        return {'login_status':True,'issue':'Ready in Demo'} 
                    return {'login_status':False,'issue':'Username or Password incorrect for this spot'}
                else:
                    return {'login_status':True,'issue':'Ready'} 
            else:
                print("Cannot authenticate")
                return {'login_status':False,'issue':'Cannot connect to the spot'}
        else:
            return {'login_status':False,'issue':'No data in json provided'}
    else:
        return {'login_status':False,'issue':'No data from POST method provided'}
    
@app.route('/speak', methods=['POST'])
def speak():
    demo = True
    if request.method == 'POST':
        if request.get_json() != "":
            data = request.get_json()
            #print(data['statement'])
            print(data)
            #print(data['transcript'])
            statement = data['statement']
            lang = 'en'
            if data['lang'] != None:
                lang = data['lang']
                
            if data['ai'] != None:
                if data['ai'] == 'true':
                    print('Respond ',data['statement'])
                    str_statement = str(data['statement'])
                    start_command = ['spot']
                    sub_statement = str_statement.split(' ')
                    if start_command[0] == sub_statement[0]:
                        print(str_statement[4:],' process responding')
                        print(str_statement[4:])
                        res = gen_conversion(str_statement[4:])
                        if res != '':
                            statement = res
                        else:
                            statement = 'respond'
                    else:
                        print("Normal speak")
                else:
                    print("Normal speak")
                
            if generateAiSound(statement,"",lang) == True:
                if isSpotCon(data['ip']) == True:
                    spot = Bosdyn(data['user'],data['password'],'audio')
                    robot = spot.setup()
                    print("before load")
                    if load_sound(robot,"spot_real_time.wav") == True:
                        print("After load")
                        list_sound = robot.list_sounds()
                        print('test => ',list_sound)
                        sound = audio_pb2.Sound(name="spot_real_time")
                        robot.play_sound(sound,None)
                        return {'result':True,'content':data['statement'],'issue':'Works'}
                    elif demo == True:
                        return {'result':True,'content':data['statement'],'issue':'Works in Demo Mode'}
                    else:
                        print("Falied load sound")
                        return {'result':False,'content':data['statement'],'issue':'Load Sound Problem'}
                else:
                    print("Spot not connected")
                    return {'result':False,'content':data['statement'],'issue':'Spot not connected, Generate Sound Works'}
            return {'result':False,'content':data['statement'],'issue':'Generate Sound Issues'}
    return 'Not OK'

def getStatusSpot():
    username = "atom"
    password = "atom29589990"
    ip = "192.168.80.3"
    spot_status = isSpotCon(ip)
    demo = True
    if spot_status == True:
        spot = Bosdyn(username,password,'general')
        robot = spot.setup()
        battery,temperature = spot.getBatteryTemPercent(robot)
        if robot == "Failed authenticated":
            return {'login_status':False,'issue':'Username or Password incorrect for this spot'}
        else:
            return {'battery':battery,'temperature':temperature}
    elif demo == True:
        demobattery = "90"
        demotemp = "37"
        return {'battery':demobattery,'temperature':demotemp}
    else:
        print("Cannot authenticate")
        return {'login_status':False,'issue':'Cannot connect to the spot'}
    
def gen_conversion(og_statement):
    print('gen_conver : ',og_statement)
    if og_statement == " battery":
        result = getStatusSpot()
        print("result => ",result)
        res_statement = "The battery is "+str(result['battery'])+" percent"
        res_statement = res_statement + "The temperature is "+str(result['temperature'])+" degree"
        return res_statement;
    return ""

def isSpotCon(ip_address):
    ping_result = ping(ip_address)
    #print(ping_result)
    if ping_result == None:
        print("\n\nUnsuccessful - Unreachable to Spot\n\n")
        return False
    else:
        print("\n\nSuccessful - Reachable to Spot\n\n")
        return True
    

def load_sound(robot,filename):
    name_val = filename.split(".")
    print("load sound ",filename)
    try:
        sound = audio_pb2.Sound(name=name_val[0])
    except:
        print("Error => sound = audio_pb2.Sound(name=options.name)")
        return False
    path = ""
    full_path = path + filename;
    
    print("read file")
    
    with open(full_path, 'rb') as fh:
        print("read")
        data = fh.read()
    
    if data is None:
        print("error data")
    else:
        print("read file end")
        
    try:
        robot.load_sound(sound, data)
    except:
        print("Load falied")
        return False
    print("Load successfully")
    return True

def generateAiSound(content,filename,lang):
    if content != "":
        if filename == "":
            filename = "spot_real_time"
        
        print("Debug generating sound",content,filename,lang)
        
        text = content
        if len(lang)>0:
            language = lang
        else:
            language = 'en'
            
        try:
            speech = gTTS(text = text, lang = language,tld='com',slow = False)
            save_mp3 = filename+'.mp3'
            speech.save(save_mp3)
            sound = AudioSegment.from_mp3(filename+".mp3")
            sound.export(filename+".wav", format="wav")
            
            location = os.getcwd()
            path_mp3 = os.path.join(location,filename+".mp3")
            path_wav = os.path.join(location,filename+".wav")
            #print(path_mp3)
            playsound(filename+'.wav')
            os.remove(path_mp3)
            #os.remove(path_wav)
            print("\t==> export .wav & remove ",filename,".mp3 successfully")
        except:
            print("gTTs has problem")
            return False
        return True
    
@app.route('/text2file', methods=['GET','POST'])
def text2file():
    if request.method == 'POST':
        if request.get_json() != "":
            data = request.get_json()
            username = data['user']
            filename = data['filename']
            content = data['contents']
            #print("debug",data)
            if data['lang'] == None:
                lang = 'en'
            else:
                lang = data['lang']
            
            auth = firebase.auth()
            email = 'atom9583@gmail.com'
            password = '654321'
            user = auth.sign_in_with_email_and_password(email,password)
            filename_list,lang_list,contents_list,link_list = getContentsFromDB(username)
            
            if len(filename_list)>0:
                for x in filename_list:
                    if (filename+'.wav') == x:
                        filename = filename+'_1'
                        break;
            file_path = filename+'.wav'
            
            if generateAiSound(content,filename,lang) == True:
                global storage
                #storage.child('atom/'+filename+'.wav').put(file_path)
                storage.child(username+'/'+filename+'.wav').put(file_path)
                #url = storage.child('atom/'+filename+'.wav').get_url(user['idToken'])
                url = storage.child(username+'/'+filename+'.wav').get_url(user['idToken'])
                #print(url)
                full_filename = filename +'.wav'
                db = firebase.database()
                if lang == None:
                    lang = 'en'
                print("Upload ")
                db.child("audio_spot_"+username).push({'Filename':full_filename,'Links':url,'Contents':content,'lang':lang})
                #storage.child(filename+'.wav').download(filename=(filename+'.wav'))
                getContentsFromDB(username)
                print("success")
            print('content: ',data['filename'],data['contents'])
            return {"filename":'hello',"contents":'test'}
        else:
            print("no data")
            return {'mission':'failed'}

def getContentsFromDB(username):
    filename = []
    lang = []
    contents = []
    link = []
    try:
        db = firebase.database()
    except:
        print("No database")
        return filename,lang,contents,link
        
    try:
        a = db.child("audio_spot_"+username).get()
    except:
        print("No data of ",username)
        return filename,lang,contents,link
    
   
    if a.each() != None:
        vals = []
        audio_list = []
        temp = []
            
        for tk in a.each():
            #print(tk.val().values())
            val = tk.val()
            vals.append(val)
        #print("check vals ",vals)
            
        if len(vals)>1:
            for x in vals:
                #print(x['id'])
                filename.append(x['Filename'])
                lang.append(x['lang'])
                contents.append(x['Contents'])
                link.append(x['Links'])
                audio_list.append(temp)
                temp = []
        elif len(vals)==1:
            # print(vals[0]['Filename'])
            filename.append(vals[0]['Filename'])
            lang.append(vals[0]['lang'])
            contents.append(vals[0]['Contents'])
            link.append(vals[0]['Links'])
            audio_list.append(temp)
            temp = []
        #print(filename)
        return filename,lang,contents,link
    else:
        print("No data")

    # for y in audio_list:
    #     print(y[0])
    return filename,lang,contents,link


@app.route('/Audio_Firebase', methods=['GET','POST'])
def Audio_Firebase():
    if request.method == 'POST':
        data = request.get_json()
        username = data['user']
        filename,lang,contents,link = getContentsFromDB(username)
        if filename == None or lang == None or contents == None or link == None:
            return {'filename':filename,'lang':lang,'contents':contents,'link':link}
        else:
            return {'filename':filename,'lang':lang,'contents':contents,'link':link}

@app.route('/Play_Audio_Firebase', methods=['GET','POST'])
def play_sound_firebase():
    filename = ""
    if request.method == 'POST':
        if request.get_json() != "":
            data = request.get_json()
            #print(data)
            #return {"result":"successfull"}
            filename = str(data['user'])+'/'+str(data['filename'])
            print("check ",filename)
            #link ="https://firebasestorage.googleapis.com/v0/b/bosdyn-abc38.appspot.com/o/gn-ko.wav?alt=media&token=e042ad71-bbc1-40bc-b11e-00f818533948"
            storage.child(filename).download('download.wav')
            if isSpotCon(data['ip']) == True:
                spot = Bosdyn(data['user'],data['password'],'audio')
                robot = spot.setup()
                print("before load")
                if load_sound(robot,"download.wav") == True:
                    print("After load")
                    list_sound = robot.list_sounds()
                    print('test => ',list_sound)
                    sound = audio_pb2.Sound(name="download")
                    robot.play_sound(sound,None)
            else:
                playsound('download.wav')
            os.remove('download.wav')
            return {"result":"successfull"}
    return {'mission':'failed'}

@app.route('/Del_Audio_Firebase', methods=['GET','POST'])
def del_sound_firebase():
    filename = ""
    global storage
    if request.method == 'POST':
        if request.get_json() != "":
            data = request.get_json()
            auth = firebase.auth()
            email = 'atom9583@gmail.com'
            password = '654321'
            filename = 'gn-ko.wav'
            user = auth.sign_in_with_email_and_password(email,password)
            #link = 'https://firebasestorage.googleapis.com/v0/b/bosdyn-abc38.appspot.com/o/gn-ko.wav?alt=media&token=e042ad71-bbc1-40bc-b11e-00f818533948'
            # r = storage.getInstance().getFromurl(link)
            
            delContentsFromDB(data['user'],data['filename'],data['contents'])
            #print(inspect.getmembers(storage))
            #a = storage.bucket()
            
            
            #client = storage.Client(credentials=cred, project=storage.storage_bucket)
            #storage.bucket = client.get_bucket(storage_bucket)
            #storage.delete(filename)
                           
    return {'dsadhasdkj':'dashjkmdasbnkdbnkm,'}

def delContentsFromDB(user,filename,contents):
    db = firebase.database()
    path = "_"+user
    try:
        a = db.child("audio_spot"+path).get()
    except:
        print("a failed")
        return False
    if a:
        vals = []
        audio_list = []
        temp = []
        
        for tk in a.each():
            #print(tk.val().values())
            val = tk.val()
            if filename == val['Filename'] and contents == val['Contents']:
                print(tk.key())
                print(val['Filename'],val['Contents'])
                db.child("audio_spot"+path).child(tk.key()).remove()
                break;
        #print("check vals ",vals)
        #print(filename)
    return True

if __name__ == '__main__':
    #generateAiSound('test','test','en')
    #isSpotCon('192.168.80.3')
    app.run(debug=True)
