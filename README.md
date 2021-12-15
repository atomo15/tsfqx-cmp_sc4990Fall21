# CMP_SC 4990 | Fall 2021 | University of Missouri
# ( Undergraduate Research in Computer Science ) 
## Research Topics : The Spot from Boston Dynamics 
## Instructor : Dr. Dale Musser
## Thunnathorne Synhiranakkrakul ( TSFQX ) [14351543]


## Motivations :
- After I know how to operate and access to control the Spot CAM (PTZ), I'm looking for a more beautiful User Interface and more powerful functionality. I desired to research the speaker on the Spot CAM for using the speaker in terms of factory field to notify or respond to the user, in case of emergency such as the unusual circumstance like the spot detected the gas leak or respond the voice command from the apps such as the battery status or conversation with the user like Siri, Alexa or Google Assistant to earn better experience more than using controller by using voice command from the apps to control the Spot, more mobility and easy to command.

## Objectives :
- Learn how to operate speaker on Spot CAM (PTZ).
- Learn how to generate the custom audio file which the Spot CAM speaker supported.
- Learn how to load the custom audio file into the speaker.
- Learn how to integrate the Python API with the Flutter UI.
- Learn how to integrate the Python API with Firebase to store the audio files and the information of the audio files.

## Overview Diagrams :
![overview-program](https://user-images.githubusercontent.com/49804761/136140542-8858dda1-95af-4993-92bd-c0e20c9d3d43.png)

## Implementations :

### [***Front-End***](/Front-end/) :
- [***Flutter***](/Front-end/Flutter/)

### [***Back-End***](/Back-end/) :
- [***Python***](https://github.com/atomo15/tsfqx-cmp_sc4990Fall21/tree/master/Back-end/PYTHON_API)


## Experimental Results :
### Demo Video :
- [***Let the Spot speak (Prototype Video)***](https://www.linkedin.com/posts/thunnathorne-synhiranakkrakul_let-the-spot-speak-whatever-you-want-this-ugcPost-6841222080848048128-tjl1)
- [***Save Audio File on Firebase for Spot cam demo***](https://www.youtube.com/watch?v=neZFiuHMxTk)

### .IPA For iOS :
- Need Developer AppleID to export, but from this project can build for .ipa
### .APK For Android :
- ```
  flutter build apk
  ```
### URL For Web Apps :
- [***TSFQX-BOSDYN***](https://mu-bosdyn.netlify.app/#/)

## Conclusions :
- This project is integrated between the spot which uses python SDK and Flutter which is a cross-platform development tool that can export front-end as web apps, .apk for android, .ipa for ios with the same set of code. in order to connect with each other, this project pushes the building project up to the netlify cloud service as a host, connecting to the back-end with the Ngrok service to forward port from the intranet to internet with LAN cable and run python API as the background which connected to spot wifi. the first feature is typing statements as text and choosing languages, then API generates voice, and the speaker in PTZ Cam will speak in real-time. the second feature is typing the name of the file, contents, and choosing languages, then API generates a .wav file, uploads data to firebase (Storage), and content save in firebase (Real-time Database). the third feature is speech to speak, which let the user speak and the spot will say the same things in real-time, in addition, if the user begins with 'spot' followed by 'battery', the spot will respond and give a detail of battery percent as a sound respond. the last feature is fetching data from firebase, displaying all of the files and contents to the user, letting the user can demo the sound on their device, playing sound on spot in real-time, deleting files from firebase which all of these can do with the application. finally, this project is a prototype from the research class to control spots from any device which uses cross-platform development tools and combines them with the cloud host and storage.
