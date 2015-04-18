package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
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
	
	var shootInterval:Float;
	var shootTick:Float;
	
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
		
		shootInterval = 2 + Std.random(7) / 3;
		shootTick = 0;
	}
	
	override public function update () :Void {
		super.update();
		
		shootTick += HXP.elapsed;
		if (shootTick >= shootInterval) {
			shoot();
			shootTick -= shootInterval;
		}
		
		var b:Bullet;
		var a:Array<Entity> = new Array();
		collideInto(Protrotrype.T_PLAYER_BULLET, x, y, a);
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
				HXP.screen.shake(1, 0.2);
			}
			// Stop bullet
			else {
				scene.remove(e);
			}
		}
		a = null;
	}
	
	function shoot () {
		var player = scene.getInstance("player");
		if (player != null) {
			var b = new Bullet(x, y, color, false);
			Main.TAP.x = player.x - x;
			Main.TAP.y = player.y - y;
			Main.TAP.normalize(b.speed);
			b.dx = Main.TAP.x;
			b.dy = Main.TAP.y;
			scene.add(b);
		}
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