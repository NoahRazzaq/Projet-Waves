import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_waves/src/Models/Event.dart';

import '../Components/EventCard.dart';
import '../Controller/EventController.dart';
import 'EventDetailView.dart';


class EventList extends StatefulWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> with TickerProviderStateMixin {
  var currentDate = DateTime.now();
  EventController _eventController = EventController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _eventController.getEventsData();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      _handleTabSelection();
    });
  }

  void _handleTabSelection() {
    setState(() {
      _eventController.getEventsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.list)),
              Tab(icon: Icon(Icons.favorite)),
            ],
          ),
          title: const Text('Event List'),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('events').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Text('No events found.');
                }

                return ListView(
                  padding: EdgeInsets.all(16.0),
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Event event = Event.fromJson(document.data() as Map<String, dynamic>);
                    event.eventId = document.id;
                    String userId = event.uid;

                    // verification si l'événement est terminé ou non
                    if (event.endDate.isBefore(currentDate)) {
                      return SizedBox();
                    }

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                        if (userSnapshot.hasError) {
                          return Text('Error: ${userSnapshot.error}');
                        }

                        return EventCard(
                          event: event,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventDetail(event: event),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _eventController.likedEvents.length,
                    itemBuilder: (context, index) {
                      if (_eventController.likedEvents.isNotEmpty) {
                        Event event = _eventController.likedEvents[index];
                        return GestureDetector(
                          onTap: () => _eventController.navigateToEventDetail(event, context),
                          child: EventCard(
                            event: event,
                            onTap: () {
                              _eventController.navigateToEventDetail(event, context);
                            }, // Add your custom action
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
