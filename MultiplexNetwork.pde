class MultiplexNetwork {
  // A cluster is a grouping of nodes
  ArrayList<Node> m_nodes;
  ArrayList<Link> m_links1;
  ArrayList<Link> m_links2;
  int time_step;
  Parameters m_param;

  MultiplexNetwork( Parameters param ) {

    // Initialize the ArrayList
    m_nodes = new ArrayList<Node>();
    m_links1 = new ArrayList<Link>();
    m_links2 = new ArrayList<Link>();
    time_step = 0;
    m_param = param;

    // Create the nodes
    for (int i = 0; i < m_param.N; i++) {
      // We can't put them right on top of each other
      float x = random(1.0);
      float y = random(1.0);
      Node node = new Node(i, new Position2D(x,y));
      m_nodes.add(node);
    }
  }

  // Draw all nodes
  void showNodes() {
    for( Node n : m_nodes ) {
      n.display( m_param );
    }
  }

  ArrayList<Link> getLinks(int layer) {
    if( layer == 1 ) {
      return m_links1;
    } else if( layer == 2 ) {
      return m_links2;
    } else {
      println("must not happen");
      return null;
    }
  }

  // Draw all the internal connections
  void showLinks( int layer ) {
    if( layer == 1 ) {
      for( Link l: getLinks(1) ) {
        l.display(1, m_param);
      }
    }
    else if( layer == 2 ) {
      for( Link l: getLinks(2) ) {
        l.display(2, m_param);
      }
    }
    else {
      for( Link l: getLinks(1) ) {
        l.display(1, m_param);
      }
      for( Link l: getLinks(2) ) {
        l.display(2, m_param);
      }
    }
  }

  void Print(PrintWriter writer) {
    for( Link l : getLinks(1) ) {
      writer.println(String.valueOf(l.n1.id) + " " + String.valueOf(l.n2.id) + " " + String.valueOf(l.weight));
    }
    for( Link l : getLinks(2) ) {
      writer.println(String.valueOf(l.n1.id) + " " + String.valueOf(l.n2.id) + " " + String.valueOf(l.weight));
    }
  }

  Link addLink(Node ni, Node nj, int layer) {
    float init_weight = 1.0;
    Link l = new Link(ni, nj, init_weight);
    getLinks(layer).add(l);
    ni.addEdge(nj, l, layer);
    nj.addEdge(ni, l, layer);
    return l;
  }

  void strengthenLink(Link link) {
    link.strengthen( m_param.delta );
  }

  void removeLinksOfNode(Node node, int layer) {
    for( Link l : node.allLinks(layer) ) {
      Node pair = ( l.n1.id == node.id ) ? l.n2 : l.n1;
      pair.deleteEdge(node, layer);
      getLinks(layer).remove(l);
    }
    node.clearEdge(layer);
  }

  void updateNetwork(int layer) {
    int action = time_step % 3;
    for( Node node : m_nodes ) {
      if( action == 0 ) { LA(node, layer);}
      else if( action == 1 ) { GeographicGA(node, layer); }
      else if( action == 2 ) { ND(node, layer); }
    }

    time_step += 1;
  }

  void LA(Node ni, int layer) {

    if( ni.degree(layer) == 0 ) { return; }
    Link l_ij = ni.edgeSelection(null, layer);
    if( l_ij == null ) { println("must not happen"); throw new RuntimeException("foo"); }
    strengthenLink(l_ij);

    Node nj = (l_ij.n1.id == ni.id) ? l_ij.n2 : l_ij.n1;
    if( nj.degree(layer) == 1 ) { return; }
    Link l_jk = nj.edgeSelection(ni, layer);
    if( l_jk == null ) { println("must not happen"); throw new RuntimeException("foo"); }
    strengthenLink(l_jk);

    Node nk = (l_jk.n1.id == nj.id) ? l_jk.n2 : l_jk.n1;
    Link l_ik = ni.getLinkTo(nk, layer);
    if( l_ik == null ) {
      if( random(1.0) < m_param.p_la ) {
        addLink(ni, nk, layer);
      }
    }
    else {
      strengthenLink(l_ik);
    }
  }

  void GA(Node ni, int layer) {
    if( ni.degree(layer) > 0 && random(1.0) > m_param.p_ga ) { return; }
    int j = int(random(m_nodes.size()-1));
    if( j >= ni.id ) { j += 1; }
    Node nj = m_nodes.get(j);
    if( ! ni.hasEdge(nj, layer) ) {
      addLink(ni, nj, layer);
    }
  }
  
  void GeographicGA( Node ni, int layer ) {
    if( ni.degree(layer) > 0 && random(1.0) > m_param.p_ga ) { return; }

    int i = ni.id;
    float[] probs = new float[ m_nodes.size() ];
    float probs_sum = 0.0;
    for( int j=0; j<m_nodes.size(); j++) {
      Node nj = m_nodes.get(j);
      if( j == i ) { probs[j] = 0.0; }
      else if( ni.hasEdge( nj, layer ) ) { probs[j] = 0.0; }
      else {
        float d = nj.pos.Distance(ni.pos);
        probs[j] = pow(d, -m_param.alpha);
        probs_sum += probs[j];
      }
    }

    float r = random(probs_sum);
    for( int j=0; j<m_nodes.size(); j++) {
      r -= probs[j];
      if( r <= 0.0 ) {
        Node nj = m_nodes.get(j);
        addLink(ni, nj, layer);
        break;
      }
    }
    if( r > 0.0 ) {
      println("!!! positive r is detected");
    }
  }

  void ND(Node ni, int layer) {
    if( random(1.0) > m_param.p_nd ) { return; }

    removeLinksOfNode(ni, layer);
  }

  float calcAverageDegree() {
    return 2.0 * float(m_links1.size()) / m_nodes.size();  // [TODO] layer2
  }

  float calcCC() {
    float sum = 0.0;
    for( Node n : m_nodes ) {
      sum += calcLocalCC(n);
    }
    return sum / m_nodes.size();
  }
  float calcLocalCC(Node n) {  // [TODO] layer2
    int k = n.degree(1);
    if( k <= 1 ) { return 0.0; }
    float connected = 0.0;
    Set<Integer> neighbors = n.m_edges1.keySet();
    for( int i : neighbors ) {
      for( int j : neighbors ) {
        if( i < j ) continue;
        connected += m_nodes.get(i).hasEdge(m_nodes.get(j), 1) ? 1.0 : 0.0;
      }
    }
    float localCC = connected * 2.0 / (k*(k-1));
    return localCC;
  }

  float calcAverageWeight() {  // [TODO] layer2
    float sum = 0.0;
    for( Link l : m_links1 ) { sum += l.weight; }
    return sum / m_links1.size();
  }
}