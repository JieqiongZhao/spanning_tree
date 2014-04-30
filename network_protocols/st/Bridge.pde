class Bridge extends MyNode {
	ArrayList<ArrayList<BPDU>> sentoutPackages;
	BPDU currentPackage;
	ArrayList<BPDU> bestReceived; //best can receive and a timer for when received it
	ArrayList<MyNode> neighborBridge;
	boolean sendStatus, receiveStatus;
	ArrayList<BPDU> receivedPackage;
	boolean converge;
	ArrayList<MyEdge> blockedEdges;

	Bridge(int id) {
		super(id);
		sendStatus = true;
		receiveStatus = false;
		converge = false;
	}

	Bridge(int id, float x, float y) {
		super(id, x, y);
		sendStatus = true;
		receiveStatus = false;
		converge = false;
	}

	public void setSendStatus(boolean status) {
		this.sendStatus = status;
		// for (BPDU tmpBPDU : this.sentoutPackages) {
		// 	tmpBPDU.get(0).setSendStatus(status);
		// }
		//int i = 0;
		// for (MyNode node: this.neighbors) {
		// 	for (MyNode nextBridge : node.getNeighbors()) {
		// 		BPDU newPackage = new BPDU(this.currentPackage.getRootId(), this.currentPackage.getCost(), this.currentPackage.getBridgeId());
		// 		newPackage.setPosition(this.x, this.y);
		// 		this.sentoutPackages.get(i).add(newPackage);
		// 		++i;
		// 	}
		// }
		if (this.converge) {
			println(this.name);
			int i = 0;
			for (Bridge nextBridge :  this.neighborBridge) {
				if (this.currentPackage.getBridgeId().equals(nextBridge.getName()) || 
					nextBridge.getCurrentPackage().getBridgeId().equals(this.name)) {
					//forwarding bridge or receiving bridge
					BPDU newPackage = new BPDU(this.currentPackage.getRootId(), this.currentPackage.getCost(), this.name);
					newPackage.setPosition(this.x, this.y);
					this.sentoutPackages.get(i).add(newPackage);
				} 
				// else {
				// 	for (MyNode node : this.neighbors) {
				// 		for (MyNode nextNode : node.getNeighbors()) {
				// 			if (nextNode.getName().equals(nextBridge.getName())) {
				// 				MyEdge tmpEdge = new MyEdge(this.x, this.y, node.getX(), node.getY());
				// 				tmpEdge.setBlock(true);
				// 				this.blockedEdges.add(tmpEdge);
				// 			}
				// 		}
				// 	}

				// }
				++i;
			}
			
		} else {
			for (int i = 0; i < this.sentoutPackages.size(); ++i) {
				BPDU newPackage = new BPDU(this.currentPackage.getRootId(), this.currentPackage.getCost(), this.name);
				newPackage.setPosition(this.x, this.y);
				this.sentoutPackages.get(i).add(newPackage);
			}
		}
	}

	public void setReceiveStatus(boolean status) {
		this.receiveStatus = status;
	}

	public void setReceivedPackage(BPDU tmpBPDU) {
		BPDU newPackage = new BPDU(tmpBPDU.getRootId(), tmpBPDU.getCost()+1, tmpBPDU.getBridgeId());
		this.receivedPackage.add(newPackage);
	}

	public boolean getConverge() {
		return this.converge;
	}

	public BPDU getCurrentPackage() {
		return this.currentPackage;
	}

	// Bridge(int id, float x, float y, String name){
	// 	this.id = id;
	// 	this.x = x;
	// 	this.y = y;
	// 	this.name = name;
	// 	this.package = new BPDU(name, 0, null);
	// }
	public void initBPDU() {
		this.currentPackage = new BPDU(this.name, 0, this.name);
		this.receivedPackage = new ArrayList<BPDU>();
		this.sentoutPackages = new ArrayList<ArrayList<BPDU>>();
		this.neighborBridge = new ArrayList<MyNode>();
		this.bestReceived = new ArrayList<BPDU>();
		this.blockedEdges = new ArrayList<MyEdge>();
		for (MyNode node: this.neighbors) {
			for (MyNode nextBridge : node.getNeighbors()) {
				if (nextBridge.getId() != this.id ) {
					//BPDU newPackage = new BPDU(this.name, 0, this.name);
					//newPackage.setPosition(this.x, this.y);
					ArrayList<BPDU> tmpArray = new ArrayList<BPDU>();
					//tmpArray.add(newPackage);
					this.sentoutPackages.add(tmpArray);
					this.neighborBridge.add(nextBridge);
					BPDU newPackage = new BPDU(nextBridge.getName(), this.name);
					this.bestReceived.add(newPackage);
				}
			}
		}
	}

	//update the start location of send out BPDU based on the force linked graph
	public void updateInitBPDU() {
		for (BPDU tmpBPDU : this.sentoutPackages ) {
			tmpBPDU.setPosition(this.x, this.y);
		}
	} 

	public void sendBPDU() {
		int i = 0;
		// for (MyNode node: this.neighbors) {
		// 	if (!flag1) {
		// 		float cx = this.sentoutPackages.get(i).getX();
		// 		float cy = this.sentoutPackages.get(i).getY();

		// 		Vector start = new Vector(cx, cy);
		// 		Vector end = new Vector(node.getX(), node.getY());

		// 		if(this.sentoutPackages.get(i).move(start, end)){
		// 			flag1 = true;
		// 		}
		// 	}else{
		// 		for (MyNode nextBridge : node.getNeighbors()) {
		// 			if (nextBridge.getId() != this.id) {
		// 				float cx = this.sentoutPackages.get(i).getX();
		// 				float cy = this.sentoutPackages.get(i).getY();

		// 				Vector start = new Vector(cx, cy);
		// 				Vector end = new Vector(nextBridge.getX(), nextBridge.getY());

		// 				if(this.sentoutPackages.get(i).move(start, end)){
		// 					flag2 = true;
		// 				}
		// 			}
		// 		}

		// 	}

		// 	this.sentoutPackages.get(i).render();
		// 	++i;
		// }
		for (MyNode node: this.neighbors) {
			for (MyNode nextBridge : node.getNeighbors()) {
				if (nextBridge.getId() != this.id ) {
					// for (int j = 0; j < this.sentoutPackages.get(i).size(); ++j) {
					// 	Vector start = new Vector(this.x, this.y);
					// 	Vector mid = new Vector(node.getX(), node.getY());
					// 	Vector end = new Vector(nextBridge.getX(), nextBridge.getY());
					// 	this.sentoutPackages.get(i).get(j).move(start, mid, end);

					// 	if(!this.sentoutPackages.get(i).get(j).getArriveEnd()) {
					// 		if (this.sentoutPackages.get(i).get(j).getSendStatus()) {
					// 			this.sentoutPackages.get(i).get(j).render();
					// 		}
							
					// 	} else {
					// 		nextBridge.setReceiveStatus(true);
					// 		this.sentoutPackages.get(i).remove(j);
					// 		j--;
					// 		//this.sentoutPackages.get(i).get(j).setSendStatus(false);
					// 	}
					// }
					for (BPDU tmpBPDU : this.sentoutPackages.get(i)) {
						Vector start = new Vector(this.x, this.y);
						Vector mid = new Vector(node.getX(), node.getY());
						Vector end = new Vector(nextBridge.getX(), nextBridge.getY());
						tmpBPDU.move(start, mid, end);

						if (!tmpBPDU.getArriveEnd()) {
							if (tmpBPDU.getSendStatus()) {
								tmpBPDU.render();
							}
						} else {
							nextBridge.setReceiveStatus(true);
							nextBridge.setReceivedPackage(tmpBPDU);
							this.sentoutPackages.get(i).remove(tmpBPDU);
							//println(this.sentoutPackages.get(i).size());
						}
					}

					++i;
				}
			}

		}
	}

	public void showBPDU() {
		this.currentPackage.setPosition(this.x, this.y);
		this.currentPackage.showContent();
		// if (!graph_init) {
		// 	updateInitBPDU();
		// }
	}

	public void render() {
		if (converge) {
			renderBlockedEdges();
		}
		super.render();
		showBPDU();
		if(graph_init) {
			receiveBPDU();
			if (sendStatus) {
				sendBPDU();
			}
		}
	}

	public void receiveBPDU() {
		if(this.receiveStatus) {
			boolean testUpdates = false; //test whether there is update for BPDU or not
										 //if there is no updates, the distributed spanning tree has been built.
			this.receiveStatus = false;
			if (this.receivedPackage.size() <= 0) {
				return;
			}
			for (BPDU tmpBPDU : this.receivedPackage) {
				if(this.currentPackage.compare(tmpBPDU) == -1) {
					this.currentPackage.updateBPDU(tmpBPDU.getRootId(), tmpBPDU.getCost(), tmpBPDU.getBridgeId());
					//this.currentPackage.incrementCost();
					//println(this.name);
					//println("update current BPDU: " + tmpBPDU.getRootId() + ", " + tmpBPDU.getCost() +", "+ tmpBPDU.getBridgeId());
				}
				for (BPDU stored : this.bestReceived) {
					if (tmpBPDU.getBridgeId().equals(stored.getSenderId())) {
						if (stored.getRootId().length > 0) {
							if(stored.compare(tmpBPDU) == -1 ){
								stored.updateBPDU(tmpBPDU.getRootId(), tmpBPDU.getCost(), tmpBPDU.getBridgeId());
								testUpdates = true;
							}
						} else {
							stored.updateBPDU(tmpBPDU.getRootId(), tmpBPDU.getCost(), tmpBPDU.getBridgeId());
							testUpdates = true;
						}
					}
					println(this.name);
			 		println("Best Received BPDU: " + stored.getRootId() + ", " + stored.getCost() +", "+ stored.getBridgeId());
				}
			}
			if (!testUpdates) {
				boolean testRootId = false;	//test the root id of received pa
				for (BPDU stored : this.bestReceived) {
					if(!stored.getRootId().equals(this.currentPackage.getRootId())) {
						testRootId = true;
					}
				}
				if(!testRootId) {
					this.converge = true;
				}
			}
			// for (BPDU stored : this.bestReceived) {
			// 	println(this.name);
			// 	println("Best Received BPDU: " + stored.getRootId() + ", " + stored.getCost() +", "+ stored.getBridgeId());
			// }
			this.receivedPackage.clear();
		}
	}

	public void renderBlockedEdges() {

		this.blockedEdges.clear();
		int i = 0;
		for (Bridge nextBridge :  this.neighborBridge) {
			if (this.currentPackage.getBridgeId().equals(nextBridge.getName()) || 
				nextBridge.getCurrentPackage().getBridgeId().equals(this.name)) {
				//forwarding bridge or receiving bridge
			} else {
				for (MyNode node : this.neighbors) {
					for (MyNode nextNode : node.getNeighbors()) {
						if (nextNode.getName().equals(nextBridge.getName())) {
							if(nextBridge.getCurrentPackage().compare(this.currentPackage) == 1 ) {
								MyEdge tmpEdge = new MyEdge(this.x, this.y, node.getX(), node.getY());
								tmpEdge.setBlock(true);
								this.blockedEdges.add(tmpEdge);
							} else if(nextBridge.getCurrentPackage().compare(this.currentPackage) == 0 
								&& this.name > nextBridge.getName()) {
								MyEdge tmpEdge = new MyEdge(this.x, this.y, node.getX(), node.getY());
								tmpEdge.setBlock(true);
								this.blockedEdges.add(tmpEdge);
							}
						}
					}
				}

			}
			++i;
		}
			
		for (MyEdge tmpEdge : this.blockedEdges) {
			tmpEdge.render();
		}
	}
}