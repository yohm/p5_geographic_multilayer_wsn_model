class Link {
  
  Node n1, n2;
  float weight;
  float stroke_weight;
  
  Link(Node _n1, Node _n2, float _weight) {
    n1 = _n1;
    n2 = _n2;
    weight = _weight;
    setStrokeWeight();
  }
  
  void strengthen(float dw) {
    weight += dw;
    setStrokeWeight();
  }

  void setStrokeWeight() {
    stroke_weight = 0.2*log(weight+1.0);
  }

  void display(int type, float w, float h) {
    float x1 = lerp( 0, w, n1.pos.x );
    float y1 = lerp( 0, h, n1.pos.y );
    float x2 = lerp( 0, w, n2.pos.x );
    float y2 = lerp( 0, h, n2.pos.y );
    // skip drawing if they cross boundary
    if( abs(x1-x2) > 0.5*w ) { return; }
    if( abs(y1-y2) > 0.5*h ) { return; }
    if( weight < 2 ) { return; }

    if( type == 1 ) {
      color c = color(230);  // #3EBA2B;
      stroke(c);
      float sw = 0.4*log(weight+1.0);
      strokeWeight(sw);
    }
    else if( type == 2 ) {
      color c = color(0);  // #E06A3B;
      stroke(c);
      float sw = 0.1*log(weight+1.0);
      strokeWeight(sw);
    }
    line(x1, y1, x2, y2);
  }
}