import 'package:flutter/material.dart';
import 'package:untitledcomics/api/apifunctions.dart';
import 'package:untitledcomics/globals/globals.dart';
import 'package:untitledcomics/ui/manga.dart';

class RandomManga extends StatefulWidget {
  const RandomManga({Key? key}) : super(key: key);

  @override
  _RandomMangaState createState() => _RandomMangaState();
}

class _RandomMangaState extends State<RandomManga>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController; //controller for fade animation
  late Animation<double> _logoOpacity; //animation to use for the fade animation

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.repeat(reverse: true);
    randommanga().then((value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MangaPage(mangaOpened: value)));
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceMode = MediaQuery.of(context).orientation;
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _logoOpacity,
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.scaleDown,
                  ),
                ),
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
