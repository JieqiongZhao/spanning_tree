//global variables
int screen_width = 1000;
int screen_height = 600;
ArrayList<MyNode> nodelist;
int bridgeNum = 7;
int lanNum = 11;
float bridgeRadius = 15;
float lanRadius = 15;
color bridgeCol = #7AE969;
color lanCol = #63ADD0;
String[] letters = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
PFont font;
// @pjs preload must be used to preload the image
/* @pjs preload="./images/cloud.png" */
String lanImageFilename = "./images/cloud.png";
// @pjs preload must be used to preload the image
/* @pjs preload="./images/cloud_clicked.png" */
String lanHoverImageFilename = "./images/cloud_clicked.png";
// PImage lanImage;
String[20][2] links = {{"B1", "D"}, {"B1", "E"}, {"B1", "F"}, {"B1", "G"}, {"B1", "H"}, 
					{"B2", "C"}, {"B2", "E"}, {"B3", "A"}, {"B3", "C"}, {"B4", "H"},
					{"B4", "I"}, {"B4", "J"}, {"B5", "A"}, {"B5", "B"}, {"B5", "D"},	
					{"B6", "G"}, {"B6", "I"}, {"B7", "B"}, {"B7", "F"}, {"B7", "K"}};

//constant
float Ks = 20;  //spring constant
float Kd = 0.5;  //damping constant
float Kr = 500000;  //repulsion constant
float Kt = 0.5;  //minimum energy constant
float timestep = 0.2;
float radius = 10;
boolean mouseDrg = false;
float total_kinetic_energy = 1.0;
float springLength = 40;

boolean graph_init = false; //initialization finished or not
boolean convergence = false; //whether the distributed spanning tree algorithm finished or not


void setup() {
	size(screen_width, screen_height);
	// lanImage = loadImage(lanImageFilename, "png");
	font = createFont("Geogia", 15, true);
	nodelist = new ArrayList<MyNode>();
	initNetworkTopology();
	frameRate(200);

	//test BPDU
	// BPDU p1 = new BPDU("B1", 2, "B2");
	// BPDU p2 = new BPDU("B1", 2, "B5");
	// int compareResult = p1.compare(p2);
	// println("Compare Result of BPDU: " + compareResult);

	// int compareResult = p1.compareStringIgnoreCase("1d", "abc");
	// println("Compare Result of Tow Strings: " + compareResult);
}

void draw() {
	background(250);
	drawEdges(new ArrayList<MyNode>(), nodelist.get(0));
  	drawNodes();

  	if(total_kinetic_energy > Kt) {
  		//cdlculate force/verlocity/ect and update postion of all nodes
  		dynamicMove();
  	} else {
  		if (convergence) {
  			console.log("-------------");
  		} else {
	  		graph_init = true;
	  		frameRate(60);
	  		//nodelist.get(0).sendBPDU();
	  		if(checkConvergence()) {
	  			convergence = true;
	  		}
	  	}
  	}


}

//initalize the topology of network graph
void initNetworkTopology() {
	//init brideges
	for(int i = 0; i  < bridgeNum; i++) {
		MyNode newNode = new Bridge(i);
		newNode.setDeviceType(0);
		int nameid = i + 1;
		String name = "B" + nameid;
		newNode.setName(name);
		if( i == 0) {
			newNode.setPosition( screen_width*0.5, screen_height*0.5);
		} else {
			newNode.setPosition(random(0,screen_width-1),random(0,screen_height-1));
		}
		newNode.setRadius(bridgeRadius);
  		newNode.setFillcol(bridgeCol);
		nodelist.add(newNode);
	}
	//init LAN
	int index = 0;
	for(int i = bridgeNum; i < (lanNum + bridgeNum); i++) {
		Lan newNode = new Lan(i);
		newNode.setDeviceType(1);
		newNode.setName(letters[index]);
		newNode.setPosition(random(0,screen_width-1),random(0,screen_height-1));
		newNode.setRadius(lanRadius);
		newNode.loadLanImage(lanImageFilename);
		newNode.loadLanHoverImage(lanHoverImageFilename);
  		newNode.setFillcol(lanCol);
		nodelist.add(newNode);
		index++;
	}
	//setup the neighbors
	for (int i = 0; i < links.length; i++) {
		MyNode tmpNode1 = getNodeByName(links[i][0]);
		MyNode tmpNode2 = getNodeByName(links[i][1]);
		tmpNode1.addNeighbors(tmpNode2);
		tmpNode1.addEdge(new MyEdge(springLength));
		tmpNode2.addNeighbors(tmpNode1);
		tmpNode2.addEdge(new MyEdge(springLength));
	}

	//init BPDU packages
	for (MyNode tmpNode : nodelist) {
		if(tmpNode.getDeviceType() == 0) {
			tmpNode.initBPDU();
		}
	}

}

MyNode getNodeById(int id) {
	for (MyNode tmpNode : nodelist) {
		if(id == tmpNode.getId()) {
			return tmpNode;
		}
	}
	return null;
}

MyNode getNodeByName(String name) {
	for (MyNode tmpNode : nodelist) {
		if(name.equals(tmpNode.getName())) {
			return tmpNode;
		}
	}
	return null;
}

boolean checkConvergence() {
	boolean converged = true;
	for (MyNode tmpNode : nodelist) {
		if (tmpNode.getDeviceType() == 0) {
			if (!tmpNode.getConverge()) {
				converged = false;
			}
		}
	}
	return converged;
}

void drawNodes() {
  	for(int i = 0; i < nodelist.size(); i++) {
    	nodelist.get(i).render();
  	}
}

void drawEdges(ArrayList<MyNode> visited, MyNode node) {
	visited.add(node);
	ArrayList<MyNode> nebs = node.getNeighbors();
	ArrayList<MyEdge> edges = node.getEdges();
	int s = nebs.size();
	if( s > 0) {
		for (int i = 0; i < s; i++) {
			Vector v = new Vector(node.getX(), node.getY(), nebs.get(i).getX(), nebs.get(i).getY());
			v.vNormalization();
			float radius = node.getRadius();
			v.vScale(radius);
			float x1 = node.getX() + v.getX();
			float y1 = node.getY() + v.getY();
			Vector vr = new Vector(nebs.get(i).getX(), nebs.get(i).getY() ,node.getX(), node.getY());
			vr.vNormalization();
			radius = nebs.get(i).getRadius();
			vr.vScale(radius);
			float x2 = nebs.get(i).getX() + vr.getX();
			float y2 = nebs.get(i).getY() + vr.getY();
			if(edges.get(i) != null) {
				// if (node.getDeviceType() == 1 && nebs.get(i).getDeviceType() == 0) {
				// 	edges.get(i).setBlock(true);
				// }
				edges.get(i).setPosition(x1, y1, x2, y2);
				edges.get(i).render();
			}
			if(visited.contains(nebs.get(i))) {
				continue;
			} else {
				drawEdges(visited, nebs.get(i));
			}
			
		}
	}

}

void dynamicMove() {
  	total_kinetic_energy = 0;
  	//for each node
	for(int i = 0; i < nodelist.size(); i++){
	MyNode node = nodelist.get(i);
	//if(!node.getDragged()) {    
	  	Vector net_force = new Vector(0,0);
	  	//for each other node
	  	for(int j = 0; j < nodelist.size(); j++) {
	    	if(j != i ){
	      		net_force.vAddition(coulomb_repulsion(node,nodelist.get(j)));
	    	}
		}

		// println("repulsion force: " + net_force.vLength());
	  
	  	//for each spring connected to this node
	  	ArrayList<MyNode> nebs = node.getNeighbors();
	  	ArrayList<MyEdge> edges = node.getEdges();

	  	// println("neighbor size: " + nebs.size());
	  	// println("edges size: " + edges.size());
	  	int s = nebs.size();
	  	if(s>0){
	    	for(int k = 0; k < s; k++){
	      		MyEdge spring = edges.get(k);
	      		net_force.vAddition(hooke_attraction(node, edges.get(k), nebs.get(k)));
	    	}
	  	}

	  	// println("hooke attraction force: " + net_force.vLength());
	  
	  	//update velocity
	  	Vector oldVelocity = node.getVelocity();
	  	net_force.vScale(timestep);
	  	oldVelocity.vAddition(net_force);
	  	oldVelocity.vScale(Kd);
	  	total_kinetic_energy += 0.5*node.getMass()*sq(oldVelocity.vLength());
	// } else {
	// 	//      println(node.getId());
	// }
	}
    //update position
    for(int i = 1; i < nodelist.size(); i++) {
		MyNode node = nodelist.get(i);
		Vector vel = node.getVelocity();
		float px = node.getX();
		float py = node.getY();
		px += timestep*vel.getX();
		py += timestep*vel.getY();
		node.setPosition(px,py);
		// println(node.getName() + ": " + px + ", " + py);
    }

    //println("total_kinetic_energy: " + total_kinetic_energy);
}

//calculate the repulsion force
Vector coulomb_repulsion(MyNode node, MyNode other) {
	float x1 = node.getX();
	float y1 = node.getY();
	float x2 = other.getX();
	float y2 = other.getY();
	float fx = x1 - x2;
	float fy = y1 - y2;
	Vector repf = new Vector(fx,fy);
	repf.vNormalization();
	float magnitude = Kr/(fx*fx+fy*fy);
	repf.vScale(magnitude);
	return repf;
}

Vector hooke_attraction(MyNode node, MyEdge spring, MyNode neighbor) {
	float origLen = spring.getOriginalLen();
	float curLen = spring.getCurrentLen();
	// println("spring origLen: " + origLen);
	// println("spring curLen: " + curLen);
	if(origLen > curLen) {
		float dif = origLen - curLen;
		float x1 = node.getX();
		float y1 = node.getY();
		float x2 = neighbor.getX();
		float y2 = neighbor.getY();
		float fx = x1 - x2;
		float fy = y1 - y2;
		Vector spf = new Vector(fx,fy);
		spf.vNormalization();
		float magnitude = Ks*dif*0.5;
		spf.vScale(magnitude);
		// println("hooke_attraction: " + spf.vLength());
		return spf;
	} else {
		float dif = curLen - origLen;
		float x1 = node.getX();
		float y1 = node.getY();
		float x2 = neighbor.getX();
		float y2 = neighbor.getY();
		float fx = x2 - x1;
		float fy = y2 - y1;
		Vector spf = new Vector(fx,fy);
		spf.vNormalization();
		float magnitude = Ks*dif*0.5;
		spf.vScale(magnitude);  
		// println("hooke_attraction: " + spf.vLength());
		return spf;  
	}
}
/****************************************************/
//mouse interactions
/****************************************************/
void mouseMoved(){
  	for(int i = 0; i < nodelist.size(); i++) {
    	nodelist.get(i).isectTest();
  	}
}

void mouseDragged() {
	if(graph_init) {
		for (MyNode tmpNode : nodelist) {
			if(tmpNode.getIsect()) {
				tmpNode.setPosition(mouseX, mouseY);
				// if (tmpNode.getDeviceType() == 0) {
				// 	tmpNdde.updateInitBPDU();
				// }
			}
		}
	}
}

void mouseClicked() {
	if (graph_init) {
		for (MyNode tmpNode : nodelist) {
			if(tmpNode.getDeviceType() == 0) {
				//bridge
				tmpNode.setSendStatus(true);
			}
		}
	}
 }




