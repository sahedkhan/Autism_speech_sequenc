import 'package:flutter/material.dart';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:pushable_button/pushable_button.dart';

class PicGame extends StatefulWidget {
  PicGame({Key? key}) : super(key: key);

  createState() => PicGameState();
}

class PicGameState extends State<PicGame> {
  /// Map to keep track of score
  final Map<String, bool> score = {};

  /// Choices for game
  final Map choices = {
    'assets/frog_actor#1.jpg': "Tree",
    'assets/frog_actor#2.jpg': "Orange Frog",
    'assets/frog_actor#3.jpg': "Green Frog",
    'assets/frog_actor#4.jpg': "Big Frog",
    // '🍋': "Sk",
    // '🍅': "Sk",
    // '🍇': "Sk",
    // '🥥': Colors.brown,
    // '🥕': Colors.orange
  };

  // Random seed to shuffle order of items.
  int seed = 0;
  bool gameOver = false;

  AssetsAudioPlayer player = AssetsAudioPlayer();

  @override
  void initState() {
    player.open(Audio("assets/sound/start.mp3"));

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    print(score.length);

    return Scaffold(
      body: Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/back011.png'), fit: BoxFit.fill),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: _height * 0.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      'Score ${score.length} / 4',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Container(
                      width: 120,
                      child: PushableButton(
                        child: Text(
                          'Reset',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        height: 40,
                        elevation: 8,
                        hslColor: HSLColor.fromAHSL(1.0, 120, 1.0, 0.37),
                        shadow: BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 2),
                        ),
                        onPressed: () => setState(() {
                          score.clear();
                          seed++;
                          player.open(Audio("assets/sound/start.mp3"));
                        }),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: _height * 0.03),
              Win(),
            ],
          ),
        ),
      ),
    );
  }

  Widget Win() {
    if (score.length == 4) {
      WinSound();
      return Text(
        "Win",
        style: TextStyle(
            color: Colors.red, fontSize: 50, fontWeight: FontWeight.bold),
      );
    } else {
      return Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: choices.keys.map((emoji) {
                  return Draggable<String>(
                    data: emoji,
                    child: Emoji(
                        emoji: score[emoji] == true
                            ? 'assets/right_mark.png'
                            : emoji),
                    feedback: Emoji(emoji: emoji),
                    childWhenDragging: Emoji(emoji: 'assets/right_mark.png'),
                  );
                }).toList()),
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  choices.keys.map((emoji) => _buildDragTarget(emoji)).toList()
                    ..shuffle(Random(seed)),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildDragTarget(emoji) {
    return DragTarget<String>(
      builder: (BuildContext context, List<String?> incoming, List rejected) {
        if (score[emoji] == true) {
          return Container(
            color: Colors.white,
            child: Text('Correct!'),
            alignment: Alignment.center,
            height: 120,
            width: 120,
          );
        } else {
          return Container(
            color: Colors.amberAccent,
            child: Text(choices[emoji]),
            alignment: Alignment.center,
            height: 120,
            width: 120,
          );
          // Container(
          //   color: choices[emoji],
          //   height: 80,
          //   width: 100,
          // );
        }
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data) {
        setState(() {
          score[emoji] = true;
          player.open(Audio("assets/sound/success.mp3"));
          // plyr.play('success.mp3');
        });
      },
      onLeave: (data) {},
    );
  }

  WinSound() {
    Future.delayed(Duration(seconds: 1), () {
      player.open(Audio("assets/sound/level-win.mp3"));
      // Do something
    });
  }
}

class Emoji extends StatelessWidget {
  Emoji({Key? key, required this.emoji}) : super(key: key);

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Container(
          alignment: Alignment.center,
          width: 110,
          height: 110,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(emoji), fit: BoxFit.fill),
          ),
          // child: Text(
          //   emoji,
          //   style: TextStyle(color: Colors.black, fontSize: 50),
          // ),
        ),
      ),
    );
  }
}

// AudioCache plyr = AudioCache();
