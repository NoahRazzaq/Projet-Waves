  import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
    String eventId;
    String title;
    String description;
    String eventCategory;
    DateTime startDate;
    DateTime endDate;
    String price;
    bool isParticipate;
    String uid;
    String image;
    Event({
      this.eventId = "",
      required this.title,
      required this.description,
      required this.eventCategory,
      required this.startDate,
      required this.endDate,
      required this.price,
      required this.isParticipate,
      required this.uid,
      required this.image,
    });

    Map<String, dynamic> toJson() => {
      "title": title,
      "description": description,
      "eventCategory": eventCategory,
      "startDate": startDate,
      "endDate": endDate,
      "price": price,
      "participate": isParticipate,
      "uid": uid,
      "image": image
    };


    Event.fromJson(Map<String, dynamic> json) :
      eventId = json["eventID"] ?? "",
      title = json['title'],
      description = json['description'],
      eventCategory = json ['eventCategory'],
      startDate = (json['startDate'] as Timestamp).toDate(),
      endDate = (json['endDate'] as Timestamp).toDate(),
      price = json['price'],
      isParticipate = json['participate'],
      uid = json['uid'],
      image = json['image'];

    String getStartDate() {
      return formatDate(startDate);
    }

    String getEndDate() {
      return formatDate(endDate);
    }

    String getStartTime() {
      return formatTime(startDate);
    }

    String getEndTime() {
      return formatTime(endDate);
    }

    String formatDate(DateTime date) {
      String day = date.day.toString().padLeft(2, '0');
      String month = date.month.toString().padLeft(2, '0');
      String year = date.year.toString().substring(2); // Extract the last two digits of the year

      String formattedDate = '$day/$month/$year';
      return formattedDate;
    }


    String formatTime(DateTime date) {
      String hour = date.hour.toString().padLeft(2, '0');
      String minute = date.minute.toString().padLeft(2, '0');

      String formattedTime = '$hour:$minute';
      return formattedTime;
    }




}



