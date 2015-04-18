package  ;

import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import Protrotrype;

/**
 * ...
 * @author 01101101
 */
class Bullet extends MovingEntity {
	
	static public var A_RED:String = "a_red";
	static public var A_YELLOW:String = "a_yellow";
	static public var A_BLUE:String = "a_blue";
	
	@:isVar public var color(default, set):Color;
	
	var health:Float;
	
	public function new (x:Float=0, y:Float=0, c:Color) {
		super(x, y);
		
		speed = 8;
		friction = 1;
		
		setHitbox(16, 16, -8, -8);
		type = Protrotrype.T_BULLET;
		
		spritemap = new Spritemap("img/bullets.png", 16, 16);
		spritemap.add(A_RED, [0]);
		spritemap.add(A_YELLOW, [1]);
		spritemap.add(A_BLUE, [2]);
		spritemap.originX = 8;
		spritemap.originY = 8;
		
		addGraphic(spritemap);
		
		centerOrigin();
		
		health = 2;
		
		color = c;
	}
	
	override public function update () :Void {
		super.update();
		
		//health -= HXP.elapsed;
		
		if (health <= 0 || right < 0 || left > Protrotrype.VIEW_WIDTH || bottom < 0 || top > Protrotrype.VIEW_HEIGHT) {
			scene.remove(this);
		}
	}
	
	public function reflect () {
		x -= dx;
		y -= dy;
		speed *= 0.33;
		health--;
		Main.TAP.x = dx;
		Main.TAP.y = dy;
		Main.TAP.normalize(speed);
		dx = -Main.TAP.x;
		dy = -Main.TAP.y;
	}
	
	function set_color (c:Color) :Color {
		color = c;
		switch (color) {
			case Color.RED:			spritemap.play(A_RED);
			case Color.YELLOW:		spritemap.play(A_YELLOW);
			case Color.BLUE:		spritemap.play(A_BLUE);
		}
		return color;
	}
	
}
