class BPDU {

	String senderId;
	String destinationId;
	String rootId;
	int cost;
	String bridgeId;
	float x, y;
	float step;
	float pct;
	boolean arriveMid, arriveEnd;
	boolean sendStatus;


	BPDU (String rootId, int cost, String bridgeId) {
		updateBPDU(rootId, cost, bridgeId);
		arriveMid = false;
		arriveEnd = false;
		sendStatus = true;
		//step = random(0.001, 0.010);
		step = 0.01;
		pct = 0.0;
	}

	public void setRootId(String rootId) {
		this.rootId = rootId;
	}

	public String getRootId() {
		return this.rootId;
	}

	public void incrementCost() {
		this.cost += 1;
	}

	public int getCost() {
		return this.cost;
	}

	public void setBridgeId(String bridgeId) {
		this.bridgeId = bridgeId;
	}

	public String getBridgeId() {
		return this.bridgeId;
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

	public boolean getArriveEnd() {
		return arriveEnd;
	}

	// public void setSendStatus(boolean status) {
	// 	this.sendStatus = status;
	// } 

	public boolean getSendStatus() {
		return sendStatus;
	}

	public void setSendStatus(boolean status) {
		this.sendStatus = status;
	}

	public void updateBPDU(String rootId, int cost, String bridgeId) {
		this.rootId = rootId;
		this.cost = cost;
		this.bridgeId = bridgeId;
	}

	public void move(Vector start, Vector mid, Vector end) {
		if (sendStatus) {
			//package in send mode
			if (!arriveMid) {
				if(move(start, mid)) {
					arriveMid = true;
				}
			} else {
				if (move(mid, end)) {
					arriveEnd = true;
					sendStatus  = false;
				}
			}
		} else {
			//package reach its end
			arriveEnd = false;
			arriveMid = false;
		}


	}

	public boolean move(Vector start, Vector end) {
		float distX = end.getX() - start.getX();
		float distY = end.getY() - start.getY();
		this.pct += this.step;
		if (pct < 1.0) {
			this.x = start.getX() + (pct*distX);
			this.y = start.getY() + (pct*distY);
			return false;
		} else {
			this.pct = 0.0;
			return true;
		}
	}

	// 1 : current BPDU has lower cost; 
	// 0 : current BPDU has the same cost with other; 
	// -1 : other BPDU has lower cost;
	public int compare(BPDU other){
		// smaller rootId has higher priority 
		if(compareStringIgnoreCase(this.rootId, other.getRootId()) < 0){
			return 1;
		} else if (compareStringIgnoreCase(this.rootId, other.getRootId()) == 0 
			&& this.cost < other.getCost()) {
			return 1;
		} else if(compareStringIgnoreCase(this.rootId, other.getRootId()) == 0 
			&& this.cost == other.getCost() 
			&& compareStringIgnoreCase(this.bridgeId, other.getBridgeId()) < 0) {
			return 1;
		} else if(compareStringIgnoreCase(this.rootId, other.getRootId()) == 0
			&& this.cost == other.getCost()
			&& compareStringIgnoreCase(this.bridgeId, other.getBridgeId()) == 0) {
			return 0;
		} else {
			return -1;
		}
	}

	private int compareStringIgnoreCase(String str1, String str2) {
		str1 = str1.toLowerCase();
		str2 = str2.toLowerCase();
		if(str1.length() > str2.length()) {
			int size = str2.length();
			for (int i = 0; i < size; i++) {
				if(str1.charCodeAt(i) > str2.charCodeAt(i))
					return 1;
				else if(str1.charCodeAt(i) == str2.charCodeAt(i)) {
					if ( i == size - 1)
						return 1;
					else 
						continue;
				}
				else
					return -1;
			}
		} else if(str1.length() == str2.length()) {
			int size = str1.length();
			for (int i = 0; i < size; i++) {
				if(str1.charCodeAt(i) > str2.charCodeAt(i))
					return 1;
				else if(str1.charCodeAt(i) == str2.charCodeAt(i)) {
					if ( i == size - 1)
						return 0;
					else 
						continue;
				}
				else
					return -1;
			}
		} else {
			int size = str1.length();
			for (int i = 0; i < size; i++) {
				if(str1.charCodeAt(i) > str2.charCodeAt(i))
					return 1;
				else if(str1.charCodeAt(i) == str2.charCodeAt(i)) {
					if ( i == size - 1)
						return -1;
					else 
						continue;
				}
				else
					return -1;
			}
		}
	}

	public void render() {
		noStroke();
		fill(#7AE969);
		ellipse(this.x, this.y, 10, 10);
	}

	public void showContent() {
		stroke(0);
		fill(255);
		String content = this.rootId + "  " + this.cost + "  " + this.bridgeId;
		float cw = textWidth(content) + 10;
		float ch = 20;
		float cx = this.x;
		float cy = this.y - 30;
		float sx = cx - cw*0.5;
		float sy = cy - ch*0.5;
		rect(sx, sy, cw, ch);
		fill(0);
		line(sx + cw*0.4, sy, sx + cw*0.4, sy + ch);
		line(sx + cw*0.6, sy, sx + cw*0.6, sy + ch);
		textAlign(CENTER, CENTER);
  		fill(0);	
  		text(content, cx, cy);
	}
}