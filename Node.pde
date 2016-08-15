import java.util.Set;
import java.util.Map;
import java.util.Collection;

class Node {
  int id;
  HashMap<Integer,Link> m_edges1;
  HashMap<Integer,Link> m_edges2;
  float freshness;
  color original_color;
  color newborn_color;
  Position2D pos;

  Node(int _id, Position2D _pos) {
    id = _id;
    pos = _pos;
    m_edges1 = new HashMap<Integer,Link>();
    m_edges2 = new HashMap<Integer,Link>();
    freshness = 0.0;
    original_color = color(0,0,0);
    newborn_color = color(0,0,0);
  }

  void addEdge(Node node, Link link, int layer) {
    getEdges(layer).put(node.id, link);
  }

  Collection<Link> allLinks(int layer) {
    return getEdges(layer).values();
  }

  boolean hasEdge(Node node, int layer) {
    return (getEdges(layer).get(node.id) != null) ? true : false; 
  }

  Link getLinkTo(Node node, int layer) {
    return getEdges(layer).get(node.id);
  }

  void deleteEdge(Node node, int layer) {
    getEdges(layer).remove(node.id);
  }

  void clearEdge(int layer) {
    getEdges(layer).clear();
  }

  HashMap<Integer,Link> getEdges(int layer) {
    if( layer == 1 ) {
      return m_edges1;
    } else if( layer == 2 ) {
      return m_edges2;
    } else {
      println("must not happen");
      return null;
    }
  }

  int degree(int layer) {
    return getEdges(layer).size();
  }

  Link edgeSelection(Node node, int layer) {
    if( node == null && degree(layer) == 0 ) { return null; }
    if( node != null && degree(layer) < 1 ) { return null; }

    float w_sum = 0.0;
    HashMap<Integer,Link> edges = getEdges(layer);
    int id_to_skip = (node != null) ? node.id : -1;
    for( int nid : edges.keySet() ) {
      // if( node != null && nid == node.id ) { continue; }
      if( nid == id_to_skip ) { continue; }
      w_sum += edges.get(nid).weight;
    }
    float r = random(w_sum);
    Link ret = null;
    for( int nid : edges.keySet() ) {
      // if( node != null && nid == node.id ) { continue; }
      if( nid == id_to_skip ) { continue; }
      Link link = edges.get(nid);
      r -= link.weight;
      if( r <= 0.0 ) { ret = link; break; }
    }
    return ret;
  }

  void setNewBornColor() {
    freshness = 1.0;
  }

  void aging() {
    freshness -= 0.01;
  }

  void display(float w, float h) {
    color current_color = lerpColor(original_color, newborn_color, freshness);
    fill(current_color,150);
    stroke(current_color);
    strokeWeight(2);
    float x = lerp(0, w, pos.x);
    float y = lerp(0, h, pos.y);
    ellipse(x,y,4,4);
  }
}