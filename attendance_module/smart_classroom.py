import time
import json

import firebase_setup as firebase
db = firebase.firestore.client()
stream = "Computer Engineering"
batch = "BE"
batch_reference = db.collection("departments").document(stream)

import fingerprint_setup as fingerprint

ongoing = False

def report():

	global attendance_list
	report = dict()
	for student in attendance_list:
		report[attendance_list[student]["id"]] = attendance_list[student]["present"]
	db.collection("lectures").document("somelectureid2").set({ "attendance": report })

def end_class():
	global ongoing
	report()
	ongoing = False

def start_attendance(subject):

	global attendance_list

	with open("attendance_list.json") as attendance_list_file:
		attendance_list = json.load(attendance_list_file)

	start_time = time.time()
	while(time.time() - start_time < 15):
		print("Attendance Ongoing for {}!".format(subject))
		while not fingerprint.sensor.readImage():
			if time.time() - start_time > 15:
				break
		try:
			fingerprint.sensor.convertImage(0x01)
			result = fingerprint.sensor.searchTemplate()
			index, accuracy = result[0], result[1]
			if index == -1 or accuracy < 50:
				print("Try Again!")
				continue
			else:
				required_student = None
				if attendance_list[str(index)]["present"]:
					print("Already marked")
				else:
					attendance_list[str(index)]["present"] = True
					student_reference = db.collection("users").where("fingerprint_index", "==", index).stream()
					for student in student_reference:
						required_student = student.id
					db.collection("users").document(required_student).update( {"attendance" : {subject : firebase.firestore.Increment(1)} } )
		except e:
			pass

if __name__ == "__main__":
	while True:
		lecture_status = batch_reference.get().to_dict()
		lecture = lecture_status[batch]["lecture_status"]
		if lecture and not ongoing:
			print("Lecture Started!")
			ongoing = True
			start_attendance(lecture_status[batch]["subject"])
		elif not lecture and ongoing:
			print("Lecture Ended")
			ongoing = False
			end_class()
		else:
			print("Hall Idle!")
		time.sleep(2)