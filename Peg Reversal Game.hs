type Position = (Int,Int)
data Color = W | B deriving (Eq, Show)
data Peg = Peg Position Color deriving (Eq, Show)
data Move = M Position deriving (Eq, Show)
type Board = [Peg]
data State = S Move Board deriving (Eq, Show)


createBoard :: Position -> Board
createBoard (a,b) | abs a + abs b > 4 || (abs a == 2 && abs b == 2) = error "Program error: The position is not valid."
                  | otherwise =  [Peg (x,y) ((\(u,v) (i,r) -> if (u,v) == (i,r) then W else B) (a,b) (x,y))| x <- [-3..3], y <- [-3..3], abs x + abs y <= 4, (abs x /= 2 || abs y /= 2)]

isValidMove :: Move -> Board -> Bool
isValidMove (M (x,y)) b | elem (Peg (x,y) W) b = False 
                        | elem (Peg (x+1,y) W) b || elem (Peg (x,y+1) W) b || elem (Peg (x-1,y) W) b || elem (Peg (x,y-1) W) b = True
                        | otherwise = False

isGoal :: Board -> Bool
isGoal b = notElem False [c == W | (Peg (_,_) c) <- b]

showPossibleNextStates :: Board -> [State]
showPossibleNextStates b | isGoal b = error "Program error: No Possible States Exist."
                         | otherwise = [S (M (x,y)) (map (\(Peg(c,d) m) -> if (x,y) == (c,d) then Peg(c,d) W else Peg(c,d) m) b) | x <- [-3..3], y <- [-3..3], abs x + abs y <= 4, (abs x /= 2 || abs y /= 2) ,isValidMove (M (x,y)) b]


