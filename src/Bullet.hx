package  ;

import com.haxepunk.graphics.Spritemap;

/**
 * ...
 * @author 01101101
 */
class Bullet extends MovingEntity {
	
	static public var A_RED:String = "a_red";
	static public var A_YELLOW:String = "a_yellow";
	static public var A_BLUE:String = "a_blue";
	
	@:isVar public var color(get, set):BulletColor;
	
	public function new (x:Float=0, y:Float=0, c:BulletColor) {
		super(x, y);
		
		speed = 8;
		friction = 1;
		
		setHitbox(16, 16, -8, -8);
		
		spritemap = new Spritemap("img/bullets.png", 16, 16);
		spritemap.add(A_RED, [0]);
		spritemap.add(A_YELLOW, [1]);
		spritemap.add(A_BLUE, [2]);
		spritemap.originX = 8;
		spritemap.originY = 8;
		
		addGraphic(spritemap);
		
		centerOrigin();
		
		color = c;
	}
	
	function get_color () :BulletColor {
		return color;
	}
	
	function set_color (c:BulletColor) :BulletColor {
		color = c;
		switch (color) {
			case RED:		spritemap.play(A_RED);
			case YELLOW:	spritemap.play(A_YELLOW);
			case BLUE:		spritemap.play(A_BLUE);
		}
		return color;
	}
	
}

enum BulletColor {
	RED;
	YELLOW;
	BLUE;
}
