/*Written by Tristan Blus, started 3/19/2022
      revised 3/22/2022
      revised 3/24/2022 -- Renamed "Building Roots"

OUTDATED FILES: GP.Java and Root.Java are currently inactive files which I hope to use to create path objects in time

a number of improvements must be made from this point.  There need to be significantly more path types and they need to be ordered such that swaping up or
down by an increment of 1 will create a smooth curve.  This will make the swap function work significatnly better to create fewer hard angles and instead
gently curve the roots as they grow.  Further improvements are as follows:
    Find a way to continue a current path and spawn a second path from this path to branch
    limit ranges of random path swaps to prevent the zig zag problem.  
    Play with the framerate and swap threshholds to find the most root-like appearance.  
    Simplify global variables section and privatize any variables which can be privatized
    find a way to reduce the number of repetitive calls in draw
    Improve draw to allow for a variable number of paths rather than a constant 4
    Convert all paths to path objects
There are many further improvements to be made which I have not yet taken the time to assess

*/

import java.util.*;

//GLOBALS

int horiz_size = 1000;
int vert_size = 800;

int x = 500;
int y = 400;
int q = 500;
int p = 400;
int s = 500 - int(random(50));
int t = 400;
int v = 500 + int(random(50));
int w = 400;

int pathA = int(random(12));
int pathB = int(random(12));
int pathC = int(random(12));
int pathD = int(random(12));

boolean forward = true;
boolean down = true;

int count = 0;
//END GLOBALS

/* Enum represents growth paths, D stands for down, L for left, R for right.  As we get in to letter repeats the only difference with pathing is the degree / speed
of growth */

enum GP {
  DL(0),
  LD(1),
  DSL(2),
  DR(3),
  RD(4),
  DSR(5),
  DRR(6),
  DLL(7),
  DDRR(8),
  DDLL(9),
  DDDLLL(10),
  DDDRRR(11);
  
  int value;
  static Map map = new HashMap<>();
  
  GP(int value) {
        this.value = value;
  }
  static {
        for (GP path : GP.values()) {
            map.put(path.value, path);
        }
  }
  static GP valueOf(int path) { 
        return (GP) map.get(path);
  }
}
//END ENUM


void setup() { 
  /*This function sets up the window and fill colors of the window, and objects within it, and also changes the framerate
    
    PARAMETERS:: NONE
    
    RETURNS:: NONE
  */
  size(1000, 800); 
  background(0); 
  frameRate(1);
  fill(100, 120, 100);
  
  rect(467.5, 150, 55, 250, 10, 10, 17, 22);

}

void draw() { 
  /*This function executes as many times per second as the framerate indicates, it collects each path, and draws a single point (either a 1 or a 0) along that path
  
    PARAMETERS:: NONE
  
    RETURNS:: NONE
  */
  GP xx = GP.valueOf(pathA);
  GP qq = GP.valueOf(pathB);
  GP tt = GP.valueOf(pathC);
  GP vv = GP.valueOf(pathD); 
  
  int[] xy = drawHelp(x, y, xx);
  int[] qp = drawHelp(q, p, qq);
  int[] st = drawHelp(s, t, tt);
  int[] vw = drawHelp(v, w, vv);
  
  update(outOfRange(xy), 0);
  update(outOfRange(qp), 1);
  update(outOfRange(st), 2);
  update(outOfRange(vw), 3);
  
  float rand = random(4);
  if (rand < 1.5){
    forward = false;
  }
  if (rand > 1.5 && rand < 3 ){
    down = false;
  }else{
    forward = true;
    down = true;
  }
  count += 1;
  if (count == 20){
    pathA = swapPath(count, pathA);
  }else if (count == 40){
    pathB = swapPath(count, pathB);
  }else if (count == 60){
    pathC = swapPath(count, pathC);
  }else if (count == 80){
    pathD = swapPath(count, pathA);
  }else if (count > 100){
    pathA = int(random(12));
    pathB = int(random(12));
    pathC = int(random(12));
    pathD = int(random(12));
    count = 0;
  }
}


int[] drawHelp(int x, int y, GP path){
  /*This is the function which does the actual drawing of 1s and 0s, it is called repeatedly in draw.  
    It also sets the coordinates for the next object along that path
    
    PARAMETERS:: 
      INTEGER: x
        The x coordinate to be drawn at
      INTEGER: y
        The y coordinate to be drawn at
      GrowthPath: path
        The path along which the coordinates are currently being placed at call time
    
    RETURNS:: 
      INTEGER ARRAY: drawHelp 
        Contains and X and Y values for the next placement
  */
  int is0 = int(random(2));
  if (is0 == 0){
    text("0", x, y);
  }else{text("1", x, y);}
  /*this section needs major expansion, the way to improve this project is by adding significantly more combinations of random numbers to work with.*/
  int randlrg = int(random(10, 15));
  int randmed = int(random(4, 9));
  int randsml = int(random(0, 4));
  
  x = newCoord(x, path, true, randlrg, randsml, randmed);
  y = newCoord(y, path, false, randlrg, randsml, randmed);
  return new int[]{x, y};
}


int newCoord(int coord, GP x, boolean isX, int lrg, int sml, int med){
  /*This function takes many parameters all used to change a set of coordinates to the next point along a given growth path
    
    PARAMETERS :: 
      INTEGER: coord 
        the coordinate to be changed
      GrowthPath: x
        the current growth path of the coordinate to be changes
      BOOLEAN: isX
        tells the function if the given coordinate is considered an X coordinate
      INTEGER: lrg
        large random integer
      INTEGER: sml
        small random integer
      INTEGER: med
        medium random integer
    
    RETURNS:: 
      INTEGER: newCoord
        the newly updated coordinate value
  */
  if (x == GP.DL){
    if (isX){
      coord -= random(sml);
    }else{
      coord += random(lrg);
    }
  }else if (x == GP.DR){
    if (isX){
      coord += random(sml);
    }else{
      coord += random(lrg);
    }
  } else if (x == GP.LD){
    if (isX){
      coord -= random(med);
    }else{
      coord += random(sml);
    }
  }else if (x == GP.RD){
    if (isX){
      coord += random(med);
    }else{
      coord += random(sml);
    }
  }else if (x == GP.DRR){
    if (isX){
      coord += random(lrg);
    }else{
      coord += random(sml);
    }
  }else if (x == GP.DLL){
    if (isX){
      coord -= random(lrg);
    }else{
      coord += random(sml);
    }
  }else if (x == GP.DSL){
    if (isX){
      coord -= random(med);
    }else{
      coord += random(lrg);
    }
  }else if (x == GP.DSR){
    if (isX){
      coord += random(med);
    }else{
      coord += random(lrg);
    }
  }else if (x == GP.DDLL){
    if (isX){
      coord -= random(med);
    }else{
      coord += random(med);
    }
  }else if (x == GP.DDRR){
    if (isX){
      coord += random(med);
    }else{
      coord += random(med);
    }
  }else if (x == GP.DDDLLL){
    if (isX){
      coord -= random(med);
    }else{
      coord += random(med);
    }
  }else if (x == GP.DDDRRR){
    if (isX){
      coord += random(lrg);
    }else{
      coord += random(lrg);
    }
  }
  return int(coord);
}
int[] outOfRange(int[] xy){
  /*The function takes an integer array xy which contains a set or coordinates.  It checks them against size limits of the window and returns the path
    to the origin point at (500,400)
    
    PARAMETERS:: 
      INTEGER ARRAY: xy
        Contains the coordinates to be checked for range
        
    RETURNS:: 
      INTEGER ARRAY: outOfRange
        If the coordinates are out of range of the screen they reset back to the origin point, and the origin point is returned as the new coordinates
  */
  int x = xy[0];
  int y = xy[1];
  
  if (x > horiz_size || y > vert_size || x < 0 || y < 0){
    //x = int(random(horiz_size));
    //y = int(random(vert_size));
    x = 500;
    y = 400;
    forward = false;
    down = false;
  }
  return new int[] {x, y};
}
int swapPath(int c, int path){
  /*Swaps the current integer representation of the current Growth Path to the next or previous integer
  
    PARAMETERS::
      INTEGER: c (count)
        The count of draws completed since last reset of count
      INTEGER: path
        The integer representation of the current path
    
    RETURNS:: 
      INTEGER: swapPath
        The integer representation of the incremented/decremented Growth Path
  */
  if (path > 6){
    path -= 1;
  }if (path > 0) {
    path += 1;
  }else{
    path += 1;
  }
  return path;
}

void update(int[] ab, int swap){
  /*PARAMETERS:: 
    RETURNS:: NONE*/
  int a = ab[0];
  int b = ab[1];
  switch (swap){
    case 0: x = a;
            y = b;
            break;
    case 1: q = a;
            p = b;
            break;
    case 2: s = a;
            t = b;
            break;
    case 3: v = a;
            w = b;
            break;
    default: break;
  }
}