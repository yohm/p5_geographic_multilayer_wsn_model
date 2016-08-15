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
    stroke_weight = log(weight+1.0);
  }

  void display(int type, Parameters param) {
    float w = param.width;
    float h = param.height;
    float x1 = lerp( 0, w, n1.pos.x );
    float y1 = lerp( 0, h, n1.pos.y );
    float x2 = lerp( 0, w, n2.pos.x );
    float y2 = lerp( 0, h, n2.pos.y );
    // skip drawing if they cross boundary
    if( abs(x1-x2) > 0.5*w ) { return; }
    if( abs(y1-y2) > 0.5*h ) { return; }

    if( type == 1 ) {
      stroke( param.linkColorL1 );
      float sw = param.linkStrokeWeightL1 * stroke_weight;
      strokeWeight(sw);
    }
    else if( type == 2 ) {
      stroke( param.linkColorL2 );
      float sw = param.linkStrokeWeightL2 * stroke_weight;
      strokeWeight(sw);
    }
    line(x1, y1, x2, y2);
  }
}