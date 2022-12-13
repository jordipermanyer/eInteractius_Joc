import SimpleOpenNI.*;


SimpleOpenNI  context;

PImage depthCam;
PImage result;

//vairables calibrar
int rangmin=1800;
int rangmax=1900;
int []counter=new int[9];

void setup()
{
  size(640, 480, P2D);
  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }

  // mirror is by default enabled
  context.setMirror(false);
  
  //paremeter : is the current context
  context  = new SimpleOpenNI(this);
  
  // enable depthMap generation 
  context.enableDepth();

  // enable ir generation
  context.enableRGB();
  
  // create an empty PImage container
  result = createImage(width,height,RGB);
}

void draw()
{

  // update the cam
  context.update();
  
  // get the depth image and assign to the PImage var (using the lib)
  depthCam = context.depthImage();

  background(0, 255, 0);
  
  // draw irImageMap
  image(context.rgbImage(), context.depthWidth() + 10, 0);
  
  int[] depthVals = context.depthMap();
  int loc = mouseX+(mouseY*width);//serveix per comprovar profunditat
  
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
  image(result, 0, 0);
  taulell();
  
  comprovaQuadrant();
  
  for(int i=0; i< counter.length; i++){
 counter[i] = 0;  
}
}

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
    counter[0]++;
    break;
  case 2: 
    //println("Quadrant 2");
    counter[1]++;
    break;
  case 3: 
    //println("Quadrant 3"); 
    counter[2]++;
    break;
  case 4: 
    //println("Quadrant 4");  
    counter[3]++;
    break;
  case 5: 
    //println("Quadrant 5");  
    counter[4]++;
    break;
  case 6: 
    //println("Quadrant 6");  
    counter[5]++;
    break;
  case 7: 
    //println("Quadrant 7");  
    counter[6]++;
    break;
  case 8: 
    //println("Quadrant 8");  
    counter[7]++;
    break;
  case 9: 
    //println("Quadrant 9");  
    counter[8]++;
    break;
}

}

void comprovaQuadrant(){
//recorrer counter i retornar num quadrant

//println(max(counter));

//counter=new int[9];

int record = 0;
int quadrantRecord = -1;


for(int i=0; i< counter.length; i++){
 if(counter[i] > record){// && counter[i] > 10){
    record = counter[i];
    quadrantRecord = i;
 }
}

for(int i=0; i< counter.length; i++){
  print(counter[i]+"_");  
}
  println();

println(quadrantRecord + "--" + millis());



}
