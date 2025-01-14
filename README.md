# README: Haskell Board Game Implementation

## Overview
This project is a Haskell implementation of a board game where the objective is to turn all black pegs (`B`) into white pegs (`W`). Flips occur only for positions adjacent to white pegs. The implementation demonstrates key functional programming concepts such as recursion and immutability.

### Core Concepts
- **Position**: Represents the coordinates of a peg on the board.
- **Color**: Indicates whether a peg is white (`W`) or black (`B`).
- **Peg**: Combines a position and a color.
- **Move**: Represents a potential move to a specific position.
- **Board**: A list of all pegs.
- **State**: Combines a move and the resulting board configuration.

## Data Types
### Definitions
```haskell
type Position = (Int, Int)
data Color = W | B deriving (Eq, Show)
data Peg = Peg Position Color deriving (Eq, Show)
data Move = M Position deriving (Eq, Show)
type Board = [Peg]
data State = S Move Board deriving (Eq, Show)
```

### Explanation
- **Position**: A tuple `(Int, Int)` representing the x and y coordinates.
- **Color**: An enumerated type with two possible values: `W` (White) and `B` (Black).
- **Peg**: A peg at a specific position with a specific color.
- **Move**: A move targeting a specific position on the board.
- **Board**: A collection of all pegs.
- **State**: A snapshot of the game, including the current move and board configuration.

## Functions
### 1. `createBoard`
Creates the initial board configuration based on a given starting position.

```haskell
createBoard :: Position -> Board
createBoard (a, b)
  | abs a + abs b > 4 || (abs a == 2 && abs b == 2) = error "Program error: The position is not valid."
  | otherwise = [
      Peg (x, y) (
        \(u, v) (i, r) -> if (u, v) == (i, r) then W else B
      ) (a, b) (x, y)
      | x <- [-3..3], y <- [-3..3], abs x + abs y <= 4, (abs x /= 2 || abs y /= 2)
    ]
```
**Details**:
- The board is generated as a list of pegs.
- Pegs outside the playable region or at invalid positions are excluded.

### 2. `isValidMove`
Checks if a move is valid based on the current board configuration.

```haskell
isValidMove :: Move -> Board -> Bool
isValidMove (M (x, y)) b
  | elem (Peg (x, y) W) b = False
  | elem (Peg (x + 1, y) W) b || elem (Peg (x, y + 1) W) b || elem (Peg (x - 1, y) W) b || elem (Peg (x, y - 1) W) b = True
  | otherwise = False
```
**Details**:
- A move is valid if it targets a black peg adjacent to at least one white peg.

### 3. `isGoal`
Checks if the board has reached the goal state (all pegs are white).

```haskell
isGoal :: Board -> Bool
isGoal b = notElem False [c == W | (Peg (_, _) c) <- b]
```
**Details**:
- Returns `True` if every peg on the board is white.

### 4. `showPossibleNextStates`
Generates all possible next states from the current board configuration.

```haskell
showPossibleNextStates :: Board -> [State]
showPossibleNextStates b
  | isGoal b = error "Program error: No Possible States Exist."
  | otherwise = [
      S (M (x, y)) (
        map
          (\(Peg (c, d) m) -> if (x, y) == (c, d) then Peg (c, d) W else Peg (c, d) m)
          b
      )
      | x <- [-3..3], y <- [-3..3], abs x + abs y <= 4, (abs x /= 2 || abs y /= 2), isValidMove (M (x, y)) b
    ]
```
**Details**:
- Generates states by applying valid moves.
- Updates the board for each move, flipping the targeted peg to white.

## Technologies
- **Language**: Haskell
- **Programming Paradigm**: Functional Programming
- **Key Features**: Recursion, Higher-Order Functions, and Immutability

## How to Run
1. Install Haskell (GHC) on your system.
2. Save the code to a file, e.g., `BoardGame.hs`.
3. Load the file in GHCi using the command:
   ```bash
   ghci BoardGame.hs
   ```
4. Create an initial board and explore the game logic using the provided functions.

## Example Usage
```haskell
-- Create a board with the initial white peg at position (0,0)
let board = createBoard (0, 0)

-- Check if a move is valid
isValidMove (M (1, 0)) board

-- Display all possible next states
showPossibleNextStates board
```

## Notes
- The board is modeled as a diamond shape with specific constraints on valid positions.
- This implementation assumes a fixed board size and predefined rules for valid moves.

## Future Improvements
- Add a graphical interface for visualizing the board.
- Implement AI to suggest optimal moves.
- Expand the rules to support additional game mechanics.

