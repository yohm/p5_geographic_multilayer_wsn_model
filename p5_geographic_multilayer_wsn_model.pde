// Simulation based on Multilayer Weighted Social Network model
//   proposed by Murase et al. Phys.Rev.E (2014)
// (C) Yohsuke Murase 2014

MultiplexNetwork mnet;

// Boolean that indicates whether we draw connections or not
boolean showNodes = true;
boolean showLinks = true;
boolean writing = false;
int layerToShow = 3;
int showingLayer = layerToShow;

// Font
PFont f;

float g_averageDegree = 0.0;
float g_CC = 0.0;
float g_averageWeight = 0.0;

void setup() {
  size(800, 600);
  f = createFont("Arial", 18, true);
  textFont(f);

  mnet = new MultiplexNetwork(250, (float)width, (float)height);
}

void draw() {
  // layerToShow = (frameCount / 300) % 3 + 1;
  layerToShow = 3;
  mnet.updateNetwork(1);
  mnet.updateNetwork(2);

  background(255);

  if (showNodes) {
    mnet.showNodes();
  }

  if (showLinks) {
    mnet.showLinks(layerToShow);
  }

  if( writing ) {
    PrintWriter writer = createWriter("net_proc.edg");
    mnet.Print(writer);
    writing = false;
  }

  // calculate Stylized facts
  /*
  if( frameCount % 9 == 0 ) {
    g_averageDegree = cluster.calcAverageDegree();
    g_CC = cluster.calcCC();
    g_averageWeight = cluster.calcAverageWeight();
  }
  */

  // Print
  fill(1,1,1);
  String time = String.valueOf(frameCount/3);
  text("t = " + time, 10, 20);

  //if( frameCount % 3 == 0 ) {
    //saveFrame("frames/####.tif");
  //}
}

// Key press commands
void keyPressed() {
  if (key == 'l') {
    showLinks = showLinks ? false : true;
  }
  else if (key == 'n') {
    showNodes = showNodes ? false : true;
  }
  else if (key == 'o') {
    writing = true;
  }
  else if (key == '1') {
    layerToShow = 1;
  }
  else if (key == '2') {
    layerToShow = 2;
  }
  else if (key == '3') {
    layerToShow = 3;
  }
}