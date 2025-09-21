import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twinity/services/db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final int gridSize = 4;
  late List<List<int>> grid;
  late List<List<int>> gridNew;
  int score = 0;
  final DbService _dbService = DbService();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  bool isGameOver = false;

  final Map<int, Color> tileColors = {
    0: Colors.grey[800]!,
    2: Colors.orange[100]!,
    4: Colors.orange[200]!,
    8: Colors.orange[300]!,
    16: Colors.deepOrange[200]!,
    32: Colors.deepOrange[300]!,
    64: Colors.red[300]!,
    128: Colors.yellow[500]!,
    256: Colors.yellow[600]!,
    512: Colors.yellow[700]!,
    1024: Colors.amber[800]!,
    2048: Colors.amber[900]!,
  };

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    setState(() {
      grid = List.generate(gridSize, (y) => List.generate(gridSize, (x) => 0));
      gridNew = List.generate(gridSize, (y) => List.generate(gridSize, (x) => 0));
      score = 0;
      isGameOver = false;
      _addNumber();
      _addNumber();
    });
  }

  void _addNumber() {
    List<Point<int>> emptyTiles = [];
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        if (grid[y][x] == 0) {
          emptyTiles.add(Point(x, y));
        }
      }
    }
    if (emptyTiles.isNotEmpty) {
      int index = Random().nextInt(emptyTiles.length);
      Point<int> pos = emptyTiles[index];
      grid[pos.y][pos.x] = Random().nextInt(10) == 0 ? 4 : 2;
    }
  }

  List<int> _slide(List<int> row) {
    List<int> newRow = row.where((val) => val != 0).toList();
    for (int i = 0; i < newRow.length - 1; i++) {
      if (newRow[i] == newRow[i + 1]) {
        newRow[i] *= 2;
        score += newRow[i];
        newRow.removeAt(i + 1);
      }
    }
    while (newRow.length < gridSize) {
      newRow.add(0);
    }
    return newRow;
  }

  void _move(String direction) {
    if (isGameOver) return;

    List<List<int>> newGrid = List.from(grid.map((row) => List.from(row)));
    bool moved = false;

    // Rotate grid for different directions
    if (direction == 'UP') newGrid = _rotate(newGrid);
    if (direction == 'RIGHT') newGrid = _rotate(_rotate(newGrid));
    if (direction == 'DOWN') newGrid = _rotate(_rotate(_rotate(newGrid)));

    for (int i = 0; i < gridSize; i++) {
      List<int> originalRow = List.from(newGrid[i]);
      newGrid[i] = _slide(newGrid[i]);
      if (originalRow.toString() != newGrid[i].toString()) {
        moved = true;
      }
    }

    // Rotate back
    if (direction == 'DOWN') newGrid = _rotate(newGrid);
    if (direction == 'RIGHT') newGrid = _rotate(_rotate(newGrid));
    if (direction == 'UP') newGrid = _rotate(_rotate(_rotate(newGrid)));

    if (moved) {
      setState(() {
        grid = newGrid;
        _addNumber();
        _checkGameOver();
      });
    }
  }

  List<List<int>> _rotate(List<List<int>> grid) {
    List<List<int>> newGrid = List.generate(gridSize, (_) => List.filled(gridSize, 0));
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        newGrid[y][x] = grid[x][gridSize - 1 - y];
      }
    }
    return newGrid;
  }

  void _checkGameOver() {
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        if (grid[y][x] == 0) return; // Not over
        if (y < gridSize - 1 && grid[y][x] == grid[y + 1][x]) return; // Not over
        if (x < gridSize - 1 && grid[y][x] == grid[y][x + 1]) return; // Not over
      }
    }

    setState(() {
      isGameOver = true;
    });

    // Award points to the user in Firebase
    if (currentUser != null && score > 0) {
      _dbService.updateUserProfile(currentUser!.uid, {
        'points': FieldValue.increment(score),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('2048 Game')),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Score: $score', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                ElevatedButton(onPressed: _resetGame, child: const Text('New Game')),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! < 0) _move('UP');
                if (details.primaryVelocity! > 0) _move('DOWN');
              },
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! < 0) _move('LEFT');
                if (details.primaryVelocity! > 0) _move('RIGHT');
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    int x = index % 4;
                    int y = index ~/ 4;
                    int value = grid[y][x];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      decoration: BoxDecoration(
                        color: tileColors[value] ?? Colors.grey[800],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          value == 0 ? '' : value.toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: value <= 4 ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (isGameOver)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text('Game Over!', style: TextStyle(fontSize: 32, color: Colors.red[400], fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}