//TIC TAC TOE

//VARIABLES JOC
Cell[][] board;
int cols = 3;
int rows = 3;
int player = 0; //0 = player1
int win = 0;  // 1 = player1   2 = player2;
int game = 0;  // 1 = game started
int full = 9;
int aux;

//VARIABLES KINECT
import SimpleOpenNI.*;


SimpleOpenNI  context;

PImage depthCam;
PImage result;

//vairables calibrar
int rangmin=1700;//1900;
int rangmax=1800;//2080;
int []counter=new int[9];

//SETUP JOC
void setupjoc(){
  //size(1000, 1000);
  smooth();  
  board = new Cell[cols][rows];
  for (int i = 0; i< cols; i++) {
    for ( int j = 0; j < rows; j++) {
      board[i][j] = new Cell(width/3*i, height/3*j, width/3, height/3);
    }
  }
}
//SETUP KINECT
void setupkinect(){
  //size(640, 480, P2D);
  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }

  // mirror is by default enabled
  context.setMirror(true);
  
  //paremeter : is the current context
  context  = new SimpleOpenNI(this);
  
  // enable depthMap generation 
  context.enableDepth();

  // enable ir generation
  context.enableRGB();
  
  // create an empty PImage container
  result = createImage(width,height,RGB);
}

//SETUP GENERAL
void setup() {
  size(640,480);
  setupkinect();
  setupjoc();
}

//DRAW JOC
void drawjoc(){
background(0);
  // intro
  if (game == 0) {
    fill(255);
    textSize(20);
    text("Press ENTER to Start", width/2-width/4, height/2);
  }

  //game start!
  if (game == 1) {
    checkGame();  // check if  player win
    for (int i = 0; i<cols; i++) {
      for (int j = 0; j<rows; j++) {
        board[i][j].display();
      }
    }
  }
}
//DRAW KINECT
void drawkinect(){
// update the cam
  context.update();
  
  // get the depth image and assign to the PImage var (using the lib)
  depthCam = context.depthImage();

 //background(0, 255, 0);
  
  // draw irImageMap
  
  //image(context.rgbImage(), context.depthWidth() + 10, 0);
  
  int[] depthVals = context.depthMap();
 // int loc = mouseX+(mouseY*width);//serveix per comprovar profunditat
  
  //detect pixels threshold
  result.loadPixels();
  
  //go through the matrix - for each row go through every column
  for (int y=0; y<depthCam.height; y++)
  {
    //go through each col
    for (int x =0; x<depthCam.width; x++)
    {
      // get the location in the depthVals array
      int locAtion = x+(y*depthCam.width);
      // if the depth values of the sampled image are in range
      if (depthVals[locAtion] > rangmin && depthVals[locAtion]< rangmax )
      {
        //let the pixel value in the result image be white
        result.pixels[locAtion] = color(255);
        contadorPixels(x,y);
      }
      else
      //otherwise let the pixel value in the result image be white
       result.pixels[locAtion] = color(0);
    }
  }
  // update
  result.updatePixels();
  //display the result
  tint(255,32);
  image(result, 0, 0);
  //taulell();
  
  comprovaQuadrant();
  
  for(int i=0; i< counter.length; i++){
 counter[i] = 0;  
}
}
void draw() {
  drawjoc();
    drawkinect();

}

//mouse & key functions
void mousePressed() {
  if (game == 1) {
    if (win == 0) {
      for (int i = 0; i<cols; i++) {
        for (int j = 0; j<rows; j++) {
          board[i][j].click(mouseX, mouseY);
        }
      }
    }
  }
}

//FUNCIONS JOC
void keyPressed() {
  if (game == 0) {
    if ( key == ENTER) {
      game =1; //let's play
      full = 9;
    }
  } 
  else if (game == 1 && win == 0 && full == 0 ) {
    if ( key == ENTER) {
      game = 0; // start again
      for (int i = 0; i<cols; i++) {
        for (int j = 0; j<rows; j++) {
          board[i][j].clean();
          win = 0;
          full = 9;
        }
      }
    }
  }
  else if ( game == 1 && (win == 1 || win ==2)) {
    if ( key == ENTER) {
      game = 0; // start again
      for (int i = 0; i<cols; i++) {
        for (int j = 0; j<rows; j++) {
          board[i][j].clean();
          win = 0;
          full = 9;
        }
      }
    }
  }
  aux = key-48;  
  //println(aux);
  
  if (game == 1) {
    if (win == 0) {
          if(aux == 0){
            board[0][0].click(5, 5);
          }else if(aux == 1){
            board[1][0].click(width/2, 5);
          }else if(aux == 2){
            board[2][0].click(width-5, 5);
          }else if(aux == 3){
            board[0][1].click(5, height/2);
          }else if(aux == 4){
            board[1][1].click(width/2, height/2);
          }else if(aux == 5){
            board[2][1].click(width-5, height/2);
          }else if(aux == 6){
            board[0][2].click(10, height-10);
          }else if(aux == 7){
            board[1][2].click(width/2, height-5);
          }else if(aux == 8){
            board[2][2].click(width-5, height-5);
          }
    }
  }
}

void ballDetected(int q){
  
           if(q == 0){
            board[0][0].click(5, 5);
          }else if(q == 1){
            board[1][0].click(width/2, 5);
          }else if(q == 2){
            board[2][0].click(width-5, 5);
          }else if(q == 3){
            board[0][1].click(5, height/2);
          }else if(q == 4){
            board[1][1].click(width/2, height/2);
          }else if(q == 5){
            board[2][1].click(width-5, height/2);
          }else if(q == 6){
            board[0][2].click(10, height-10);
          }else if(q == 7){
            board[1][2].click(width/2, height-5);
          }else if(q == 8){
            board[2][2].click(width-5, height-5);
          }
          delay(200);
}


void checkGame() {
  int row = 0;
  //check vertical & horizontal
  for (int col = 0; col< cols; col++) {
    if (board[col][row].checkState() == 1 && board[col][row+1].checkState() == 1 && board[col][row+2].checkState() == 1) {
      //println("vertical 0 win!");
      win = 1;
    } 
    else if (board[row][col].checkState() == 1 && board[row+1][col].checkState() == 1 && board[row+2][col].checkState() == 1) {
      //println("Horizontal 0 win!");
      win = 1;
    } 
    else if (board[row][col].checkState() == 2 && board[row+1][col].checkState() == 2 && board[row+2][col].checkState() == 2) {
      //println("Horizontal X win!");
      win = 2;
    }
    else if (board[col][row].checkState() == 2 && board[col][row+1].checkState() == 2 && board[col][row+2].checkState() == 2) {
      //println("vertical X win!");
      win = 2;
    }
  }

  //check diagonals
  if (board[row][row].checkState() == 1 && board[row+1][row+1].checkState() == 1 && board[row+2][row+2].checkState() == 1) {
    //print(" diagonal 0 O win! ");
    win = 1;
  } 
  else if (board[row][row].checkState() == 2 && board[row+1][row+1].checkState() == 2 && board[row+2][row+2].checkState() == 2) {
    //println("diagonal 0 x win!");
    win = 2;
  } 
  else if (board[0][row+2].checkState() == 1 && board[1][row+1].checkState() == 1 && board[2][row].checkState() == 1) {
    //println("diagonal 1 O win!");
    win = 1;
  } 
  else if (board[0][row+2].checkState() == 2 && board[1][row+1].checkState() == 2 && board[2][row].checkState() == 2) {
    //println("diagonal 1 X win!");
    win = 2;
  }


  //write text 
  fill(255);
  textSize(20);
  for (int i = 0; i<cols; i++) {
    for (int j = 0; j<rows; j++) {
      if ( win == 1) {
        text("Player 1 \n WINS!", board[i][j].checkX()+40, board[i][j].checkY()+50);
      } 
      else if ( win == 2) {
        text("Player 2 \n WINS!", board[i][j].checkX()+40, board[i][j].checkY()+50);
      }
    }
  }


  if (win == 1 || win == 2) {
    fill(0, 255, 0);
    textSize(35);
    text("ENTER to Start Again", width/2-width/2+23, height/2-height/6-20);
  }

  if ( win == 0 && full == 0) {  // no win ;( 
    fill(0, 255, 0);
    textSize(35);
      text("ENTER to Start Again", width/2-width/2+23, height/2-height/6-20);
  }
}





//CELL CLASS

class Cell {
  int x;
  int y ;
  int w;
  int h;
  int state = 0;

  Cell(int tx, int ty, int tw, int th) {
    x = tx;
    y = ty;
    w = tw;
    h = th;
  }  

  void click(int tx, int ty) {
    int mx = tx;
    int my = ty;
    if (mx > x && mx < x+w && my > y && my < y+h) {

      if (player == 0 && state == 0) {
        state = 1;
        full -= 1;
        player = 1;
      } 
      else if (player == 1 && state == 0) {
        state = 2;
        full -= 1;
        player = 0;
      }else if(state != 0 && player == 1){
        state = 0;
        full += 1;
        player = 0;
      }else if(player == 0 && state != 0){
        state = 0;
        full += 1;
        player = 1;
      }
    }
  }
  
  void clean(){
    state = 0;  
  }
  
  int checkState(){
    return state;  
  }
  
  int checkX(){
    return x;  
  }
  
  int checkY(){
    return y;  
  }

  void display() {
    noFill();
    stroke(255);
    strokeWeight(3);
    rect(x, y, w, h);
    if (state == 1) {
      ellipseMode(CORNER);
      stroke(0, 0, 255);
      ellipse(x, y, w, h);
    } 
    else if ( state == 2) {
      stroke(255, 0, 0);
      line(x, y, x+w, y+h); 
      line(x+w, y, x, y+h);
    } 
  }
}

//FUNCIONS KINECT
void taulell(){
  stroke(255,0,0);
  line(0,height/3,width,height/3);
  line(width/3,0,width/3,height);
  
  line(0,height/1.5,width,height/1.5);
  line(width/1.5,0,width/1.5,height);
  
  noStroke();
}

void contadorPixels(int x,int y){
int quadrant=0;
//determinar quadrants
//3 de dalt
if(x>0 && x<width/3 && y>0 && y<height/3){quadrant=1;}
else if(x>width/3 && x<width/1.5 && y>0 && y<height/3){quadrant=2;}
else if(x>width/1.5 && x<width && y>0 && y<height/3){quadrant=3;}
// 3 mig
else if(x>0 && x<width/3 && y>height/3 && y<height/1.5){quadrant=4;}
else if(x>width/3 && x<width/1.5 && y>height/3 && y<height/1.5){quadrant=5;}
else if(x>width/1.5 && x<width && y>height/3 && y<height/1.5){quadrant=6;}
// 3 baix
else if(x>0 && x<width/3 && y>height/1.5 && y<height){quadrant=7;}
else if(x>width/3 && x<width/1.5 && y>height/1.5 && y<height){quadrant=8;}
else if(x>width/1.5 && x<width && y>height/1.5 && y<height){quadrant=9;}
//imprimir quadrant
switch(quadrant) {
  case 1: 
    //println("Quadrant 1");
    counter[2]++;
    break;
  case 2: 
    //println("Quadrant 2");
    counter[1]++;
    break;
  case 3: 
    //println("Quadrant 3"); 
    counter[0]++;
    break;
  case 4: 
    //println("Quadrant 4");  
    counter[5]++;
    break;
  case 5: 
    //println("Quadrant 5");  
    counter[4]++;
    break;
  case 6: 
    //println("Quadrant 6");  
    counter[3]++;
    break;
  case 7: 
    //println("Quadrant 7");  
    counter[8]++;
    break;
  case 8: 
    //println("Quadrant 8");  
    counter[7]++;
    break;
  case 9: 
    //println("Quadrant 9");  
    counter[6]++;
    break;
}

}

void comprovaQuadrant(){
//recorrer counter i retornar num quadrant

//println(max(counter));

//counter=new int[9];

int record = 50;
int quadrantRecord = -1;


for(int i=0; i< counter.length; i++){
 if(counter[i] > record){// && counter[i] > 10){
    record = counter[i];
    quadrantRecord = i;
 }
}

/*for(int i=0; i< counter.length; i++){
  println(counter[i]+"_");  
}*/
if(quadrantRecord != -1){
ballDetected(quadrantRecord);
println(quadrantRecord);
}
}
