package  ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import Protrotrype;

/**
 * ...
 * @author 01101101
 */
class Player extends MovingEntity {
	
	static public var A_R:String = "a_r";
	static public var A_Y:String = "a_y";
	static public var A_B:String = "a_b";
	
	var gunSpritemap:Spritemap;
	var reserveSpritemap:Spritemap;
	
	var bulletPool:BulletPool;
	public var currentColor(default, null):Color;
	public var nextColor(default, null):Color;
	
	public function new (x:Float=0, y:Float=0) {
		super(x, y);
		
		bulletPool = new BulletPool();
		currentColor = bulletPool.getNext();
		nextColor = bulletPool.getNext();
		
		speed = 0.8;
		friction = 0.8;
		
		setHitbox(30, 20, -15, -10);
		type = Protrotrype.T_PLAYER;
		
		name = "player";
		
		// Reserve
		reserveSpritemap = new Spritemap("img/reserve.png", 16, 24);
		reserveSpritemap.add(A_R, [0]);
		reserveSpritemap.add(A_Y, [1]);
		reserveSpritemap.add(A_B, [2]);
		reserveSpritemap.play(A_R);
		reserveSpritemap.originX = 24;
		reserveSpritemap.originY = 12;
		addGraphic(reserveSpritemap);
		
		// Char
		spritemap = new Spritemap("img/player.png", 32, 32);
		spritemap.add(MovingEntity.A_IDLE, [0]);
		spritemap.originX = 16;
		spritemap.originY = 16;
		spritemap.play(MovingEntity.A_IDLE);
		addGraphic(spritemap);
		
		centerOrigin();
		
		// Gun
		gunSpritemap = new Spritemap("img/gun.png", 44, 16);
		gunSpritemap.add(A_R, [0]);
		gunSpritemap.add(A_Y, [1]);
		gunSpritemap.add(A_B, [2]);
		gunSpritemap.play(A_R);
		gunSpritemap.originX = 22;
		gunSpritemap.originY = 8;
		addGraphic(gunSpritemap);
	}
	
	override public function update () :Void {
		super.update();
		
		var b:Bullet;
		var a:Array<Entity> = new Array();
		collideInto(Protrotrype.T_ENEMY_BULLET, x, y, a);
		for (e in a) {
			b = cast(e);
			// Reflect bullet
			if (b.color == nextColor) {
				b.reflect();
			}
			// Get hit
			else {
				cast(scene, Protrotrype).particles.bulletHit(b);
				scene.remove(e);
				HXP.screen.shake(8, 0.6);
			}
		}
		a = null;
		
		var an = Math.atan2(y - scene.mouseY, scene.mouseX - x) * 180 / Math.PI;
		gunSpritemap.angle = an;
	}
	
	override function collision ()  {
		// Outer walls collision
		if (left + dx < 0 || right + dx > cast(scene, Protrotrype).level.width) {
			dx = 0;
		}
		if (top + dy < 0 || bottom + dy > cast(scene, Protrotrype).level.height) {
			dy = 0;
		}
		// Inner walls collision
		if (dx != 0 || dy != 0) {
			if (collide(Protrotrype.T_WALLS, x + dx, y + dy) == null) {
				//x += dx;
				//y += dy;
			} else if (collide(Protrotrype.T_WALLS, x + dx, y) == null) {
				//x += dx;
				dy = 0;
			} else if (collide(Protrotrype.T_WALLS, x, y + dy) == null) {
				dx = 0;
				//y += dy;
			} else {
				dx = dy = 0;
			}
		}
	}
	
	public function cycleColors () {
		currentColor = nextColor;
		nextColor = bulletPool.getNext();
		//
		var a:String = switch (currentColor) {
			case Color.RED: A_R;
			case Color.BLUE: A_B;
			case Color.YELLOW: A_Y;
			default: "";// Unsupported
		}
		gunSpritemap.play(a);
		//
		a = switch (nextColor) {
			case Color.RED: A_R;
			case Color.BLUE: A_B;
			case Color.YELLOW: A_Y;
			default: "";// Unsupported
		}
		reserveSpritemap.play(a);
	}
	
	public function swapColors () {
		var c = currentColor;
		currentColor = nextColor;
		nextColor = c;
		//
		var a:String = switch (currentColor) {
			case Color.RED: A_R;
			case Color.BLUE: A_B;
			case Color.YELLOW: A_Y;
			default: "";// Unsupported
		}
		gunSpritemap.play(a);
		//
		a = switch (nextColor) {
			case Color.RED: A_R;
			case Color.BLUE: A_B;
			case Color.YELLOW: A_Y;
			default: "";// Unsupported
		}
		reserveSpritemap.play(a);
	}
	
}
