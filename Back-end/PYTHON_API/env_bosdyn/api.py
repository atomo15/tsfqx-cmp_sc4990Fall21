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
# Utility Packages


urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

app = Flask(__name__)
CORS(app)

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
    return {'status':'works'}


if __name__ == '__main__':
    app.run(debug=True)
