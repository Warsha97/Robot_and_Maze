/* Robot
 * Author: user
 * Creation date: 12/14/2020
 */
MACHINE
    Robot
INCLUDES
    Maze
PROMOTES
    checkExitFound,
    getRobotsRoute,
    getCurrentPosition,
    checkSquareVisited
    
SETS
    MOVEMENTS={North,
                South,
                East,
                West,
            Teleport};
            
    OUTPUT_MESSAGES={MoveFailedDueToInternalWall,
                     TeleportFailedDueToInternalWall, 
                     MoveFailedDueToMazeBoundary, 
                     TeleoprtFailedDueToMazeBoundary, 
                     CannotTeleportToCurrentSquare,
                     MovedSuccessfully, 
                     TeleportedSuccessfully}
                
VARIABLES
    xCoordinate,
    yCoordinate,   
    movementsDone
    
INVARIANT
    xCoordinate:NATURAL1 &
    yCoordinate:NATURAL1 &
    xCoordinate:xAxis &
    yCoordinate:yAxis &
    movementsDone:seq(MOVEMENTS)
INITIALISATION
    xCoordinate:=1||
    yCoordinate:=1||
    movementsDone:=[]
    
DEFINITIONS
    //Animation Functions
    ANIMATION_FUNCTION == ({ y, x, i | x:xAxis & y:yAxis & i=0 });
    ANIMATION_FUNCTION1 == ({ y, x, i | x:xAxis & y:yAxis  & i=1 & (x, 6-y) : Walls });
    ANIMATION_FUNCTION2 == ({ y, x, i | x:xAxis & y:yAxis & i=2 & x=xCoordinate & y=(6-yCoordinate) });
    
    //Grid Images
    ANIMATION_IMG0 == "/robotImages/square.gif";
    ANIMATION_IMG1 == "/robotImages/wall.gif";
    ANIMATION_IMG2 == "/robotImages/robot.gif";
    
    
OPERATIONS
    //Move robot to North
    message<--moveNorth=
    IF(yCoordinate+1:yAxis&(xCoordinate|->yCoordinate+1/:Walls))
    THEN
        yCoordinate:=yCoordinate+1||
        updateRoute(xCoordinate,yCoordinate+1,visitedRoute<-(xCoordinate|->yCoordinate))||
        movementsDone:=movementsDone<-North||
        message:=MovedSuccessfully
    ELSIF(yCoordinate+1/:yAxis)
    THEN
        message:=MoveFailedDueToMazeBoundary
    ELSE
        message:=MoveFailedDueToInternalWall
        END;
        
    
    //Move robot to South
     message<--moveSouth=
    IF(yCoordinate-1:yAxis&(xCoordinate|->yCoordinate-1/:Walls))
    THEN
        yCoordinate:=yCoordinate-1||
        updateRoute(xCoordinate,yCoordinate-1,visitedRoute<-(xCoordinate|->yCoordinate))||
        movementsDone:=movementsDone<-South||
        message:=MovedSuccessfully
    ELSIF(yCoordinate-1/:yAxis)
    THEN
        message:=MoveFailedDueToMazeBoundary
    ELSE
        message:=MoveFailedDueToInternalWall
        END;
   
    //Move robot to East
    message<--moveEast=
    IF(xCoordinate+1:xAxis&(xCoordinate+1|->yCoordinate/:Walls))
    THEN
        xCoordinate:=xCoordinate+1||
        updateRoute(xCoordinate+1,yCoordinate,visitedRoute<-(xCoordinate|->yCoordinate))||
        movementsDone:=movementsDone<-East||
        message:=MovedSuccessfully
    ELSIF(xCoordinate+1/:xAxis)
    THEN
        message:=MoveFailedDueToMazeBoundary
    ELSE
        message:=MoveFailedDueToInternalWall
        END;
    
    //Move robot to West
    message<--moveWest=
    IF(xCoordinate-1:xAxis&(xCoordinate-1|->yCoordinate/:Walls))
    THEN
        xCoordinate:=xCoordinate-1||
        updateRoute(xCoordinate-1,yCoordinate,visitedRoute<-(xCoordinate|->yCoordinate))||
        movementsDone:=movementsDone<-West||
        message:=MovedSuccessfully
    ELSIF(xCoordinate-1/:xAxis)
    THEN
        message:=MoveFailedDueToMazeBoundary
    ELSE
        message:=MoveFailedDueToInternalWall
        END;
    
    
   //Teleport robot to any square except current square 
   teleportMessage  <-- teleport(xTeleportPoint, yTeleportPoint)  =
   PRE
       xTeleportPoint : xAxis &
       yTeleportPoint : yAxis 
   THEN
       IF
           ((xTeleportPoint |-> yTeleportPoint) /: Walls &
            (xTeleportPoint |-> yTeleportPoint) /: {(xCoordinate|->yCoordinate)})
       THEN
           xCoordinate := xTeleportPoint ||
           yCoordinate := yTeleportPoint ||
           teleportMessage :=TeleportedSuccessfully ||
		     updateRoute(xTeleportPoint, yTeleportPoint, visitedRoute<-(xCoordinate|->yCoordinate))||
		     movementsDone:=movementsDone<-(Teleport)
       ELSE IF
               ((xTeleportPoint |-> yTeleportPoint) : Walls)
           THEN
               teleportMessage := TeleportFailedDueToInternalWall
       ELSE
            teleportMessage := CannotTeleportToCurrentSquare
    
           END
       END
   END    

END
