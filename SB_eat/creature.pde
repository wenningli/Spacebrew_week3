class Creature {

  Gif creature;
  float cX, cY;
  float velocityX, velocityY;

  void setup(PApplet _app) {
    cX = width/2;
    cY = height/2;
    imageMode(CENTER);
    creature = new Gif(_app, "creature.gif");
    creature.loop();
  }

  void draw() {
    image(creature, cX, cY);
  }
}

