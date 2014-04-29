class Bridge extends MyNode {
	ArrayList<ArrayList<BPDU>> sentoutPackages;
	BPDU currentPackage;
	ArrayList<BPDU> bestReceived; //best can receive and a timer for when received it
	ArrayList<MyNode> neighborBridge;
	boolean sendStatus, receiveStatus;
	ArrayList<BPDU> receivedPackage;

	Bridge(int id) {
		super(id);
		sendStatus = true;
		receiveStatus = false;

	}

	Bridge(int id, float x, float y) {
		super(id, x, y);
		sendStatus = true;
		receiveStatus = false;
	}

	void setSendStatus(boolean status) {
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
		for (int i = 0; i < this.sentoutPackages.size(); ++i) {
			BPDU newPackage = new BPDU(this.currentPackage.getRootId(), this.currentPackage.getCost(), this.name);
			newPackage.setPosition(this.x, this.y);
			this.sentoutPackages.get(i).add(newPackage);
		}
	}

	void setReceiveStatus(boolean status) {
		this.receiveStatus = status;
	}

	void setReceivedPackage(BPDU tmpBPDU) {
		BPDU newPackage = new BPDU(tmpBPDU.getRootId(), tmpBPDU.getCost()+1, tmpBPDU.getBridgeId());
		this.receivedPackage.add(newPackage);
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
		for (MyNode node: this.neighbors) {
			for (MyNode nextBridge : node.getNeighbors()) {
				if (nextBridge.getId() != this.id ) {
					//BPDU newPackage = new BPDU(this.name, 0, this.name);
					//newPackage.setPosition(this.x, this.y);
					ArrayList<BPDU> tmpArray = new ArrayList<BPDU>();
					//tmpArray.add(newPackage);
					this.sentoutPackages.add(tmpArray);
					this.neighborBridge.add(nextBridge);
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
			this.receiveStatus = false;
			if (this.receivedPackage.size() <= 0) {
				return;
			}
			for (BPDU tmpBPDU : this.receivedPackage) {
				if(this.currentPackage.compare(tmpBPDU) == -1) {
					this.currentPackage.updateBPDU(tmpBPDU.getRootId(), tmpBPDU.getCost(), tmpBPDU.getBridgeId());
					//this.currentPackage.incrementCost();
					println(this.name);
					println("update current BPDU: " + tmpBPDU.getRootId() + ", " + tmpBPDU.getCost() +", "+ tmpBPDU.getBridgeId());
				}
			}
			this.receivedPackage.clear();
		}
	}
}