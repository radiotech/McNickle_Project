/* @pjs preload="gardenDry.png,gardenImg.png,gardenMask.png,mainMenuImg.png,mainMenuImgFaded.png,mainMenuMask.png,travelBG1.png,writeImg.png,writeMask.png,gardenPlant00.png,gardenPlant01.png,gardenPlant02.png,gardenPlant03.png,gardenPlant04.png,gardenPlant05.png,gardenPlant06.png,gardenPlant07.png,gardenPlant08.png,gardenPlant09.png,gardenPlant010.png,gardenPlant10.png,gardenPlant11.png,gardenPlant12.png,gardenPlant13.png,gardenPlant14.png,gardenPlant15.png,gardenPlant16.png,gardenPlant17.png,gardenPlant18.png,gardenPlant19.png,gardenPlant110.png,gardenPlant20.png,gardenPlant21.png,gardenPlant22.png,gardenPlant23.png,gardenPlant24.png,gardenPlant25.png,gardenPlant26.png,gardenPlant27.png,gardenPlant28.png,gardenPlant29.png,gardenPlant210.png"; crisp="true"; font="RockSalt.ttf,Coolvetica.ttf"; */ 

String NEWLN = "\n";
int mode;
PFont titleFont, medFont, travelFont;
String bookTitle = "";

void setup(){
  size(900,600);
  
  if(random(100) < 33){
    bookTitle = "Runner in the Sun";
  } else if(random(100) < 50){
    bookTitle = "Wind from an Enemy Sky";
  } else {
    bookTitle = "The Surrounded";
  }
  
  background(255);
  titleFont = createFont("RockSalt.ttf",48);
  medFont = createFont("Coolvetica.ttf",30);
  travelFont = createFont("Coolvetica.ttf",44);
  
  String text = "Explore the life of McNickle through a variety of entertaining and"+NEWLN+
  "educational mini-games. These games mimic some of McNickle’s"+NEWLN+
  "daily activities and incorporate quotes from his journals and"+NEWLN+
  "novels. Garden, read, and travel to accumulate inspiration"+NEWLN+
  "then write to work on your novel, "+bookTitle+"."+NEWLN+NEWLN+
  "Have fun!"+NEWLN+NEWLN+
  "Click anywhere to continue.";
  
  splash("McNickle: The Video Game",text,-2);
}

void draw(){
  switch(mode){
    case 0:
      drawTravel();
      break;
    case 1:
      drawRead();
      break;
    case 2:
      drawGarden();
      break;
    case 3:
      drawWrite();
      break;
    case 256:
      drawSplash();
      break;
    default:
      drawMM();
  }
}

void mousePressed(){
  switch(mode){
    case 0:
      mousePressedTravel();
      break;
    case 1:
      mousePressedRead();
      break;
    case 2:
      mousePressedGarden();
      break;
    case 3:
      mousePressedWrite();
      break;
    case 256:
      mousePressedSplash();
      break;
    default:
      mousePressedMM();
  }
}

void mouseReleased(){
  switch(mode){
    case 2:
      mouseReleasedGarden();
      break;
  }
}

PImage gardenImg,gardenMask,gardenWater,gardenSeeds,gardenWet,gardenDry;
PImage plants[][];
int spriteScale = 5;
int holding = -1;
float waters[];
int stages[];
int types[];
float drySpeed = .002;
int plotSize;

void setupGarden(){
  mode = 2;
  holding = -1;
  gardenImg = loadImage("gardenImg.png");
  gardenMask = loadImage("gardenMask.png");
  gardenWater = loadImage("gardenWater.png");
  gardenSeeds = loadImage("gardenSeeds.png");
  gardenWet = loadImage("gardenWet.png");
  gardenDry = loadImage("gardenDry.png");
  waters = new float[6];
  stages = new int[6];
  types = new int[6];
  for(int i = 0; i < 6; i++){
    waters[i] = 1+random(3);
    stages[i] = -1;
    types[i] = (int) random(12);
  }
  plants = new PImage[12][11];
  for(int i = 0; i < 3; i++){
    for(int j = 0; j < 11; j++){
      plants[i][j] = loadImage("gardenPlant"+i+j+".png");
      plants[i+3][j] = rot90(plants[i][j]);
      plants[i+6][j] = rot90(plants[i+3][j]);
      plants[i+9][j] = rot90(plants[i+6][j]);
      if(plants[i][j].width != 45){
      }
    }
  }
  plotSize = (int)(width*.25);
}

void drawGarden(){
  image(gardenImg,0,0,width,height);
  
  int done = 0;
  int good = 0;
  for(int i = 0; i < 6; i++){
    waters[i]-=drySpeed;
    if(waters[i] < 1){
      waters[i] = max(0,waters[i]);
      image(gardenDry,plotX(i)-plotSize/2,plotY(i)-plotSize/2,plotSize,plotSize);
    }
    if(waters[i] > 4){
      waters[i] = min(5,waters[i]);
      image(gardenWet,plotX(i)-plotSize/2,plotY(i)-plotSize/2,plotSize,plotSize);
    }
    if(stages[i] > -1){
      
      if(stages[i] < 90){
        if(waters[i] > 1 && waters[i] < 4){
          if(random(100)<2){
            stages[i]++;
          }
        } else {
          if(random(1000)<1){
            stages[i] = 101;
          }
        }
      } else {
        done++;
        if(stages[i] < 100){
          good++;
        }
      }
      
      image(plants[types[i]][(int)(stages[i]/10)],plotX(i)-plotSize/2,plotY(i)-plotSize/2,plotSize,plotSize);
    }
  }
  
  if(done == 6){
    setupMMSlow((int)(good/6.0*25),0);
  }
  
  if(holding == 0){
    image(gardenWater,mouseX-gardenWater.width/2*spriteScale,mouseY-gardenWater.height/2*spriteScale,gardenWater.width*spriteScale,gardenWater.height*spriteScale);
  }
  if(holding == 1){
    image(gardenSeeds,mouseX-gardenSeeds.width/2*spriteScale,mouseY-gardenSeeds.height/2*spriteScale,gardenSeeds.width*spriteScale,gardenSeeds.height*spriteScale);
  }
}

void mousePressedGarden(){
  
  if(mouseOn() == 100 || mouseOn() == 101){
    holding = mouseOn()-100;
  }
  
}

void mouseReleasedGarden(){
  if(mouseOn() >= 0 && mouseOn() < 6){
    if(holding == 0){
      waters[mouseOn()]++;
    }
    if(holding == 1){
      if(stages[mouseOn()] == -1){
        stages[mouseOn()] = 0;
      }
    }
  }
  holding = -1;
}

int mouseOn(){
  return (int)blue(gardenMask.get((int)(mouseX*1.0/width*gardenMask.width),(int)(mouseY*1.0/height*gardenMask.height)));
}
float plotX(int i){
  return width*.23+(i%3)*width*.26;
}
float plotY(int i){
  return height*.35+(i%2)*width*.21;
}
PImage rot90(PImage toRot){
  PImage temp1 = createImage(toRot.height,toRot.width,ARGB);
  for(int i = 0; i < toRot.width; i++){
    for(int j = 0; j < toRot.height; j++){
      temp1.set(j,i,toRot.get(i,j));
    }
  }
  PImage temp2 = createImage(toRot.height,toRot.width,ARGB);
  for(int i = 0; i < toRot.width; i++){
    for(int j = 0; j < toRot.height; j++){
      temp2.set(temp2.width-i-1,j,temp1.get(i,j));
    }
  }
  return temp2;
}
PImage mainMenuImg, mainMenuImgFaded;
PImage mainMenuMask;
int selectedMM = 255;
int fadeMM = 0;

int inspiration = (int)random(20);
int bookProgress = (int)random(20);
String hoverClick = "";

int showcFrame = -1;
String showcA = "", showcB = "";

void setupMM(){
  mainMenuImg = loadImage("mainMenuImg.png");
  mainMenuImgFaded = loadImage("mainMenuImgFaded.png");
  mainMenuMask = loadImage("mainMenuMask.png");
}

void setupMMSlow(int dinsp, int dprog){
  inspiration = min(100,inspiration+dinsp);
  bookProgress = min(100,bookProgress+dprog);
  mode = 255;
  fadeMM = 70;
  showcFrame = 0;
  showcA = "";
  showcB = "";
  if(dinsp < 0){
    showcA = ""+dinsp;
  } else if(dinsp > 0){
    showcA = "+"+dinsp;
  }
  if(dprog < 0){
    showcB = ""+dprog;
  } else if(dprog > 0){
    showcB = "+"+dprog;
  }
}

void drawMM(){
  
  if(fadeMM > 0){
    fadeMM--;
    image(mainMenuImgFaded,0,0,width,height);
  } else {
    image(mainMenuImg,0,0,width,height);
    
    if(mouseX < width && mouseX > 0 && mouseY < height && mouseY > 0){
      selectedMM = (int)blue(mainMenuMask.get((int)(mouseX*1.0/width*mainMenuMask.width),(int)(mouseY*1.0/height*mainMenuMask.height)));
      hoverClick = "";
      switch(selectedMM){
        case 0:
          hoverClick = "Travel";
          break;
        case 1:
          hoverClick = "Read";
          break;
        case 2:
          hoverClick = "Garden";
          break;
        case 3:
          hoverClick = "Write";
          break;
      }
    }
    textFont(titleFont);
    fill(0);
    textAlign(LEFT,CENTER);
    text("Inspiration: "+inspiration+"%",width*.05,height*.1);
    text("Book Progress: "+bookProgress+"%",width*.05,height*.2);
    text(hoverClick,width*.05,height*.3);
    if(showcFrame >= 0 && showcFrame < 255){
      fill(100,255-showcFrame);
      text(showcA,width*.05+textWidth("Inspiration: "+inspiration+"%")+showcFrame/5.0,height*.1);
      text(showcB,width*.05+textWidth("Book Progress: "+bookProgress+"%")+showcFrame/5.0,height*.2);
      showcFrame++;
      if(showcFrame == 255 && bookProgress == 100){
        String closeText = "You completed your book, "+bookTitle+"!"+NEWLN+NEWLN+
        "We hope you learned a lot about D’Arcy McNickle."+NEWLN+
        "For more information, please visit tinyurl.com/McNickle."+NEWLN+NEWLN+
        "Thanks for playing!";
        splash("Congratulations!",closeText,100);
      }
    }
  }
}

void mousePressedMM(){
  if(selectedMM < 4){
    String body = "";
    switch(selectedMM){
      case 0:
        body = "Travel through the eyes of McNickle by reading about his"+NEWLN+
        "excursions and gathering inspiration. Click anywhere"+NEWLN+
        "on the screen when you see a line turn green"+NEWLN+
        "but avoid clicking the lines that turn red."+NEWLN+NEWLN+
        "Have some fun!"+NEWLN+NEWLN+
        "Click to continue.";
        break;
      case 1:
        body = "Read through the writings of McNickle by exploring some"+NEWLN+
        "of his journal entries. In this mini-game you must bounce"+NEWLN+
        "a ball against McNickle’s words to break them apart."+NEWLN+
        "Use your paddle to prevent the ball from falling"+NEWLN+
        "off the bottom of the screen."+NEWLN+NEWLN+
        "All the best!"+NEWLN+NEWLN+
        "Click to continue.";
        break;
      case 2:
        body = "Garden like McNickle by dragging seeds and water onto"+NEWLN+
        "the six flower plots. If a plot turns yellow, then it’s"+NEWLN+
        "too dry and if it turns blue, it’s too wet. Plots that"+NEWLN+
        "are wet or dry may kill your plants. The game"+NEWLN+
        "is over once all your flowers either"+NEWLN+
        "blossom or die."+NEWLN+NEWLN+
        "Good luck!"+NEWLN+NEWLN+
        "Click to continue.";
        break;
      case 3:
        body = "Write in the shoes of McNickle by recreating text"+NEWLN+
        "from his novels. In this Tetris-like mini-game, use"+NEWLN+
        "the control buttons to place blocks around McNickle’s"+NEWLN+
        "writing. Avoid placing blocks in the spaces between"+NEWLN+
        "his words! The game is over once you can"+NEWLN+
        "no longer place any blocks."+NEWLN+NEWLN+
        "Best of luck!"+NEWLN+NEWLN+
        "Click to continue.";
        break;
    }
    splash(hoverClick+" Mini-Game",body,selectedMM);
  }
  
}
float ballx, bally, balldx, balldy;
float ballw = 10, ballSpeed = 4, paddleSpeed = 10, ballsc = 1.0001;
float paddlex, paddley, paddlew = 200;
boolean readOn;
char blocks[][] = new char[20][5];
int blockw = 42;
int readScore = 0;
int readInn;
char SPACE = " ".charAt(0);

int readLine = 0;

void setupRead(){
  mode = 1;
  
  ballx = width/2;
  bally = height*3/4;
  balldx = sqrt(sq(ballSpeed)/2);
  balldy = -balldx;
  if(random(100)<50){
    balldx = -balldx;
  }
  paddlex = width/2;
  paddley = height*9/10;
  readOn = false;
  
  readLine++;
  readInn = 0;
  String[] readLines = loadStrings("readText.txt");
  for(int i = 0; i < 20; i++){
    for(int j = 0; j < 5; j++){
      blocks[i][j] = readLines[readLine%readLines.length].charAt(i+j*20);
      
      if(blocks[i][j] != SPACE){
        readInn++;
      }
    }
  }
  
}

void drawRead(){
  background(0);
  noStroke();
  
  if(readOn){
    balldx *= ballsc;
    balldy *= ballsc;
    if(abs(mouseX-paddlex)<paddleSpeed){
      paddlex = mouseX;
    } else {
      if(mouseX > paddlex){
        paddlex += paddleSpeed;
      } else {
        paddlex -= paddleSpeed;
      }
    }
    if(ballx < ballw/2){
      balldx = abs(balldx);
    }
    if(bally < ballw/2){
      balldy = abs(balldy);
    }
    if(ballx > width-ballw/2){
      balldx = -abs(balldx);
    }
    if(bally > height-ballw/2){
      setupMMSlow(readScore,0);
    }
    if(abs(ballx-paddlex) < paddlew/2+ballw/2 && abs((paddley-ballw/2)-bally)<ballw/2){
      balldy = -abs(balldy);
    }
    ballx += balldx;
    bally += balldy;
    
  } else {
    textAlign(CENTER,CENTER);
    fill(255);
    textFont(titleFont);
    text("Click to Start",width/2,height*3/5);
  }
  fill(100,255,255);
  rect(ballx-ballw/2,bally-ballw/2,ballw,ballw);
  fill(255,255,100);
  rect(paddlex-paddlew/2,paddley-ballw/2,paddlew,ballw);
  fill(255,100,255);
  int tot = 0;
  for(int i = 0; i < 20; i++){
    for(int j = 0; j < 5; j++){
      if(blocks[i][j] != SPACE){
        tot++;
        float posx = width/2-blockw*10.0+blockw*i;
        float posy = blockw+blockw*j-blockw/2.0;
        rect(posx+ballw/2,posy+ballw/2,blockw-ballw,blockw-ballw);
        if(abs(ballx-posx-blockw/2)<blockw/2 && abs(bally-posy-blockw/2)<blockw/2){
          if(abs(ballx-posx-blockw/2)>abs(bally-posy-blockw/2)){
            balldx = -balldx;
          } else {
            balldy = -balldy;
          }
          blocks[i][j] = SPACE;
        }
      }
    }
  }
  readScore = (int)((readInn-tot*1.0)/readInn*25);
  if(tot == 0){
    setupMMSlow(readScore,0);
  }
  fill(0);
  textFont(medFont);
  for(int i = 0; i < 20; i++){
    for(int j = 0; j < 5; j++){
      text(blocks[i][j],width/2-blockw*9.5+blockw*i,blockw+blockw*j);
    }
  }
}

void mousePressedRead(){
  readOn = true;
}

int splashFade;

String splashTitle;
String splashText;
int splashThen;
int splashScoreA;
int splashScoreB;

void splash(String title, String body, int then){
  mode = 256;
  splashFade = -1000;
  splashTitle = title;
  splashText = body;
  splashThen = then;
}

void splashD(String title, String body, int then, int scorea, int scoreb){
  splashScoreA = scorea;
  splashScoreB = scoreb;
  splash(title,body,then);
}


void drawSplash(){
  if(splashFade != 0){
    splashFade++;
  }
  noStroke();
  fill(255,(1000+splashFade)/2000.0*255);
  rect(0,0,width,height);
  
  fill(0,(1000+splashFade)/1000.0*255);
  textAlign(CENTER,CENTER);
  
  textFont(titleFont);
  text(splashTitle,width/2,height*.2);
  
  textFont(medFont);
  text(splashText,width/2,height*.61);
  
  fill(0);
  rect(0,0,width,splashFade/10.0*height/2);
  rect(0,height-splashFade/10.0*height/2,width,splashFade/10.0*height/2);
  
  if(splashFade > 30){
    switch(splashThen){
    case -2:
      setupMM();
      setupMMSlow(0,0);
      break;
    case -1:
      setupMMSlow(splashScoreA,splashScoreB);
      break;
    case 0:
      setupTravel();
      break;
    case 1:
      setupRead();
      break;
    case 2:
      setupGarden();
      break;
    case 3:
      setupWrite();
      break;
    case 100:
      break;
  }
  }
}

void mousePressedSplash(){
  splashFade = 1;
}
int frame;
PImage travelMask;
int travelLineH = 80;

PImage travelBG;
String travelLines[];
int travelActions[];

boolean lastIsNew = false;
boolean lastWasGood = false;
float lastFade = 0;

int bgCycle = (int)random(3);
int travelTextCycle = (int)random(7);

float travelScore = 0;

void setupTravel(){
  mode = 0;
  frame = -50;
  travelMask = loadImage("travelMask.png");
  travelScore = 0;
  
  travelBG = loadImage("travelBG"+bgCycle%3+".png");
  bgCycle++;
  
  travelLines = loadStrings("travelText"+travelTextCycle%7+".txt");
  travelTextCycle++;
  
  travelActions = new int[travelLines.length];
  for(int i = 0; i < travelLines.length; i++){
    if(travelLines[i].length() < 10){
      travelActions[i] = -1;
    }
  }
  int pos;
  int placed = 0;
  while(placed < 10){
    pos = (int) random(travelLines.length);
    if(travelActions[pos] == 0){
      placed++;
      travelActions[pos] = 1;
    }
  }
  while(placed < 20){
    pos = (int) random(travelLines.length);
    if(travelActions[pos] == 0){
      placed++;
      travelActions[pos] = 2;
    }
  }
}

void drawTravel(){
  frame++;
  textFont(travelFont);
  noStroke();
  if(frame < 0){
    fill(255,255,255,255/10);
    rect(0,0,width,height);
  } else {
    image(travelBG,0,-height/2000.0*frame,width,height*2);
    image(travelMask,0,0,width,height);
    if(frame < 50){
      fill(255,255,255,255-255/50.0*frame);
      rect(0,0,width,height);
    }
    if(frame > 1950){
      fill(255,255,255,255-255/50.0*(2000-frame));
      rect(0,0,width,height);
      if(frame > 2000){
        setupMMSlow((int)max(0,min(25,travelScore)),0);
      }
    }
    
    textAlign(CENTER,CENTER);
    float ypos, off;
    for(int i = 0; i < travelLines.length; i++){
      ypos = height-(travelLines.length*travelLineH+height)/2000.0*frame+travelLineH*i;
      if(travelActions[i] == 1){
        if(ypos < height/2){
          off = (height/2.0 - ypos)/(height/10)*255;
          lastFade = min((1-off/255.0)+.1,1);
          lastWasGood = true;
          lastIsNew = true;
          fill(0,255-off,0);
        } else {
          fill(0);
        }
      } else if(travelActions[i] == 2){
        if(ypos < height/2){
          off = (height/2.0 - ypos)/(height/10)*255;
          lastFade = min((1-off/255.0)+.1,1);
          lastWasGood = false;
          lastIsNew = true;
          fill(255-off,0,0);
        } else {
          fill(0);
        }
      } else {
        fill(0);
      }
      text(travelLines[i],width/2,ypos);
      
    }
    
  }
}

void mousePressedTravel(){
  if(lastIsNew){
    lastIsNew = false;
    if(lastWasGood){
      travelScore += 3*lastFade;
    } else {
      travelScore -= 3*lastFade;
    }
  }
}
PImage writeImg,writeMask;
float wOffX, wOffY, wBlockW;
boolean wGrid[][], wHand[][];
char wText[][];
boolean model[][][];
boolean future[][][];
int handW = 5;

float wpOffX, wpOffY, wpBlockW, wpPW;

boolean unprocessedClick = false;

int handx;
float handy;
float wFallSpeed;

int writeLine = (int)random(15);

void setupWrite(){
  wOffX = width*.04;
  wOffY = height*.18;
  wBlockW = width*.506*.1;
  
  wpOffX = width*.607;
  wpOffY = height*.83;
  wpBlockW = width*.073*(1.0/handW);
  wpPW = width*.093;
  
  mode = 3;
  writeImg = loadImage("writeImg.png");
  writeMask = loadImage("writeMask.png");
  
  wFallSpeed = .01;
  wGrid = new boolean[10][10];
  
  wText = new char[10][10];
  writeLine++;
  String[] writeLines = loadStrings("writeText.txt");
  for(int i = 0; i < 10; i++){
    for(int j = 0; j < 10; j++){
      wText[i][j] = writeLines[writeLine%writeLines.length].charAt(i+j*10);
    }
  }
  model = new boolean[5][handW][handW];
  
  model[0][2][0] = true;
  model[0][2][1] = true;
  model[0][2][2] = true;
  model[0][2][3] = true;
  
  model[1][2][1] = true;
  model[1][2][2] = true;
  model[1][3][2] = true;
  model[1][2][3] = true;
  
  model[2][2][1] = true;
  model[2][2][2] = true;
  model[2][2][3] = true;
  model[2][3][3] = true;
  
  model[3][2][1] = true;
  model[3][3][1] = true;
  model[3][2][2] = true;
  model[3][2][3] = true;
  
  model[4][1][1] = true;
  model[4][2][1] = true;
  model[4][1][2] = true;
  model[4][2][2] = true;
  
  future = new boolean[4][handW][handW];
  loadFutures(4);
  
  newHand();
}

void drawWrite(){
  image(writeImg,0,0,width,height);
  
  
  
  textFont(medFont);
  textAlign(CENTER,CENTER);
  stroke(0,50);
  strokeWeight(3);
  for(int i = 0; i < 10; i++){
    for(int j = 0; j < 10; j++){
      
      if(wGrid[i][j] && wText[i][j]==SPACE){
        fill(255,100,100);
      } else if(wGrid[i][j]) {
        fill(255);
      } else if(wText[i][j]==SPACE) {
        fill(100);
      } else {
        noFill();
      }
      rect(gridX(i),gridY(j),wBlockW,wBlockW);
      
      fill(0,100);
      text(wText[i][j],gridX(i)+wBlockW/2,gridY(j)+wBlockW/2);
      
    }
  }
  
  if(unprocessedClick){
    moveHand((int)blue(writeMask.get((int)(mouseX*1.0/width*writeMask.width),(int)(mouseY*1.0/height*writeMask.height))));
    unprocessedClick = false;
  } else {
    moveHand(255);
  }
  
  fill(255,100);
  for(int i = 0; i < handW; i++){
    for(int j = 0; j < handW; j++){
      if(wHand[i][j]){
        rect(gridX(i+handx),gridY(j+handy),wBlockW,wBlockW);
      }
    }
  }
  for(int k = 0; k < 4; k++){
    for(int i = 0; i < handW; i++){
      for(int j = 0; j < handW; j++){
        if(future[k][i][j]){
          rect(previewX(k,i),previewY(k,j),wpBlockW,wpBlockW);
        }
      }
    }
  }
  
}

void mousePressedWrite(){
  unprocessedClick = true;
  
  /*
  boolean wGrid3[][] = new boolean[10][10];
  boolean wGrid2[][] = new boolean[10][10];
  for(int i = 0; i < 10; i++){
    for(int j = 0; j < 10; j++){
      wGrid2[i][j] = wGrid[i][j];
    }
  }
  int col = (int)random(10);
  int startY = -1;
  for(int i = 0; i < 10; i++){
    if(wGrid2[col][i] == false && wText[col][i] != SPACE){
      startY = i;
    }
  }
  if(startY > -1){
    wGrid3[col][startY] = true;
  }
  
  int minx = 9,miny = 9,maxx = 0,maxy = 0;
  for(int i = 0; i < 10; i++){
    for(int j = 0; j < 10; j++){
      if(wGrid3[i][j]){
        minx = min(minx,i);
        miny = min(miny,i);
        maxx = max(maxx,i);
        maxy = max(maxy,i);
      }
    }
  }
  
  if(maxx-minx <= 1){
    minx--;
  }
  
  if(maxy-miny <= 1){
    miny--;
  }
  
  for(int i = 0; i < 4; i++){
    for(int j = 0; j < 4; j++){
      if(minx+i >= 0 && miny+j >= 0 && minx+i < 10 && miny+j < 10){
        wGrid[i][j] = wGrid3[minx+i][miny+j];
      }
    }
  }
  
  */
}


void moveHand(int pressed){
  boolean[][] newWHand;
  switch(pressed){
    case 0:
      //drop
      while(blocksCanBeAt(wHand,handx,handy+.5)){
        handy += .5;
      }
      solidifyBlocks(wHand,handx,handy);
      tryEndGame();
      newHand();
      break;
    case 1:
      //rotate left
      newWHand = rotateLeft(wHand);
      if(blocksCanBeAt(newWHand,handx,handy)){
        wHand = newWHand;
      } else if(blocksCanBeAt(newWHand,handx-1,handy)){
        wHand = newWHand;
        handx--;
      } else if(blocksCanBeAt(newWHand,handx+1,handy)){
        wHand = newWHand;
        handx++;
      }
      break;
    case 2:
      //rotate right
      newWHand = rotateRight(wHand);
      if(blocksCanBeAt(newWHand,handx,handy)){
        wHand = newWHand;
      } else if(blocksCanBeAt(newWHand,handx-1,handy)){
        wHand = newWHand;
        handx--;
      } else if(blocksCanBeAt(newWHand,handx+1,handy)){
        wHand = newWHand;
        handx++;
      }
      break;
    case 3:
      //left
      if(blocksCanBeAt(wHand,handx-1,handy)){
        handx--;
      }
      break;
    case 4:
      //right
      if(blocksCanBeAt(wHand,handx+1,handy)){
        handx++;
      }
      break;
  }
  
  if(blocksCanBeAt(wHand,handx,handy+wFallSpeed)){
    handy += wFallSpeed;
  } else {
    solidifyBlocks(wHand,handx,handy);
    tryEndGame();
    newHand();
  }
}
boolean blocksCanBeAt(boolean[][] blocks, int x, float yf){
  int y = (int) ceil(yf);
  for(int i = 0; i < blocks.length; i++){
    for(int j = 0; j < blocks[0].length; j++){
      if(blocks[i][j]){
        if(i+x < 0 || i+x >= 10 || j+y >= 10){
          return false;
        }
        if(j+y >= 0 && wGrid[i+x][j+y]){
          return false;
        }
      }
    }
  }
  return true;
}

void solidifyBlocks(boolean[][] blocks, int x, float yf){
  int y = (int) ceil(yf);
  for(int i = 0; i < blocks.length; i++){
    for(int j = 0; j < blocks[0].length; j++){
      if(blocks[i][j]){
        if(i+x >= 0 && i+x < 10 && j+y >= 0 && j+y < 10){
          wGrid[i+x][j+y] = true;
        }
      }
    }
  }
}

boolean[][] rotateRight(boolean[][] blocks){
  return rotateLeft(rotateLeft(rotateLeft(blocks)));
}

boolean[][] rotateLeft(boolean[][] blocks){
  boolean[][] newBlocks = new boolean[blocks.length][blocks.length];
  for(int i = 0; i < blocks.length; i++){
    for(int j = 0; j < blocks.length; j++){
      if(blocks[i][j]){
        newBlocks[j][blocks.length-i-1] = true;
      }
    }
  }
  return newBlocks;
}

void loadFutures(int n){
  for(int i = 4-n; i < 4; i++){
    future[i] = model[(int)random(5)];
    for(int j = (int)random(16); j > 0; j--){
      future[i] = rotateRight(future[i]);
    }
  }
}

void newHand(){
  handx = 3;
  handy = -8;
  wHand = future[0];//new boolean[4][4];
  future[0] = future[1];
  future[1] = future[2];
  future[2] = future[3];
  loadFutures(1);
  /*
  for(int i = 0; i < 4; i++){
    for(int j = 0; j < 4; j++){
      wHand[i][j] = model[(int)random(5)][i][j];
    }
  }*/
  for(int i = (int)random(16); i > 0; i--){
    wHand = rotateRight(wHand);
  }
}

void tryEndGame(){
  boolean[][] water = new boolean[10][10];
  for(int i = 0; i < 10; i++){
    floodBooleanGrid(water,wGrid,i,0);
  }
  int count = 0;
  for(int i = 0; i < 10; i++){
    for(int j = 0; j < 10; j++){
      if(water[i][j] && wText[i][j] != SPACE){
        count++;
      }
    }
  }
  if(count == 0){
    count = 0;
    for(int i = 0; i < 10; i++){
      for(int j = 0; j < 10; j++){
        if((wText[i][j] != SPACE && wGrid[i][j]) || (wText[i][j] == SPACE && !wGrid[i][j])){
          count++;
        }
      }
    }
    int score = min((int)(inspiration*1.0*count/100)+5,inspiration);
    setupMMSlow(-score,score);
  }
}

void floodBooleanGrid(boolean[][] water, boolean[][] walls, int x, int y){
  if(x >= 0 && y >= 0 && x < 10 && y < 10){
    if(!walls[x][y] && !water[x][y]){
      water[x][y] = true;
      floodBooleanGrid(water,walls,x+1,y);
      floodBooleanGrid(water,walls,x-1,y);
      floodBooleanGrid(water,walls,x,y+1);
      floodBooleanGrid(water,walls,x,y-1);
    }
  }
}


float gridX(float x){
  return x*wBlockW+wOffX;
}
float gridY(float y){
  return y*wBlockW+wOffY;
}
float previewX(int k, float x){
  return x*wpBlockW+wpOffX+k*wpPW;
}
float previewY(int k, float y){
  return y*wpBlockW+wpOffY;
}

