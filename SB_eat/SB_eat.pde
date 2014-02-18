//instruction//
// 1. run 'SB_eat.pde' in Processing.
// 2. open 'SB_feed/index.html' in a web browser on your mobile device
// 3. visit http://spacebrew.github.io/spacebrew/admin/admin.html?server=sandbox.spacebrew.cc
// 4. connect the two 'point' nodes.
// 5. test on your phone

import spacebrew.*;
import gifAnimation.*;

Spacebrew sb;

//client
String host = "sandbox.spacebrew.cc";
String name = "little dinosaur";
String desc = "eat";

Creature c = new Creature();
ArrayList<Point> foods = new ArrayList<Point>(); // init arraylist of type Point
PImage food;

////////////////////////////////////////////////

void setup() {

  size(960, 720);

  sb = new Spacebrew(this);
  sb.addSubscribe("eat", "point");
  sb.connect( host, name, desc );

  c.setup(this);
  food=loadImage("food.png");
}

////////////////////////////////////////////////

void draw() {
  background(255);
  c.draw();
  smooth();

  if (foods.isEmpty()) 
    // incase:
    //1. no one give the creature foods 
    //2. the creature has finished eating all foods.
    //3. we call this function so the creature won't move
  {
    return;
  }

  // here we find the nearest food//
  float fShortestDist = Float.MAX_VALUE;  //assign a giant value for the distance
  int iNearest = 1000000; // food's index: 0, 1, 2, 3....1000000
  Point pNearest = new Point();

  for (int i = 0; i < foods.size(); ++i)
  {
    //iterate all food 
    Point p = foods.get(i); //function
    float distance = dist(c.cX, c.cY, p.pX, p.pY);

    //we look for the closest point(food) here
    if (distance <  fShortestDist)
    {
      fShortestDist = distance; //compare the distances
      pNearest.pX = p.pX;
      pNearest.pY = p.pY; 
      iNearest = i;  // which food is the nearest
    }

    image(food, p.pX, p.pY);
  } 

  if (fShortestDist <= 2)  
    // assign a number to determine if the creature hits the food
  {
    foods.remove(iNearest); //the creature eats the food. so we remove that index
  }

  // help the creature to get to its target
  // use normalize function to walk to the point
  c.velocityX = (pNearest.pX - c.cX) / fShortestDist;
  c.velocityY = (pNearest.pY - c.cY ) / fShortestDist; 

  c.cX += c.velocityX*4.0; // 4.0 is the creature's speed
  c.cY += c.velocityY*4.0;

  println("closest one is " + pNearest.pX + "," + pNearest.pY);
}

////////////////////////////////////////////////
// we control Processing from the web
// when Processing receives a point-message(x,y)
// we call this custom function and add a food image to that point
void onCustomMessage( String name, String type, String value ) {

  if ( name.equals( "eat" ) ) {

    String [] tokens = value.split(",");  // we need to seperate "x,y"  
    Point p = new Point(); 
    p.pX =  float(tokens[0]);
    p.pY =  float(tokens[1]);
    foods.add(p);   //add to food arraylist
  }
}

