from flask import Flask

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

firebase_admin.initialize_app(credentials.Certificate("./iot-based-smart-classroom.json"))

db = firestore.client()

app = Flask(__name__)

@app.route('/<string:lecture_hall>')
def get_lecture_status(lecture_hall):
    return str(db.collection("classrooms").document(lecture_hall).get().to_dict()["lecture_status"])

if __name__ == "__main__":
    app.run(host = "0.0.0.0")
