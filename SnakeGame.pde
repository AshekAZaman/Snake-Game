/*
This program runs the game "snake" which moves around the canvas, controlled by
keyboard. The J and A keys will make the snake turn left and D and L will make it turn
right. When the snake bites itself or goes off the canvas, the game is over.When
the snake eats a apple it grows bigger.If the snake eats all the apples in a 
certain level a new level begins where the snake is longer and moves faster.
*/

//CONSTANTS
final int ROWS=20, COLS=15; //The number of rows and columns of squares
final int SQ_SIZE=40;       //The size of each square in pixels
final int MAX_ARRAY_LENGTH=1000; //Maximum size of the array
final int[] X_DIRECTIONS = {0,-1,0,+1}; //X change for down, left, up, right
final int[] Y_DIRECTIONS = {+1,0,-1,0}; //Y change for down, left, up, right
final String AUTHOR= "Made by \nAshek A Zaman"; //Just for fun

//VARIABLES
int[] locationX = new int[MAX_ARRAY_LENGTH]; //Array to record intial horizontal position of the snake
int[] locationY = new int[MAX_ARRAY_LENGTH]; //Array to record intial vertical position of the snake
int[] applePositionX= new int[MAX_ARRAY_LENGTH]; // Arrray to recrod the position of the apples
int[] applePositionY= new int[MAX_ARRAY_LENGTH]; // Arrray to recrod the position of the apples
int currentLength; //Variable to record current length of the snake
int startingLength=5; //Starting number of circle that makes up the snake
int snakeSpeed=20; //Speed of the snake
int direction; //Keeping track of the direction of the snake
int startingApples=5; //Starting number of apples
int currentApples; //Variable to record current number of apples
int snakeGrowthRate=1; //Growth rate
boolean gameOver=false; //Detects when the game is over
int scoreCount; //Counts the number of apple eaten
int levelCount=1; //Counts the number of levels

void setup(){ 
 size(600,800); //Size of the Canvas 
 currentLength=startingLength; //Current length of the snake set to starting length
 resetsnake();    
 resetApples(); 
}//setup

void keyPressed(){ // Calls everytime a key is pressed  
 
  if(key=='l' || key=='L' || key=='d' || key=='D'){     
    direction=(direction+3)%4;
    moveSnake(X_DIRECTIONS[direction],Y_DIRECTIONS[direction]); //Moves Clockwise 
  }
 
  if(key=='a' || key=='A' || key=='j' || key=='J'){
   direction=(direction+1)%4;
   moveSnake(X_DIRECTIONS[direction],Y_DIRECTIONS[direction]); //Moves AntiClockwise
   }
   
}//keyPressed

void draw(){
 background(#000000); //Background set to black
 frameCount = int(frameCount%(snakeSpeed+1));
 newlevel();
 drawCircles(applePositionX,applePositionY,currentApples,#FF0000); // Draws the Apple
 drawCircles(locationX,locationY,currentLength,#FFFFFF);  //Draws the snake 
 moveSnake(X_DIRECTIONS[direction],Y_DIRECTIONS[direction]); //Moves the snake
 deletetheApples(); 
 detectCrash();
 showScorenLevel();
}//draw

void drawCircles(int[] x, int[] y, int n, int colour){  
  
  for(int i=0; i<n; i++){     
     fill(colour); // Sets color
     noStroke();
     int positionX=((ROWS+(SQ_SIZE/2))*x[i]+(SQ_SIZE/2)); // Horizontal position of the snake
     int positionY=((COLS+(SQ_SIZE/2)+(SQ_SIZE/8))*y[i]+(SQ_SIZE/2)); // Vertical position of the snake
     ellipse(positionX,positionY,SQ_SIZE,SQ_SIZE); // Circles that make up a snake
    }//for
    
}//drawCircles

void fillArray(int[] a, int n, int start,int delta){ 
  
  for(int i=0; i<n-1;i++){
      a[0]=start; //First element of the array set to start
      a[i+1]=a[i]+delta; // Second to "n" number of elements increases by delta
     }//for
     
}//fillArray

void resetsnake(){   
 fillArray(locationX,currentLength,COLS/2,0); // Information about horizontal poisition
 fillArray(locationY,currentLength,2,-1); // Information about vertical poisition  
 drawCircles(locationX,locationY,currentLength,#FFFFFF);  //Draws the circle that make up the snake
}//resetSnake

void moveSnake(int addX, int addY){    
 
  if(frameCount==snakeSpeed){
    for(int i=(currentLength-1); i>=0; i--){ 
        locationX[i+1]=locationX[i]; // Shifts the values a one place in x direction
        locationY[i+1]=locationY[i]; // Shifts the values a one place in y direction
      }
   locationX[0]+=addX; // Adds a new head in horizontal direction
   locationY[0]+=addY; // Adds a new head in vertical direction 
  }
  
}//moveSnake



int[] randomArray(int n, int max){ //Gives out random values for the position of the apples
 int values[]=new int[n];
 
 for(int i=0; i<n; i++){
     values[i]=int(random(5,max));
  }
  
 return values;
 
}

void resetApples(){
 currentApples=startingApples; // Current number of apples set to starting apples
 applePositionX=randomArray(currentApples,ROWS-5); //Determines the horizontal position of the apples
 applePositionY=randomArray(currentApples,COLS-5); //Determiens the vertical position of the apples
 drawCircles(applePositionX,applePositionY,currentApples,#FF0000); //Draws the apples 
}

int searchArrays(int[] x,int[] y,int n,int start,int keyX,int keyY){ //The searching method  

  for(int i=start; i<n; i++){
     if(x[i]==keyX && y[i]==keyY)
     return i;  
  }
  return -1;
  
}

void deleteApple(int eatenApple){    
 
  if(eatenApple>=0 && eatenApple<=currentApples){
     for(int i=eatenApple; i<currentApples-1; i++){
         applePositionX[i]=applePositionX[i+1];
         applePositionY[i]=applePositionY[i+1];
        }
  
   currentApples--; // Current number of apples decreases 
   scoreCount++;
   currentLength+=snakeGrowthRate; //Length of the snake increases
   
  }  
}

void deletetheApples(){ //Deletes apples
 int whereAppleandSnakemeets=searchArrays(applePositionX,applePositionY,
 currentApples,0,locationX[0],locationY[0]); //Searches for apples
 deleteApple(whereAppleandSnakemeets); //Deletes each apples
}

boolean detectCrash(){
  if(gameOver){
    noLoop();   
    showGameOverMessage();
  }

int Biteitself=searchArrays(locationX,locationY,
currentLength,1,locationX[0],locationY[0]);
 
  if((locationX[0]<0) || (locationX[0]>COLS-1) ||
   (locationY[0]<0) || (locationY[0]>ROWS-1)){
   gameOver=true;
  }else if(Biteitself==(-1)) {
   gameOver=false;
  }else if(locationX[Biteitself]==locationX[0] &&
  locationY[Biteitself]==locationY[0]){
   gameOver=true; 
  }
  return true;
  
}

void showGameOverMessage(){ //The game over message

 fill(0,0,255);
 textSize(100);
 textAlign(CENTER,CENTER);
 text("Game Over!",width/2,height/2);
 
 //For fun
 textSize(10);
 fill(255);
 text(AUTHOR,width/2,height/2+(210));
 
 textSize(30);
 fill(0,255,0);
 text("Scores: "+scoreCount,width/2,height/2+(160));
 
 textSize(30);
 fill(0,255,0);
 text("Your Score \nLevel Passed:"+levelCount,width/2,height/2+(100));

}

void newlevel(){
 
 if(currentApples<1){ 
   direction=0;
   resetsnake();
   startingApples++; //Apple number increases
   resetApples();
   snakeSpeed-=2; //Snake speed increases 
   levelCount++;
   }   
} 

void showScorenLevel(){
 
 textSize(20);
 fill(0,255,0);
 text("Scores: "+scoreCount,10,50);
 
 textSize(20);
 fill(0,255,0);
 text("Level: "+levelCount,10,20);
 
}
