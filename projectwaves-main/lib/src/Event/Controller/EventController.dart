
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_waves/src/Models/Event.dart';
import '../../Auth/Utils/database.dart';
import '../../Models/UserModel.dart';
import '../View/EventDetailView.dart';

class EventController {

  List<Event> likedEvents = [];

  Future<void> getEventsData() async {
    UserModel? account = await DatabaseAuthMethods().getCurrentUser();
    if (account == null) {
      throw Exception("Local stored user can't be null");
    }
    final likedEventsSnapshots = FirebaseFirestore.instance
        .collection("events")
        .where(
      FieldPath.documentId,
      whereIn: account.likedEvents.isEmpty ? ["1"] : account.likedEvents,
    );
    likedEventsSnapshots.get().then((value) {
      likedEvents = value.docs.map((doc) {
        return Event(
          eventId: doc.id,
          title: doc["title"],
          description: doc["description"],
          eventCategory: doc["eventCategory"],
          startDate: (doc["startDate"] as Timestamp).toDate(),
          endDate: (doc["endDate"] as Timestamp).toDate(),
          price: doc["price"],
          isParticipate: doc["participate"],
          uid: doc["uid"],
          image: doc["image"],
        );
      }).toList();
    });
  }

  void likeEvent(String eventId) {
    String accountId = DatabaseAuthMethods().getCurrentUserId();
    FirebaseFirestore.instance.collection("users").doc(accountId).update({
      "likedEvents": FieldValue.arrayUnion([eventId]),
    });
    DatabaseAuthMethods().setCurrentUser();
  }

  void unlikeEvent(String eventId){
    String accountId = DatabaseAuthMethods().getCurrentUserId();
    FirebaseFirestore.instance.collection("users").doc(accountId).update({
      "likedEvents": FieldValue.arrayRemove([eventId]),
    });
    DatabaseAuthMethods().setCurrentUser();
  }

  Future<bool> isLiked(String eventId) async {
    String accountId = DatabaseAuthMethods().getCurrentUserId();
    return await FirebaseFirestore.instance.collection("users").doc(accountId).get().then((value) => value.get("likedEvents").contains(eventId));
  }


  void navigateToEventDetail(Event event, context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetail(event: event),
      ),
    );
  }



}
