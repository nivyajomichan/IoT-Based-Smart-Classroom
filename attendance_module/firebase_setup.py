import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate("./iot-based-smart-classroom.json")
firebase_admin.initialize_app(cred)
