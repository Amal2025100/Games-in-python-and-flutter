from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import random

app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# =========================
# Request Models
# =========================
class TicTacToeRequest(BaseModel):
    board: list       # 9 cells
    player_name: str  # player name

class ChessRequest(BaseModel):
    board: list       # 8x8 board
    player_name: str  # player name
    is_white_turn: bool  # whose turn

class CheckersRequest(BaseModel):
    board: list       # 8x8 board
    player_name: str  # player name
    is_red_turn: bool  # whose turn

# =========================
# Scores (simple in-memory)
# =========================
scores = {}

# =========================
# Check winner
# =========================
def check_winner(board):
    win_lines = [
        [0,1,2],[3,4,5],[6,7,8],
        [0,3,6],[1,4,7],[2,5,8],
        [0,4,8],[2,4,6]
    ]
    for line in win_lines:
        a,b,c = line
        if board[a] != "" and board[a] == board[b] == board[c]:
            return board[a]
    return None

# =========================
# Minimax Algorithm
# =========================
def minimax(board, is_ai):
    winner = check_winner(board)
    if winner == "O":
        return 1
    elif winner == "X":
        return -1
    elif "" not in board:
        return 0

    if is_ai:
        best_score = -100
        for i in range(9):
            if board[i] == "":
                board[i] = "O"
                score = minimax(board, False)
                board[i] = ""
                if score > best_score:
                    best_score = score
        return best_score
    else:
        best_score = 100
        for i in range(9):
            if board[i] == "":
                board[i] = "X"
                score = minimax(board, True)
                board[i] = ""
                if score < best_score:
                    best_score = score
        return best_score

# =========================
# AI Move
# =========================
def ai_move(board):
    empty = [i for i in range(9) if board[i] == ""]
    if not empty:
        return -1

    # Try to win first
    for i in empty:
        board[i] = "O"
        if check_winner(board) == "O":
            board[i] = ""
            print("AI wins at index:", i)
            return i
        board[i] = ""

    # Block player from winning
    for i in empty:
        board[i] = "X"
        if check_winner(board) == "X":
            board[i] = ""
            print("AI blocks at index:", i)
            return i
        board[i] = ""

    # Take center if available
    if 4 in empty:
        print("AI takes center:", 4)
        return 4

    # Take corners
    corners = [i for i in empty if i in [0, 2, 6, 8]]
    if corners:
        move = corners[0]
        print("AI takes corner:", move)
        return move

    # Take any available space
    move = empty[0]
    print("AI moves to index:", move)
    return move

# =========================
# Chess AI Logic
# =========================
def chess_ai_move(board):
    """Simple but effective Chess AI"""
    black_pieces = []
    
    # Find all black pieces
    for row in range(8):
        for col in range(8):
            piece = board[row][col]
            if piece and piece not in ['♔', '♕', '♖', '♗', '♘', '♙']:  # Black pieces
                black_pieces.append((row, col, piece))
    
    if not black_pieces:
        return -1, -1
    
    # Try to find valid moves
    valid_moves = []
    for row, col, piece in black_pieces:
        for target_row in range(8):
            for target_col in range(8):
                if is_valid_chess_move(board, row, col, target_row, target_col):
                    # Prioritize captures
                    if board[target_row][target_col]:
                        valid_moves.insert(0, (row, col, target_row, target_col))
                    else:
                        valid_moves.append((row, col, target_row, target_col))
    
    if valid_moves:
        # Prefer captures, then random move
        move = valid_moves[0] if valid_moves else random.choice(valid_moves)
        return move[2], move[3]  # Return target position
    
    return -1, -1

def is_valid_chess_move(board, from_row, from_col, to_row, to_col):
    """Basic chess move validation"""
    if from_row == to_row and from_col == to_col:
        return False
    
    piece = board[from_row][from_col]
    target = board[to_row][to_col]
    
    # Can't capture own piece
    if target and ((piece in ['♔', '♕', '♖', '♗', '♘', '♙']) == 
                   (target in ['♔', '♕', '♖', '♗', '♘', '♙'])):
        return False
    
    # Simple validation - allow most moves for now
    return True

# =========================
# Checkers AI Logic  
# =========================
def checkers_ai_move(board):
    """Smart Checkers AI"""
    black_pieces = []
    
    # Find all black pieces
    for row in range(8):
        for col in range(8):
            if (row + col) % 2 == 1:  # Only dark squares
                piece = board[row][col]
                if piece and piece not in ['○', '♔']:  # Black pieces
                    black_pieces.append((row, col, piece))
    
    if not black_pieces:
        return -1, -1
    
    # Try to find valid moves
    valid_moves = []
    for row, col, piece in black_pieces:
        for target_row in range(8):
            for target_col in range(8):
                if is_valid_checkers_move(board, row, col, target_row, target_col, piece):
                    # Prioritize captures and king moves
                    if abs(target_row - row) == 2:  # Capture
                        valid_moves.insert(0, (row, col, target_row, target_col))
                    elif piece in ['♚'] and target_row > row:  # King moving backward
                        valid_moves.insert(0, (row, col, target_row, target_col))
                    else:
                        valid_moves.append((row, col, target_row, target_col))
    
    if valid_moves:
        move = valid_moves[0] if valid_moves else random.choice(valid_moves)
        return move[2], move[3]  # Return target position
    
    return -1, -1

def is_valid_checkers_move(board, from_row, from_col, to_row, to_col, piece):
    """Checkers move validation"""
    if (to_row + to_col) % 2 == 0:  # Must be on dark square
        return False
    
    if board[to_row][to_col]:  # Target must be empty
        return False
    
    row_diff = to_row - from_row
    col_diff = abs(to_col - from_col)
    
    # Regular pieces
    if piece == '●':  # Black regular piece
        if row_diff == 1 and col_diff == 1:  # Forward move
            return True
        elif row_diff == 2 and col_diff == 2:  # Capture
            middle_row = (from_row + to_row) // 2
            middle_col = (from_col + to_col) // 2
            return board[middle_row][middle_col] in ['○', '♔']  # Capture red
    elif piece == '♚':  # Black king
        if abs(row_diff) == 1 and col_diff == 1:  # Any direction
            return True
        elif abs(row_diff) == 2 and col_diff == 2:  # Capture
            middle_row = (from_row + to_row) // 2
            middle_col = (from_col + to_col) // 2
            return board[middle_row][middle_col] in ['○', '♔']  # Capture red
    
    return False

# =========================
# API Endpoints
# =========================
# =========================
# API Endpoints
# =========================

@app.post("/tictactoe")
def play_tictactoe(data: TicTacToeRequest):
    board = data.board.copy()
    name = data.player_name

    if name not in scores:
        scores[name] = {"win":0, "lose":0, "draw":0}

    # Check winner before AI move
    winner = check_winner(board)
    if winner:
        if winner == "X":
            scores[name]["win"] += 1
            winner = "Player 1"
        else:
            scores[name]["lose"] += 1
            winner = "Player 2"
        return {"winner": winner, "ai_index": -1, "scores": scores}

    # Check for draw before AI move
    if "" not in board:
        scores[name]["draw"] += 1
        return {"winner": "Draw", "ai_index": -1, "scores": scores}

    # AI Move
    ai_index = ai_move(board)
    
    # Apply AI move to a copy for checking
    board_copy = board.copy()
    if ai_index != -1:
        board_copy[ai_index] = "O"

    # Check winner after AI move
    winner = check_winner(board_copy)
    if winner == "X":
        scores[name]["win"] += 1
        winner = "Player 1"
    elif winner == "O":
        scores[name]["lose"] += 1
        winner = "Player 2"
    elif winner is None and "" not in board_copy:
        winner = "Draw"
        scores[name]["draw"] += 1

    return {"winner": winner if winner else "", "ai_index": ai_index, "scores": scores}

@app.post("/chess")
def play_chess(data: ChessRequest):
    board = [row[:] for row in data.board]  # Deep copy
    name = data.player_name
    
    if name not in scores:
        scores[name] = {"win":0, "lose":0, "draw":0}
    
    # AI move for black pieces
    from_row, from_col = -1, -1
    to_row, to_col = chess_ai_move(board)
    
    # Find which piece is moving
    if to_row != -1 and to_col != -1:
        for r in range(8):
            for c in range(8):
                if board[r][c] and board[r][c] not in ['♔', '♕', '♖', '♗', '♘', '♙']:
                    if is_valid_chess_move(board, r, c, to_row, to_col):
                        from_row, from_col = r, c
                        break
            if from_row != -1:
                break
    
    # Make the move
    if from_row != -1 and to_row != -1:
        board[to_row][to_col] = board[from_row][from_col]
        board[from_row][from_col] = ""
    
    return {
        "from_row": from_row,
        "from_col": from_col, 
        "to_row": to_row,
        "to_col": to_col,
        "board": board
    }

@app.post("/checkers")
def play_checkers(data: CheckersRequest):
    board = [row[:] for row in data.board]  # Deep copy
    name = data.player_name
    
    if name not in scores:
        scores[name] = {"win":0, "lose":0, "draw":0}
    
    # AI move for black pieces
    from_row, from_col = -1, -1
    to_row, to_col = checkers_ai_move(board)
    
    # Find which piece is moving
    if to_row != -1 and to_col != -1:
        for r in range(8):
            for c in range(8):
                if (r + c) % 2 == 1:  # Dark squares only
                    piece = board[r][c]
                    if piece and piece not in ['○', '♔']:  # Black pieces
                        if is_valid_checkers_move(board, r, c, to_row, to_col, piece):
                            from_row, from_col = r, c
                            break
            if from_row != -1:
                break
    
    # Check for king promotion
    if to_row == 0 and board[from_row][from_col] == '●':
        piece_to_move = '♚'  # Promote to king
    else:
        piece_to_move = board[from_row][from_col]
    
    # Make the move
    if from_row != -1 and to_row != -1:
        board[to_row][to_col] = piece_to_move
        board[from_row][from_col] = ""
        
        # Handle captures
        if abs(to_row - from_row) == 2:
            middle_row = (from_row + to_row) // 2
            middle_col = (from_col + to_col) // 2
            board[middle_row][middle_col] = ""
    
    return {
        "from_row": from_row,
        "from_col": from_col,
        "to_row": to_row, 
        "to_col": to_col,
        "board": board
    }
