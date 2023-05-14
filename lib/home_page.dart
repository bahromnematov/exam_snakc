import 'dart:async';
import 'dart:math';

import 'package:exam_snakc/side.dart';
import 'package:flutter/material.dart';

import 'point.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var snakePosition;
  Timer? timer;
  int score = 0;
  Direction _direction = Direction.UP;
  var gameState = GameState.START;
  Point? newPointPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightGreen,
        body: Container(
          margin: EdgeInsets.all(8),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.black, width: 4)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Vidas",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.red[500],
                          ),
                          Icon(Icons.favorite, color: Colors.red[500]),
                          Icon(Icons.favorite_border, color: Colors.red[500]),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Pontos",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        score.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )
                    ],
                  ),
                  Column(
                    children: const [
                      Text(
                        "Fase",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "X",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )
                    ],
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.999,
                height: MediaQuery.of(context).size.height * 0.5,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (tapUpDetails) {
                    _handleTap(tapUpDetails);
                  },
                  child: _getChildBasedOnGameState(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 50),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _direction = Direction.UP;
                              });
                            },
                            // color: Colors.green,
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green, // Background color
                            ),
                            child: Icon(Icons.keyboard_arrow_up),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _direction = Direction.LEFT;
                                    });
                                  },
                                  // color: Colors.yellow,
                                  style: ElevatedButton.styleFrom(
                                    primary:
                                        Colors.blueAccent, // Background color
                                  ),
                                  child: Icon(Icons.keyboard_arrow_left),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _direction = Direction.RIGHT;
                                    });
                                  },
                                  // color: Colors.yellow,
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.yellow, // Background color
                                  ),
                                  child: Icon(Icons.keyboard_arrow_right),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 50),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _direction = Direction.DOWN;
                              });
                            },
                            // color: Colors.green,
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red, // Background color
                            ),
                            child: Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
  void _handleTap(TapUpDetails tapUpDetails) {
    switch (gameState) {
      case GameState.START:
        startToRunState();
        break;
      case GameState.RUNNING:
        break;
      case GameState.FAILURE:
        setGameState(GameState.START);
        break;
    }
  }

  void startToRunState() {
    startingSnake();
    generatenewPoint();
    _direction = Direction.UP;
    setGameState(GameState.RUNNING);
    timer = new Timer.periodic(new Duration(milliseconds: 400), onTimeTick);
  }

  void startingSnake() {
    setState(() {
      final midPoint = (320 / 20 / 2);
      snakePosition = [
        Point(midPoint, midPoint - 1),
        Point(midPoint, midPoint),
        Point(midPoint, midPoint + 1),
      ];
    });
  }

  void generatenewPoint() {
    setState(() {
      Random rng = Random();
      var min = 0;
      var max = 320 ~/ 20;
      var nextX = min + rng.nextInt(max - min);
      var nextY = min + rng.nextInt(max - min);

      var newRedPoint = Point(nextX.toDouble(), nextY.toDouble());

      if (snakePosition.contains(newRedPoint)) {
        generatenewPoint();
      } else {
        newPointPosition = newRedPoint;
      }
    });
  }

  void setGameState(GameState _gameState) {
    setState(() {
      gameState = _gameState;
    });
  }

  Widget _getChildBasedOnGameState() {
    var child;
    switch (gameState) {
      case GameState.START:
        setState(() {
          score = 0;
        });
        child = gameStartChild;
        break;

      case GameState.RUNNING:
        List<Positioned> snakePiecesWithNewPoints = [];
        snakePosition.forEach(
          (i) {
            snakePiecesWithNewPoints.add(
              Positioned(
                child: gameRunningChild,
                left: i.x * 15.5,
                top: i.y * 15.5,
              ),
            );
          },
        );
        final latestPoint = Positioned(
          child: newSnakePointInGame,
          left: newPointPosition!.x * 15.5,
          top: newPointPosition!.y * 15.5,
        );
        snakePiecesWithNewPoints.add(latestPoint);
        child = Stack(children: snakePiecesWithNewPoints);
        break;

      case GameState.FAILURE:
        timer?.cancel();
        child = Container(
          width: 320,
          height: 320,
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Card(
              child: ListTile(
                title: Text(
                  "Seus Pontos: $score\nToque aqui para recomeçar!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            ),
          ),
        );
        break;
    }
    return child;
  }

  void onTimeTick(Timer timer) {
    setState(() {
      snakePosition.insert(0, getLatestSnake());
      snakePosition.removeLast();
    });

    var currentHeadPos = snakePosition.first;
    if (currentHeadPos.x < 0 ||
        currentHeadPos.y < 0 ||
        currentHeadPos.x > 320 / 20 ||
        currentHeadPos.y > 320 / 20) {
      setGameState(GameState.FAILURE);
      return;
    }

    if (snakePosition.first.x == newPointPosition!.x &&
        snakePosition.first.y == newPointPosition!.y) {
      generatenewPoint();
      setState(() {
        if (score <= 10)
          score = score + 1;
        else if (score > 10 && score <= 25)
          score = score + 2;
        else
          score = score + 3;
        snakePosition.insert(0, getLatestSnake());
      });
    }
  }

  Point getLatestSnake() {
    var newHeadPos;

    switch (_direction) {
      case Direction.LEFT:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x - 1, currentHeadPos.y);
        break;

      case Direction.RIGHT:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x + 1, currentHeadPos.y);
        break;

      case Direction.UP:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y - 1);
        break;

      case Direction.DOWN:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y + 1);
        break;
    }

    return newHeadPos;
  }



}
