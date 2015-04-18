package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import Protrotrype;

/**
 * ...
 * @author 01101101
 */
class Enemy extends MovingEntity {
	
	static public var A_RED:String = "a_red";
	static public var A_YELLOW:String = "a_yellow";
	static public var A_BLUE:String = "a_blue";
	
	@:isVar public var color(default, set):Color;
	var weakColor:Color;
	
	public function new (x:Float=0, y:Float=0, ?c:Color) {
		super(x, y);
		
		speed = 0.8;
		friction = 0.8;
		
		setHitbox(32, 32, -16, -16);
		type = Protrotrype.T_ENEMY;
		
		spritemap = new Spritemap("img/enemies.png", 32, 32);
		spritemap.add(A_YELLOW, [0]);
		spritemap.add(A_BLUE, [1]);
		spritemap.add(A_RED, [2]);
		spritemap.originX = 16;
		spritemap.originY = 16;
		
		addGraphic(spritemap);
		
		centerOrigin();
		
		if (c == null) {
			c = switch (Std.random(3)) {
				case 0:		Color.BLUE;
				case 1:		Color.RED;
				default:	Color.YELLOW;
			}
		}
		color = c;
	}
	
	override public function update () :Void {
		super.update();
		
		var b:Bullet;
		var a:Array<Entity> = new Array();
		collideInto(Protrotrype.T_BULLET, x, y, a);
		for (e in a) {
			b = cast(e);
			// Reflect bullet
			if (b.color == color) {
				b.reflect();
			}
			// Get hit
			else if (b.color == weakColor) {
				scene.remove(e);
				scene.remove(this);
			}
			// Stop bullet
			else {
				scene.remove(e);
			}
		}
		a = null;
	}
	
	function set_color (c:Color) :Color {
		color = c;
		switch (color) {
			case Color.RED:
				weakColor = Color.BLUE;
				spritemap.play(A_RED);
			case Color.YELLOW:
				weakColor = Color.RED;
				spritemap.play(A_YELLOW);
			case Color.BLUE:
				weakColor = Color.YELLOW;
				spritemap.play(A_BLUE);
		}
		return color;
	}
	
}