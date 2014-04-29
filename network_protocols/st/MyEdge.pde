class MyEdge {
	float x1, y1, x2, y2;
	int thickness;
	float originalLen;	//spring's original length
	float currentLen;	//spring's current length

	MyEdge() {

	}

	MyEdge(float x1, float y1, float x2, float y2) {
		setPosition(x1, y1, x2, y2);
	}

	MyEdge(float len) {
		setOriginalLen(len);
	}

	public void setPosition(float x1, float y1, float x2, float y2) {
		this.x1 = x1;
		this.y1 = y1;
		this.x2 = x2;
		this.y2 = y2;
	}

	public float getX1() {
		return this.x1;
	}

	public float getY1() {
		return this.y1
	}

	public float getX2() {
		return this.x2;
	}

	public float getY2() {
		return this.y2;
	}

	public void setOriginalLen(float len) {
		this.originalLen = len;
	}

	public float getOriginalLen() {
		return this.originalLen;
	}

	public void setThickness(int thickness) {
		this.thickness = thickness;
	}

	public float getCurrentLen() {
		this.currentLen = sqrt((this.x2 - this.x1)*(this.x2 - this.x1) + (this.y2 - this.y1)*(this.y2 - this.y1));  
    	return this.currentLen;
	}

	public void render() {
		stroke(0);
		if(this.thickness > 0){
			strokeWeight(this.thickness);
		} else {
			strokeWeight(1);
		}

		line(x1,y1,x2,y2);
		
	}
}