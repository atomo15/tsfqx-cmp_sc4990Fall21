import bosdyn
import bosdyn.client
import json

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

class Bosdyn:
    def __init__(self,username,password,mode):
        self.username = username
        self.password = password
        self.mode = mode
    def setup(self):
        
        try:
            sdk = bosdyn.client.create_standard_sdk('Mizzou-spot')
            if self.mode == "ptz" or self.mode == "audio":
                print("Register spot service")
                try:
                    spot_cam.register_all_service_clients(sdk)
                except:
                    print("Failed Register PTZ package") 
                    return ""
        except:
            print("Failed Create SDK")
            return ""
        
        if self.mode == "payload":
            try:
                spot_cam.register_all_service_clients(sdk)
            except:
                print("Failed Register PTZ package") 
                return False
            return True
        
        try:
            robot = sdk.create_robot('192.168.80.3')
        except:
            print("Failed Create Robot Please check your connection")
            return ""
        
        try:
            robot.authenticate(self.username,self.password)
        except:
            print("Failed authenticated")
            return "Failed authenticated"
        
        # try:
        #     audio_client = robot.ensure_client(AudioClient.default_service_name)
        # except:
        #     print("Failed Register AudioClient")
        
        if self.mode == "general":
            try:
                state_client = robot.ensure_client('robot-state')
            except:
                print("Failed Get state client")
                return ""
            try:
                state_bot = state_client.get_robot_state()
            except:
                print("Failed Get state robot")
                return ""
            return state_bot
        elif self.mode == "ptz" or self.mode == "audio":
            if self.mode == "audio":
                audio_client = ""
                try:
                    audio_client = robot.ensure_client(AudioClient.default_service_name)
                except:
                    print("Failed Register AudioClient")
                    return ""
                return audio_client
            elif self.mode == "ptz":
                try:
                    ptz_client = robot.ensure_client(PtzClient.default_service_name)
                except:
                    print("Failed Register Ptz client")
                    return ""
                return ptz_client
                
        print("Connect successfully")
        return state_bot
    
    def getBatteryTemPercent(self,status):
        percent_bat = int(-99)
        temp_bat = int(-99)
        a = str(status)
        if len(a) < 2:
            return percent_bat,temp_bat
        o = a.find("charge_percentage")
        o = o + 30
        bat_result = a[o+1:o+5]
        if bat_result != "":
            bat = float(a[o+1:o+5])
            percent_bat = int(bat)
        p = a.find("temperatures: ")
        p = p +14
        #print("Index ",p)
        #print(a[p:p+2])
        temp_bat = int(a[p:p+2])
        #print(temp_bat,percent_bat)
        return percent_bat,temp_bat
    
    def getPTZ():
        pass
    
    
        