import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../colors.dart';
import '../../../home.dart';
import '../../Auth/Components/button.dart';
import 'package:project_waves/src/Models/Event.dart';

import '../../Auth/Components/my_textfield.dart';
import '../../Auth/Utils/database.dart';

class EventForm extends StatefulWidget {
  const EventForm({Key? key}) : super(key: key);

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  final priceController = TextEditingController();
  PickedFile? imageFile;
  final eventCategoryController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate;
    TimeOfDay? pickedTime;

    if (Platform.isIOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 300,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.dateAndTime,
              onDateTimeChanged: (DateTime? dateTime) {
                pickedDate = dateTime;
              },
            ),
          );
        },
      );
      if (pickedDate != null) {
        await showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (DateTime? dateTime) {
                  pickedTime = TimeOfDay.fromDateTime(dateTime!);
                },
              ),
            );
          },
        );
      }
    } else {
      pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null) {
        pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
      }
    }

    if (pickedDate != null && pickedTime != null) {
      setState(() {
        if (isStartDate) {
          startDate = DateTime(
            pickedDate!.year,
            pickedDate!.month,
            pickedDate!.day,
            pickedTime!.hour,
            pickedTime!.minute,
          );
        } else {
          endDate = DateTime(
            pickedDate!.year,
            pickedDate!.month,
            pickedDate!.day,
            pickedTime!.hour,
            pickedTime!.minute,
          );
        }
      });
    }
  }
  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = pickedFile;
    });
  }

  Future<String> _uploadImage() async {
    if (imageFile == null) return '';

    final FirebaseStorage _storage = FirebaseStorage.instance;
    Reference storageReference =
    _storage.ref().child('events/${DateTime.now().millisecondsSinceEpoch}.jpg');

    UploadTask uploadTask = storageReference.putFile(File(imageFile!.path));

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    return await taskSnapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.purple), //
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTextField(
                      controller: titleController,
                      hinText: 'Title',
                      obscureText: false,
                      maxLines: 1,
                      keyboard: TextInputType.text,
                    ),
                    SizedBox(height: 16.0),
                    MyTextField(
                      controller: priceController,
                      hinText: 'Price',
                      obscureText: false,
                      maxLines: 1,
                      keyboard: TextInputType.number,
                    ),
                    SizedBox(height: 16.0),
                    MyTextField(
                      controller: descriptionController,
                      hinText: 'Description',
                      obscureText: false,
                      maxLines: 3,
                      keyboard: TextInputType.text,
                    ),
                    SizedBox(height: 16.0),
                    MyTextField(
                      controller: eventCategoryController,
                      hinText: 'Category',
                      obscureText: false,
                      maxLines: 1,
                      keyboard: TextInputType.text,
                    ),
                    SizedBox(height: 22.0),
                    GestureDetector(
                      onTap: () {
                        _selectDateTime(context, true);
                      },
                      child: SizedBox(
                        width: 280 ,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Start Date and Time',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            startDate != null
                                ? DateFormat('yyyy-MM-dd HH:mm').format(startDate!)
                                : 'Select start date and time',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        _selectDateTime(context, false);
                      },
                      child: SizedBox(
                        width: 280,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'End Date and Time',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            endDate != null
                                ? DateFormat('yyyy-MM-dd HH:mm').format(endDate!)
                                : 'Select end date and time',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // Adjust the radius as desired
                        ),
                        backgroundColor: AppColors.purple,
                      ),
                      onPressed: _getImage,
                      child: imageFile != null
                          ? null
                          : Container(
                        width: 60,
                        height: 60,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),


                    SizedBox(height: 16.0),
                    imageFile != null
                        ? Image.file(File(imageFile!.path))
                        : Container(),
                    SizedBox(height: 16.0),
                    MyButton(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          if (endDate != null && endDate!.isBefore(startDate!)) {
                            Fluttertoast.showToast(
                              msg: "End date cannot be before start date",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            String imageUrl = await _uploadImage();
                            if (imageUrl.isNotEmpty) {
                              Event event = Event(
                                title: titleController.text,
                                description: descriptionController.text,
                                eventCategory: eventCategoryController.text,
                                startDate: startDate!,
                                endDate: endDate!,
                                price: priceController.text,
                                isParticipate: false,
                                uid: DatabaseAuthMethods().getCurrentUserId(),
                                image: imageUrl,
                              );
                              DocumentReference docRef = await FirebaseFirestore.instance
                                  .collection('events')
                                  .add(event.toJson());
                              print('Event ID: ${docRef.id}');
                            }
                          }
                        }
                        (bottomBarKey.currentWidget as BottomNavigationBar).onTap!(0);

                      },
                      text: 'Share',
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
