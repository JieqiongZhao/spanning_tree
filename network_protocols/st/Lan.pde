class Lan extends MyNode {
	PImage lanImage;
	PImage lanHoverImage;

	Lan(int id) {
		super(id);
	}

	Lan(int id, float x, float y) {
		super(id, x, y);
	}

	public void setId(int id) {
		super.setId(id);
	}

  	public int getId() {
    	return super.getId();
  	}

	public float getMass() {
		return super.getMass();
	}
  
	public void setName(String name) {
		super.setName(name);
	}

	public String getName() {
		return super.getName();
	}

	public void setDeviceType(int deviceType) {
		super.setDeviceType(deviceType);
	}

	public int getDeviceType() {
		return super.getDeviceType();
	}
	public void setPosition(float x, float y) {
		super.setPosition(x, y);
	}

	public float getX() {
		return super.getX();
	}

	public float getY() {
		return super.getY();
	}

	public void setRadius(float radius) {
		super.setRadius(radius);
	}

	public float getRadius() {
		return super.getRadius();
	}

	public void isectTest() {
		super.isectTest();
	}

	public boolean getIsect() {
		return super.getIsect();
	}

	public void setFillcol( color fillcol) {
		super.setFillcol(fillcol);
	}

	public void loadLanImage(String filename) {
		this.lanImage = loadImage(filename);
	}

	public void loadLanHoverImage(String filename) {
		this.lanHoverImage = loadImage(filename);
	}

	public void render() {
		if(this.isect) {
			//color c = #FF4900;
			stroke(0);
			//fill(c);
			float tmpWidth = lanHoverImage.width*0.4;
  			float tmpHeight = lanHoverImage.height*0.3;
  			image(lanHoverImage, x - tmpWidth * 0.5, y - tmpHeight * 0.5, tmpWidth, tmpHeight);
		} else {
			stroke(0);
			fill(this.fillcol);
			float tmpWidth = lanImage.width*0.4;
  			float tmpHeight = lanImage.height*0.3;
  			image(lanImage, x - tmpWidth * 0.5, y - tmpHeight * 0.5, tmpWidth, tmpHeight);
		}
  		//ellipse(x,y, radius*2,radius*2);

  		textFont(font);
  		textAlign(CENTER, CENTER);
  		fill(0);	
  		text(name, x, y);
		// super.render();
	}
}
