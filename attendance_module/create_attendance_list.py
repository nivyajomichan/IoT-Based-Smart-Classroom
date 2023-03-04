import json

import firebase_setup as firebase

db = firebase.firestore.client()

attendance_list = dict()

student_reference = db.collection("users").where("department", "==", u"Computer Engineering").stream()
for student in student_reference:
	current_student = student.to_dict()
	attendance_list[str(current_student["fingerprint_index"])] = { "id":current_student["id"], "present": False }

with open("attendance_list.json", 'w') as attendance_list_file:
	json.dump(attendance_list, attendance_list_file)
