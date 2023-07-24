import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwipeButton extends StatelessWidget {
  final Function onTap;
  final Widget child;

  const SwipeButton({
    required this.onTap,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: child,
    );
  }
}

//swipe card to the right side
Widget swipeRightButton(AppinioSwiperController controller) {
  return SwipeButton(
    onTap: () => { 
      controller.swipeRight(),
      controller.swipe(),
      print(controller.state)
    },
    child: Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(50),

      ),
      alignment: Alignment.center,
      /*child: const Icon(
        Icons.check,
        color: CupertinoColors.white,
        size: 40,
      ),*/
      child: const Image(image: AssetImage('images/check.png')),
    ),
  );
}

//swipe card to the left side
Widget swipeLeftButton(AppinioSwiperController controller) {
  return SwipeButton(
    onTap: () => {
        controller.swipeLeft(),
        print(controller.state)
      },

    child: Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(50),

      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.close,
        color: CupertinoColors.white,
        size: 40,
      ),
    ),
  );
}

//unswipe card
Widget unswipeButton(AppinioSwiperController controller) {
  return SwipeButton(
    onTap: () =>
        {
          controller.unswipe(),
          print(controller.state)
        },
    child: Container(
      height: 60,
      width: 60,
      alignment: Alignment.center,
      child: const Icon(
        Icons.rotate_left_rounded,
        color: Colors.white,
        size: 40,
      ),
    ),
  );
}