class MyNode {
	int id;
	float x, y;
	float radius;
	boolean isect;	//insection test
	color fillcol;
	String name;
	int deviceType; //0: bridge, 1: LAN
	Vector velocity;	//node's velocity
	float mass;	//node's mass
	ArrayList<MyEdge> edges;	//node's linked edge
	ArrayList<MyNode> neighbors;	//node's neighbors

	MyNode(int id) {
		this.id = id;
		this.velocity = new Vector(0, 0);
		this.mass = 1.0;
		this.radius = 10;
		this.isect = false;
		this.fillcol = color(128, 128, 128);
		edges = new ArrayList<MyEdge>();
		neighbors = new ArrayList<MyNode>();
	}

	MyNode(int id, float x, float y) {
		this.id = id;
		this.velocity = new Vector(0, 0);
		this.mass = 1.0;
		this.x = x;
		this.y = y;
		this.radius = 10;
		this.isect = false;
		this.fillcol = color(128, 128, 128);
		edges = new ArrayList<MyEdge>();
		neighbors = new ArrayList<MyNode>();
	}

	public void setId(int id) {
		this.id = id;
	}
	public int getId() {
		return this.id;
	}

	public float getMass() {
		return this.mass;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getName() {
		return this.name;
	}

	public void setDeviceType(int deviceType) {
		this.deviceType = deviceType;
	}

	public int getDeviceType() {
		return this.deviceType;
	}
	public void setPosition(float x, float y) {
		this.x = x;
		this.y = y;
	}

	public float getX() {
		return this.x;
	}

	public float getY() {
		return this.y;
	}

	public void setVelocity(flaot x, float y) {
		this.velocity.setXY(x, y);
	}

	public void setVelocity(Vector other) {
		this.velocity.setVector(other);
	}

	public Vector getVelocity() {
		return this.velocity;
	}

	public void setRadius(float radius) {
		this.radius = radius;
	}

	public float getRadius() {
		return this.radius;
	}

	public void addEdge(MyEdge e){
		this.edges.add(e);
	}

	public void addNeighbors(MyNode node) {
		this.neighbors.add(node);
	}

	public boolean containNeb(int id) {
		for(int i = 0; i < this.neighbors.size(); i++) {
			MyNode tmpNode = this.neighbors.get(i);
			if( id == tmpNode.getId()){
				return true;
			}
		}
		return false;
	}

	public boolean containNeb(String name) {
		for(int i = 0; i < this.neighbors.size(); i++) {
			MyNode tmpNode = this.neighbors.get(i);
			if( name.equals(tmpNode.getName())) {
				return true;
			}
		}
		return false;
	}

	public ArrayList<MyEdge> getEdges() {
		return this.edges;
	}

	public ArrayList<MyNode> getNeighbors() {
		return this.neighbors;
	}

	public void printNebs() {
		for (MyNode tmpNode: neighbors) {
			println(tmpNode.getId() + ": " + tmpNode.getName());
		}
	}

	public void printEdges() {
		for (MyEdge e : edges) {
			println(e.getOriginalLen());
		}
	}

	public void isectTest() {
		float dist = sqrt( (mouseX - this.x) * (mouseX - this.x) + (mouseY - this.y) * (mouseY - this.y));
		if( dist > this.radius) {
			this.isect = false;
		} else {
			this.isect = true;
		}
	}

	public boolean getIsect() {
		return this.isect;
	}

	public void setFillcol( color fillcol) {
		this.fillcol = fillcol;
	}

	public void render() {
		strokeWeight(1);
		if(this.isect) {
			color c = #FF4900;
			stroke(0);
			fill(c);
		} else {
			stroke(0);
			fill(this.fillcol);
		}
  		ellipse(x,y, radius*2,radius*2);
  		textFont(font);
  		textAlign(CENTER, CENTER);
  		fill(0);	
  		text(name, x, y);
	}
}
