class Position2D {
  Position2D( float _x, float _y ) {
    x = _x;
    y = _y;
  }
  float x;
  float y;
  float Distance( Position2D other ) {
    float dx = abs( x - other.x);
    if( dx >= 0.5 ) { dx = 1.0 - dx; }
    float dy = abs( y - other.y);
    if( dy >= 0.5 ) { dy = 1.0 - dy; }
    return sqrt( dx*dx + dy*dy );
  }
};