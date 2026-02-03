import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF1E1E2E),
        primarySwatch: Colors.blue,
      ),
      home: PlayerNameScreen(),
    );
  }
}

// ===================
// Screen 1: Enter Name
// ===================
class PlayerNameScreen extends StatefulWidget {
  @override
  _PlayerNameScreenState createState() => _PlayerNameScreenState();
}

class _PlayerNameScreenState extends State<PlayerNameScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A2A3E), Color(0xFF1E1E2E)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.purple.shade400],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.games,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "Game Hub",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.blue.withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Choose Your Adventure",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade400,
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: TextField(
                    controller: controller,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      labelText: "Enter Your Name",
                      labelStyle: TextStyle(color: Colors.grey.shade400),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(20),
                      prefixIcon: Icon(Icons.person, color: Colors.grey.shade400),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade500, Colors.purple.shade500],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        if (controller.text.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GameSelectionScreen(
                                playerName: controller.text,
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                        child: Text(
                          "Start Playing",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

// ===================
// Screen 2: Game Selection
// ===================
class GameSelectionScreen extends StatelessWidget {
  final String playerName;
  GameSelectionScreen({required this.playerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Game"),
        leading: BackButton(),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hello, $playerName!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              
              // Tic Tac Toe
              Container(
                width: double.infinity,
                height: 80,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ModeSelectionScreen(
                          playerName: playerName,
                          gameType: "Tic Tac Toe",
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.grid_on, size: 30),
                      SizedBox(width: 15),
                      Text("Tic Tac Toe", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Chess
              Container(
                width: double.infinity,
                height: 80,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChessModeSelectionScreen(
                          playerName: playerName,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade600,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.extension, size: 30),
                      SizedBox(width: 15),
                      Text("Chess", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Checkers
              Container(
                width: double.infinity,
                height: 80,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckersModeSelectionScreen(
                          playerName: playerName,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.crop_square, size: 30),
                      SizedBox(width: 15),
                      Text("Checkers", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================
// Screen 3: Mode Selection
// ===================
class ModeSelectionScreen extends StatelessWidget {
  final String playerName;
  final String gameType;
  ModeSelectionScreen({required this.playerName, required this.gameType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A2A3E), Color(0xFF1E1E2E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back Button
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main Content
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade400, Colors.purple.shade400],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.grid_on,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "$gameType",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.blue.withOpacity(0.5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Choose Your Battle Mode",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        SizedBox(height: 50),
                        
                        // AI Mode Button - Purple
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.purple.shade500, Colors.purple.shade700],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TicTacToeScreen(playerName: playerName, vsAI: true),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.psychology, color: Colors.white, size: 28),
                                    SizedBox(width: 15),
                                    Text(
                                      "Play vs AI",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Multiplayer Button - Blue
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade500, Colors.blue.shade700],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TicTacToeScreen(playerName: playerName, vsAI: false),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.people, color: Colors.white, size: 28),
                                    SizedBox(width: 15),
                                    Text(
                                      "Play Multiplayer",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================
// Screen 3: Chess Mode Selection
// ===================
class ChessModeSelectionScreen extends StatelessWidget {
  final String playerName;
  ChessModeSelectionScreen({required this.playerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A2A3E), Color(0xFF1E1E2E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back Button
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main Content
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.purple.shade400, Colors.indigo.shade400],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.extension,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Chess",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.purple.withOpacity(0.5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Master the Game of Kings",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        SizedBox(height: 50),
                        
                        // AI Mode Button - Purple
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.purple.shade500, Colors.purple.shade700],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChessScreen(
                                      player1Name: playerName,
                                      player2Name: "AI",
                                      vsAI: true,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.psychology, color: Colors.white, size: 28),
                                    SizedBox(width: 15),
                                    Text(
                                      "Play vs AI",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Multiplayer Button - Blue
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade500, Colors.blue.shade700],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChessScreen(
                                      player1Name: playerName,
                                      player2Name: "Player 2",
                                      vsAI: false,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.people, color: Colors.white, size: 28),
                                    SizedBox(width: 15),
                                    Text(
                                      "Play Multiplayer",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================
// Screen 4: Chess Game
// ===================
class ChessScreen extends StatefulWidget {
  final String player1Name;
  final String player2Name;
  final bool vsAI;
  ChessScreen({required this.player1Name, required this.player2Name, required this.vsAI});

  @override
  _ChessScreenState createState() => _ChessScreenState();
}

class _ChessScreenState extends State<ChessScreen> {
  List<List<String>> board = List.generate(8, (_) => List.filled(8, ""));
  String status = "White's turn";
  bool gameOver = false;
  String selectedPiece = "";
  int? selectedRow, selectedCol;
  bool isWhiteTurn = true;

  @override
  void initState() {
    super.initState();
    status = "${widget.player1Name} (White)'s turn";
    initializeBoard();
  }

  void initializeBoard() {
    // Initialize chess pieces with proper colors
    board[0] = ['♜', '♞', '♝', '♛', '♚', '♝', '♞', '♜']; // Black pieces
    board[1] = List.filled(8, '♟'); // Black pawns
    board[6] = List.filled(8, '♙'); // White pawns
    board[7] = ['♖', '♘', '♗', '♕', '♔', '♗', '♘', '♖']; // White pieces
  }

  void cellTap(int row, int col) {
    if (gameOver) return;

    if (selectedPiece.isEmpty) {
      // Select a piece
      if (board[row][col].isNotEmpty) {
        bool isWhitePiece = '♔♕♖♗♘♙'.contains(board[row][col]);
        if ((isWhiteTurn && isWhitePiece) || (!isWhiteTurn && !isWhitePiece)) {
          setState(() {
            selectedPiece = board[row][col];
            selectedRow = row;
            selectedCol = col;
          });
        }
      }
    } else {
      // Try to move the piece
      if (row == selectedRow && col == selectedCol) {
        // Deselect if clicking same piece
        setState(() {
          selectedPiece = "";
          selectedRow = null;
          selectedCol = null;
        });
      } else if (isValidMove(selectedRow!, selectedCol!, row, col)) {
        // Move the piece
        setState(() {
          board[row][col] = selectedPiece;
          board[selectedRow!][selectedCol!] = "";
          selectedPiece = "";
          selectedRow = null;
          selectedCol = null;
          isWhiteTurn = !isWhiteTurn;
          status = isWhiteTurn ? 
            "${widget.player1Name} (White)'s turn" : 
            "${widget.player2Name} (Black)'s turn";
        });
        
        // AI move for black if in AI mode
        if (widget.vsAI && !isWhiteTurn) {
          Future.delayed(Duration(milliseconds: 500), makeAIMove);
        }
      } else {
        // Select new piece if it's the right color
        if (board[row][col].isNotEmpty) {
          bool isWhitePiece = '♔♕♖♗♘♙'.contains(board[row][col]);
          if ((isWhiteTurn && isWhitePiece) || (!isWhiteTurn && !isWhitePiece)) {
            setState(() {
              selectedPiece = board[row][col];
              selectedRow = row;
              selectedCol = col;
            });
          } else {
            // Can't select opponent's piece
            setState(() {
              selectedPiece = "";
              selectedRow = null;
              selectedCol = null;
            });
          }
        } else {
          // Invalid move to empty square
          setState(() {
            selectedPiece = "";
            selectedRow = null;
            selectedCol = null;
          });
        }
      }
    }
  }

  bool isValidMove(int fromRow, int fromCol, int toRow, int toCol) {
    if (fromRow == toRow && fromCol == toCol) return false;
    
    // Allow moving to any empty square for now
    if (board[toRow][toCol].isEmpty) return true;
    
    // Allow capturing opponent pieces
    bool isTargetWhite = '♔♕♖♗♘♙'.contains(board[toRow][toCol]);
    bool isMovingWhite = '♔♕♖♗♘♙'.contains(board[fromRow][fromCol]);
    return isTargetWhite != isMovingWhite;
  }

  void makeAIMove() {
    List<List<int>> blackPieces = [];
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (board[r][c].isNotEmpty && !'♔♕♖♗♘♙'.contains(board[r][c])) {
          blackPieces.add([r, c]);
        }
      }
    }
    
    if (blackPieces.isNotEmpty) {
      var piece = blackPieces[math.Random().nextInt(blackPieces.length)];
      int fromRow = piece[0], fromCol = piece[1];
      
      List<List<int>> possibleMoves = [];
      for (int r = 0; r < 8; r++) {
        for (int c = 0; c < 8; c++) {
          if (isValidMove(fromRow, fromCol, r, c)) {
            possibleMoves.add([r, c]);
          }
        }
      }
      
      if (possibleMoves.isNotEmpty) {
        var move = possibleMoves[math.Random().nextInt(possibleMoves.length)];
        setState(() {
          board[move[0]][move[1]] = board[fromRow][fromCol];
          board[fromRow][fromCol] = "";
          isWhiteTurn = true;
          status = "${widget.player1Name} (White)'s turn";
        });
      }
    }
  }

  Widget buildChessCell(int row, int col) {
    bool isLight = (row + col) % 2 == 0;
    bool isSelected = selectedRow == row && selectedCol == col;
    String piece = board[row][col];
    bool isWhitePiece = '♔♕♖♗♘♙'.contains(piece);
    
    return GestureDetector(
      onTap: () => cellTap(row, col),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade300 : 
                 isLight ? Colors.brown.shade200 : Colors.brown.shade400,
        ),
        child: Center(
          child: piece.isNotEmpty ? Text(
            piece,
            style: TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.bold,
              color: isWhitePiece ? Colors.white : Colors.black,
            ),
          ) : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chess"),
        leading: BackButton(),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(status, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Container(
                width: 280,
                height: 280,
                child: Column(
                  children: List.generate(8, (row) {
                    return Expanded(
                      child: Row(
                        children: List.generate(8, (col) {
                          return Expanded(
                            child: buildChessCell(row, col),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    initializeBoard();
                    status = "${widget.player1Name} (White)'s turn";
                    gameOver = false;
                    selectedPiece = "";
                    selectedRow = null;
                    selectedCol = null;
                    isWhiteTurn = true;
                  });
                },
                child: Text("New Game"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================
// Screen 5: Checkers Mode Selection
// ===================
class CheckersModeSelectionScreen extends StatelessWidget {
  final String playerName;
  CheckersModeSelectionScreen({required this.playerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A2A3E), Color(0xFF1E1E2E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back Button
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main Content
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.orange.shade400, Colors.deepOrange.shade400],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.crop_square,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Checkers",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.orange.withOpacity(0.5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Jump Your Way to Victory",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        SizedBox(height: 50),
                        
                        // AI Mode Button - Purple
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.purple.shade500, Colors.purple.shade700],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CheckersScreen(
                                      player1Name: playerName,
                                      player2Name: "AI",
                                      vsAI: true,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.psychology, color: Colors.white, size: 28),
                                    SizedBox(width: 15),
                                    Text(
                                      "Play vs AI",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Multiplayer Button - Blue
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade500, Colors.blue.shade700],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CheckersScreen(
                                      player1Name: playerName,
                                      player2Name: "Player 2",
                                      vsAI: false,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.people, color: Colors.white, size: 28),
                                    SizedBox(width: 15),
                                    Text(
                                      "Play Multiplayer",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================
// Screen 6: Checkers Game
// ===================
class CheckersScreen extends StatefulWidget {
  final String player1Name;
  final String player2Name;
  final bool vsAI;
  CheckersScreen({required this.player1Name, required this.player2Name, required this.vsAI});

  @override
  _CheckersScreenState createState() => _CheckersScreenState();
}

class _CheckersScreenState extends State<CheckersScreen> {
  List<List<String>> board = List.generate(8, (_) => List.filled(8, ""));
  String status = "Red's turn";
  bool gameOver = false;
  String selectedPiece = "";
  int? selectedRow, selectedCol;
  bool isRedTurn = true;

  @override
  void initState() {
    super.initState();
    status = "${widget.player1Name} (Red)'s turn";
    initializeBoard();
  }

  void initializeBoard() {
    // Initialize checkers pieces on dark squares only
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 8; col++) {
        if ((row + col) % 2 == 1) {
          board[row][col] = '●'; // Black pieces
        }
      }
    }
    
    for (int row = 5; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if ((row + col) % 2 == 1) {
          board[row][col] = '○'; // Red pieces
        }
      }
    }
  }

  void cellTap(int row, int col) {
    if (gameOver) return;

    if (selectedPiece.isEmpty) {
      // Select a piece
      if (board[row][col].isNotEmpty && (row + col) % 2 == 1) {
        bool isRedPiece = board[row][col] == '○' || board[row][col] == '♔';
        if ((isRedTurn && isRedPiece) || (!isRedTurn && !isRedPiece)) {
          setState(() {
            selectedPiece = board[row][col];
            selectedRow = row;
            selectedCol = col;
          });
        }
      }
    } else {
      // Move the piece
      if (isValidMove(selectedRow!, selectedCol!, row, col)) {
        setState(() {
          board[row][col] = selectedPiece;
          board[selectedRow!][selectedCol!] = "";
          selectedPiece = "";
          selectedRow = null;
          selectedCol = null;
          isRedTurn = !isRedTurn;
          status = isRedTurn ? 
            "${widget.player1Name} (Red)'s turn" : 
            "${widget.player2Name} (Black)'s turn";
        });
        
        // Check for king promotion
        if (row == 0 && board[row][col] == '○') {
          setState(() {
            board[row][col] = '♔'; // Red king
          });
        } else if (row == 7 && board[row][col] == '●') {
          setState(() {
            board[row][col] = '♚'; // Black king
          });
        }
        
        // AI move for black if in AI mode - faster response
        if (widget.vsAI && !isRedTurn) {
          Future.delayed(Duration(milliseconds: 200), makeAIMove); // Reduced from 500ms
        }
      } else {
        // Deselect or select new piece
        setState(() {
          selectedPiece = "";
          selectedRow = null;
          selectedCol = null;
        });
      }
    }
  }

  bool isValidMove(int fromRow, int fromCol, int toRow, int toCol) {
    // Can only move on dark squares
    if ((toRow + toCol) % 2 == 0) return false;
    if (fromRow == toRow && fromCol == toCol) return false;
    
    // Check if destination is empty
    if (board[toRow][toCol].isNotEmpty) return false;
    
    String piece = board[fromRow][fromCol];
    int rowDiff = toRow - fromRow;
    int colDiff = (toCol - fromCol).abs();
    
    // Regular pieces can only move forward diagonally
    if (piece == '○') { // Red piece
      if (rowDiff != -1 || colDiff != 1) return false;
    } else if (piece == '●') { // Black piece
      if (rowDiff != 1 || colDiff != 1) return false;
    } else if (piece == '♔' || piece == '♚') { // Kings can move any direction
      if (rowDiff.abs() != 1 || colDiff != 1) return false;
    }
    
    return true;
  }

  void makeAIMove() {
    List<List<int>> blackPieces = [];
    
    // Find black pieces - optimized loop
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        String piece = board[r][c];
        if (piece.isNotEmpty && piece != '○' && piece != '♔') {
          blackPieces.add([r, c]);
        }
      }
    }
    
    if (blackPieces.isEmpty) return;
    
    // Try to find best move - prioritize captures
    List<List<int>> captureMoves = [];
    List<List<int>> regularMoves = [];
    
    for (var piece in blackPieces) {
      int fromRow = piece[0], fromCol = piece[1];
      
      // Check limited moves for speed
      for (int dr = -2; dr <= 2; dr++) {
        for (int dc = -2; dc <= 2; dc++) {
          int toRow = fromRow + dr;
          int toCol = fromCol + dc;
          
          if (toRow >= 0 && toRow < 8 && toCol >= 0 && toCol < 8) {
            if (isValidMove(fromRow, fromCol, toRow, toCol)) {
              if ((dr).abs() == 2) { // Capture move
                captureMoves.add([fromRow, fromCol, toRow, toCol]);
              } else { // Regular move
                regularMoves.add([fromRow, fromCol, toRow, toCol]);
              }
            }
          }
        }
      }
    }
    
    // Choose best move
    List<List<int>> movesToConsider = captureMoves.isNotEmpty ? captureMoves : regularMoves;
    
    if (movesToConsider.isNotEmpty) {
      var move = movesToConsider[math.Random().nextInt(movesToConsider.length)];
      int fromRow = move[0], fromCol = move[1], toRow = move[2], toCol = move[3];
      
      setState(() {
        // Check for king promotion
        String piece = board[fromRow][fromCol];
        if (toRow == 0 && piece == '●') {
          board[toRow][toCol] = '♚'; // Promote to king
        } else {
          board[toRow][toCol] = piece;
        }
        
        board[fromRow][fromCol] = "";
        isRedTurn = true;
        status = "${widget.player1Name} (Red)'s turn";
      });
    }
  }

  Widget buildCheckersCell(int row, int col) {
    bool isLight = (row + col) % 2 == 0;
    bool isSelected = selectedRow == row && selectedCol == col;
    String piece = board[row][col];
    
    return GestureDetector(
      onTap: () => cellTap(row, col),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade300 : 
                 isLight ? Colors.brown.shade200 : Colors.brown.shade600,
          border: Border.all(color: Colors.black.withOpacity(0.3)),
        ),
        child: Center(
          child: piece.isNotEmpty ? Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: piece == '○' || piece == '♔' ? Colors.red.shade600 : Colors.grey.shade800,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: piece == '♔' || piece == '♚' ? 
                Icon(Icons.star, color: Colors.yellow, size: 20) : null,
            ),
          ) : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkers"),
        leading: BackButton(),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(status, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Container(
                width: 320,
                height: 320,
                child: GridView.builder(
                  itemCount: 64,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                  ),
                  itemBuilder: (context, index) {
                    int row = index ~/ 8;
                    int col = index % 8;
                    return buildCheckersCell(row, col);
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    initializeBoard();
                    status = "${widget.player1Name} (Red)'s turn";
                    gameOver = false;
                    selectedPiece = "";
                    selectedRow = null;
                    selectedCol = null;
                    isRedTurn = true;
                  });
                },
                child: Text("New Game"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ===================
class TicTacToeScreen extends StatefulWidget {
  final String playerName;
  final bool vsAI;
  TicTacToeScreen({required this.playerName, required this.vsAI});

  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<String> board = List.filled(9, "");
  String status = "Player 1's turn";
  bool gameOver = false;
  bool isLoading = false;
  int currentPlayer = 1; // multiplayer: 1=X, 2=O
  Map scores = {"win": 0, "lose": 0, "draw": 0};

  void playerTap(int index) async {
    if (board[index] != "" || gameOver || isLoading) return;

    setState(() {
      if (widget.vsAI) {
        board[index] = "X";
        status = "AI Thinking...";
        isLoading = true;
      } else {
        board[index] = currentPlayer == 1 ? "X" : "O";
        currentPlayer = 3 - currentPlayer;
        status = "Player ${currentPlayer == 1 ? 2 : 1}'s turn";
      }
    });

    if (widget.vsAI) {
      await callAI();
    } else {
      String winner = checkWinner();
      if (winner != "") {
        setState(() {
          gameOver = true;
          status = winner == "Draw" ? "🤝 Draw!" : "🎉 Player ${winner == "X" ? 1 : 2} Wins!";
        });
      }
    }
  }

  Future<void> callAI() async {
    try {
      setState(() {
        status = "AI Thinking...";
        isLoading = true;
      });
      
      final url = Uri.parse(
        kIsWeb ? "http://localhost:8000/tictactoe" : "http://10.0.2.2:8000/tictactoe",
      );

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"board": board, "player_name": widget.playerName}),
      ).timeout(Duration(seconds: 2)); // Reduced timeout

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        int aiIndex = data["ai_index"];
        String winner = data["winner"];
        setState(() {
          if (aiIndex != -1) board[aiIndex] = "O";
          if (winner != "") {
            gameOver = true;
            if (winner == "Player 1") {
              status = "🎉 Player 1 Wins!";
            } else if (winner == "Player 2") {
              status = "🤖 Player 2 Wins!";
            } else {
              status = "🤝 Draw!";
            }
          } else {
            status = "Player 1's turn";
          }
          isLoading = false;
        });
      } else {
        throw Exception('Failed to connect to AI');
      }
    } catch (e) {
      // Immediate fallback to simple AI
      simpleAI();
    }
  }

  void simpleAI() {
    List<int> empty = [];
    for (int i = 0; i < 9; i++) if (board[i] == "") empty.add(i);
    if (empty.isEmpty) {
      setState(() {
        status = "🤝 Draw!";
        gameOver = true;
        isLoading = false;
      });
      return;
    }

    int aiMove = empty[math.Random().nextInt(empty.length)];
    setState(() {
      board[aiMove] = "O";
      String winner = checkWinner();
      if (winner != "") {
        gameOver = true;
        status = winner == "X" ? "🎉 You Win!" : winner == "O" ? "🤖 AI Wins!" : "🤝 Draw!";
      } else {
        status = "Your Turn (X)";
      }
      isLoading = false;
    });
  }

  String checkWinner() {
    List<List<int>> lines = [
      [0,1,2],[3,4,5],[6,7,8],
      [0,3,6],[1,4,7],[2,5,8],
      [0,4,8],[2,4,6],
    ];

    for (var line in lines) {
      if (board[line[0]] != "" && board[line[0]] == board[line[1]] && board[line[1]] == board[line[2]]) {
        return board[line[0]];
      }
    }

    if (!board.contains("")) return "Draw"; // All cells filled, no winner = Draw
    return ""; // No winner yet
  }

  void restartGame() {
    setState(() {
      board = List.filled(9, "");
      gameOver = false;
      status = widget.vsAI ? "Your Turn (X)" : "Player 1's turn";
      currentPlayer = 1;
    });
  }

  Widget buildCell(int index) {
    bool isX = board[index] == "X";

    return GestureDetector(
      onTap: () => playerTap(index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: board[index] == ""
              ? LinearGradient(colors: [Color(0xFF2A2A3E), Color(0xFF3A3A4E)])
              : isX
                  ? LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade600])
                  : LinearGradient(colors: [Colors.red.shade400, Colors.red.shade600]),
          border: Border.all(
            color: board[index] == "" ? Colors.white.withOpacity(0.1) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            board[index],
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tic Tac Toe"),
        leading: BackButton(), // Back to mode selection
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(status, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Container(
                width: 300,
                height: 300,
                child: GridView.builder(
                  itemCount: 9,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) => buildCell(index),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: restartGame,
                child: Text("Restart Game", style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
