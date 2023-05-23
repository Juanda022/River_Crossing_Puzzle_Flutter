import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ColorGame(),
    );
  }
}

class ColorGame extends StatefulWidget {
  const ColorGame({Key? key}) : super(key: key);

  @override
  createState() => ColorGameState();
}

class ColorGameState extends State<ColorGame> {
  /// Manejo de la puntuacion
  final Map<String, bool> score = {};

  /// Lista de las imagenes junto con su logica
  final Map<String, Color> choices = {
    'assets/P1.png': Colors.blue,
    'assets/P2.png': Colors.yellow,
    'assets/P3.png': Colors.red,
    'assets/P4.png': Colors.purple,
    'assets/P5.png': Colors.brown,
  };

  // Cambiar el orden los colores.
  int seed = 0;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (score.length != 5) {
      return Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
              title: Text('Puntuacion ${score.length} / 5'),
              backgroundColor: Colors.blue),

          //Boton para reiniciar
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                score.clear();
                count = 0;
                seed++;
              });
            },
          ),
          body: Stack(fit: StackFit.expand, children: [
            Image.asset(
              'assets/Fondo.png', // Ruta de la imagen de fondo
              fit: BoxFit.cover,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: choices.keys.map((imagePath) {
                      return Draggable<String>(
                        data: imagePath,
                        feedback: Image.asset(
                          imagePath,
                          height: 100,
                          width: 100,
                        ),
                        childWhenDragging: Image.asset(
                          'assets/plant.png',
                          height: 80,
                          width: 80,
                        ),
                        child: score[imagePath] == true
                            ? Image.asset(
                                'assets/chulo.png',
                                height: 100,
                                width: 60,
                              )
                            : Image.asset(
                                imagePath,
                                height: 80,
                                width: 80,
                              ),
                      );
                    }).toList()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: choices.keys.map((imagePath) {
                    return _buildDragTarget(imagePath);
                  }).toList()
                    ..shuffle(Random(seed)),
                )
              ],
            ),
          ]));
    }
    return Scaffold(
      appBar: AppBar(
          title: const Text('GANASTE',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white)),
          backgroundColor: Colors.yellow),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            score.clear();
            count = 0;
            seed++;
          });
        },
      ),
      body: const Center(
        child: Text('GANASTE'),
      ),
    );
  }

  Widget _buildDragTarget(String imagePath) {
    return DragTarget<String>(
      builder: (BuildContext context, List<String?> incoming, List rejected) {
        if (score[imagePath] == true) {
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            height: 90,
            width: 200,
            child: const Text('Correcto'),
          );
        } else {
          int position = choices.keys.toList().indexOf(imagePath) +
              1; // Obtener el índice del mapa
          return Container(
            decoration: BoxDecoration(
              color: choices[imagePath],
              borderRadius: BorderRadius.circular(10),
            ),
            height: 80,
            width: 190,
            alignment: Alignment.center,
            child: Text('Paso $position',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.grey)),
          );
        }
      },
      onWillAccept: (data) => data == imagePath,
      onAccept: (data) {
        setState(() {
          score[imagePath] = true;
        });
      },
      onLeave: (data) {},
    );
  }
}

class Personaje extends StatelessWidget {
  const Personaje({Key? key, required this.imagePath}) : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 100,
        padding: const EdgeInsets.all(10),
        child: Text(
          imagePath,
          style: const TextStyle(color: Colors.black, fontSize: 50),
        ),
      ),
    );
  }
}
