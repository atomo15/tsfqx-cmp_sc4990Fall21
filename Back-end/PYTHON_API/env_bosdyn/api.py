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
    if request.method == 'POST':
        if request.get_json() != "":
            data = request.get_json()
            print(data['statement'])
            #print(data['transcript'])
            lang = 'en'
            if data['lang'] != None:
                lang = data['lang']

            if generateAiSound(data['statement'],"",lang):
                if isSpotCon():
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
                    else:
                        print("Falied load sound")
                        return {'result':False,'content':data['statement'],'issue':'Load Sound Problem'}
                else:
                    print("Spot not connected")
                    return {'result':False,'content':data['statement'],'issue':'Spot not connected, Generate Sound Works'}
            return {'result':False,'content':data['statement'],'issue':'Generate Sound Issues'}
    return 'Not OK'

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
        
        text = content
        if lang != "":
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
            #print(path_mp3)
            playsound(filename+'.wav')
            os.remove(path_mp3)
            print("\t==> export .wav & remove ",filename,".mp3 successfully")
        except:
            print("gTTs has problem")
            return False

if __name__ == '__main__':
    #generateAiSound('test','test','en')
    #isSpotCon('192.168.80.3')
    app.run(debug=True)
