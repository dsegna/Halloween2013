/* @pjs preload="assets/crosshair.png,
				assets/bg.png,
				assets/zombie.png,
				assets/nuke.png;"
*/
class CrossHair{
	static PImage sprite = loadImage("assets/crosshair.png");;
	int x,y;
	CrossHair(){
		x=0;
		y=0;
	}
	void draw(){
		pushMatrix();
		imageMode(CENTER);
		translate(mouseX,mouseY);
		image(sprite,0,0);
		popMatrix();
	}
}
class Nuke{
	static PImage sprite = loadImage("assets/nuke.png");
	int x,y;
	static int _height=26;
	static int _width=25;
	Nuke(){
		x=random(0+_width,width-_width);
		y=random(0+_height,height/3-_height);
	}
	boolean isOver(int posx, int posy){
		if(posx>x-(_width)/2 && posx <x+(_width)/2){
			if(posy>y-(_height)/2 && posy < y+(_height)/2){
				return true;
			}
		}
		return false;
	}
	void hit(){
		kills+=zomList.size();
		zomList = new ArrayList();
		nuke=null;
	}
	void draw(){
		pushMatrix();
		translate(x,y);
		image(sprite,0,0);
		popMatrix();
	}
}
class Zombie{
	static PImage sprite = loadImage("assets/zombie.png");
	int x,y,z, _millis;
	static int _width=45;
	static int _height=86;
	int hp=3;
	Zombie(){
		x = random(0+23*3,width-23*3);
		y = random(height/2+43*3,height-43*3);
		z = 1;
	}
	void draw(){
		move();
		pushMatrix();
		translate(x,y);
		scale(z);
		image(sprite,0,0);
		popMatrix();
	}
	void move(){
		int lastMove = millis()-_millis;
		if(z<3 && lastMove>=1000){
			y+=10;
			z+=0.2;
			_millis = millis();
		}
		else if(z>=3){
			lose();
		}
	}
	boolean isOver(int posx, int posy){
		if(posx>x-(_width*z)/2 && posx <x+(_width*z)/2){
			if(posy>y-(_height*z)/2 && posy < y+(_height*z)/2){
				return true;
			}
		}
		return false;
	}
	boolean zombieCollision(int posx, int posy){

	}
	boolean kill(int posx, int posy){
		int left = x-(_width/2)*z;
		int top = y-(_height/2)*z;
		if(posy<top+20*z){
			if(posx>(left+18*z) && posx<(left+35*z)){
				headshots++;
				return true;
			}
		}
		else if (posy < top+50*z){
			hp-=2;
		}
		else{
			hp-=1;
		}
		if(hp<=0)
			return true
		else return false;
	}
}
PImage bg;
CrossHair aim = new CrossHair();
int width = 1000;
int height = 800;
ArrayList zomList = new ArrayList();
int kills=0, headshots=0;
var zombTimer;
int numZombies=200;
int zombiesLeft=numZombies;
Nuke nuke = null;
void addZombie(){
	int check = round(random(1,5));
	console.log(check);
	if(check==1 && !nuke){
		nuke=new Nuke();
	}
	if(zombiesLeft>0){
		zombiesLeft--;
		zomList.add(new Zombie());
	}
}
void win(){
	$("#kills").hide();
	$("#headshots").hide();
	$("#winHeadshots").text(headshots);
	$("#winDiv").show();
	noLoop();
	clearInterval(zombTimer);
}
void lose(){
	$("#kills").hide();
	$("#headshots").hide();
	$("#endKills").text(kills);
	$("#endHeadshots").text(headshots);
	$("#loseDiv").show();
	noLoop();
	clearInterval(zombTimer);
}
void restart(){
	kills=0;
	headshots=0;
	zomList = new ArrayList();
	zombInterval=1000;
	zombTimer=setInterval('sketch.addZombie()',zombInterval);
	$("#loseDiv").hide();
	$("#winDiv").hide();
	$("#headshots").show();
	$("#kills").show();
	zombiesLeft=numZombies;
	loop();
}
void setup(){
	size(width,height);
	bg = loadImage("assets/bg.png");
	imageMode(CENTER);
	zombTimer=setInterval('sketch.addZombie()',zombInterval);
}
void draw(){
	sketch = Processing.getInstanceById('gameCanvas');
	if(kills==numZombies){
		win();
	}
	if(kills%50==0 && kills >0){
		clearInterval(zombTimer);
		if(zombInterval-200 >= 400){
			zombInterval-=200;
		}
		zombTimer=setInterval('sketch.addZombie()',zombInterval);
	}
	//Draw background
	background(200);
	pushMatrix();
	translate(width/2,height/2);
	image(bg,0,0,1000,800);
	popMatrix();
	//draw zombies
	for (int i = zomList.size()-1; i >= 0; i--) { 
    	Zombie tmp = (Zombie) zomList.get(i);
    	tmp.draw();
    }
    if(nuke)
    	nuke.draw();
    //draw crosshair
	aim.draw();
	$("#kills").text("Kills : "+kills);
	$("#headshots").text("Headshots : "+headshots);
}
void mousePressed(){
	for (int i=0;i<zomList.size(); i++){
		Zombie tmp= (Zombie) zomList.get(i);
		if(tmp.isOver(mouseX,mouseY)){
			if(tmp.kill(mouseX,mouseY)){
				zomList.remove(i);
				kills++;
			}
			return;
		}
	}
	if(nuke){
		if(nuke.isOver(mouseX,mouseY)){
			nuke.hit();
		}
	}
}
