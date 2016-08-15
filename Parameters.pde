class Parameters {
  Parameters() {
    Preset1();
    Preset2();
  }
  
  void Preset1() {
    N = 250;
    width = 800;
    height = 600;
    bgColor = color(255);
    textColor = color(0);
    linkStrokeWeightL1 = 0.4;
    linkStrokeWeightL2 = 0.1;
    linkColorL1 = color(230); // #3EBA2B;
    linkColorL2 = color(0);
    nodeColor = color(0);
    
    // Simulation parameters
    delta = 1.0;
    p_la = 0.05;
    p_ga = 0.0005;
    alpha = 6;
    p_nd = 0.001;
  }

  void Preset2() {
    bgColor = color(0);
    textColor = color(255);
    linkStrokeWeightL1 = 0.2;
    linkStrokeWeightL2 = 0.2;
    linkColorL1 = #3EBA2B;
    linkColorL2 = #E06A3B;
    nodeColor = color(255);
  }
  
  // Visualization parameters
  int N; // number of nodes
  int width, height; // display width and height
  color bgColor; // background color
  color textColor;  // text color
  float linkStrokeWeightL1, linkStrokeWeightL2; // base stroke weight for L1 and L2
  color linkColorL1, linkColorL2 ; // color of links in L1 and L2
  color nodeColor; // color of nodes
  
  // Simulation parameters
  float delta, p_la, p_ga, alpha, p_nd;
  // - increase amount of link weight during LA
  // - probability for Loal Attachment
  // - probability for Global Attachment
  // - exponent for the geographic effect
  // - probability of Node Deletion
}