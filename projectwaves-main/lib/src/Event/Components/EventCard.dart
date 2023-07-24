import 'package:flutter/material.dart';
import 'package:project_waves/colors.dart';
import 'package:project_waves/font_sizes.dart';
import 'package:project_waves/src/Models/Event.dart';

import '../Controller/EventController.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final VoidCallback onTap;


  const EventCard({
    required this.event,
    required this.onTap,
  });


  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isHeartClicked = false;
  EventController _eventController = EventController(); // Create an instance of EventController

  @override
  void initState() {

    super.initState();
    _eventController.isLiked(widget.event.eventId).then((value){
      setState(() {
        isHeartClicked = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            height: 120.0,
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(8.0),
                      width: 110.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          widget.event.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.event.eventCategory,
                              style: TextStyle(
                                color: AppColors.darkBlue,
                                fontWeight: FontWeight.w700,
                                fontSize: FontSizes.md,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              widget.event.title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: FontSizes.md,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  widget.event.getStartDate(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: FontSizes.sm,
                                  ),
                                ),
                                SizedBox(width: 3.0), // Espace de 6.0 pixels
                                const Text(
                                  '|',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: FontSizes.sm,
                                  ),
                                ),
                                SizedBox(width: 3.0), // Espace de 6.0 pixels
                                Text(
                                  '${widget.event.getStartTime()} - ${widget.event.getEndTime()}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: FontSizes.sm,
                                  ),
                                ),
                                SizedBox(width: 3.0), // Espace de 6.0 pixels
                                const Text(
                                  '|',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: FontSizes.sm,
                                  ),
                                ),
                                SizedBox(width: 3.0), // Espace de 6.0 pixels
                                Text(
                                  '${widget.event.price} €',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: FontSizes.sm,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: const [
                                  Text(
                                    'Date',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: FontSizes.xs,
                                    ),
                                  ),
                                  SizedBox(width: 6.0),
                                  Text(
                                    'Schedules',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: FontSizes.xs,
                                    ),
                                  ),
                                  SizedBox(width: 6.0),
                                  Text(
                                    'Price',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: FontSizes.xs,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if(isHeartClicked){
                          _eventController.unlikeEvent(widget.event.eventId);
                        } else {
                          _eventController.likeEvent(widget.event.eventId);
                        }
                        isHeartClicked = !isHeartClicked;
                      });
                    },
                    child: Icon(
                      Icons.favorite,
                      color: isHeartClicked ? Colors.pink : Colors.grey,
                      size: 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
