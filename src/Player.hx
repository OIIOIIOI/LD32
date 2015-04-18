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
	
	var bulletPool:BulletPool;
	
	public var currentColor(default, null):Color;
	public var nextColor(default, null):Color;
	
	public function new (x:Float=0, y:Float=0) {
		super(x, y);
		
		speed = 0.8;
		friction = 0.8;
		
		setHitbox(20, 20, -10, -10);
		type = Protrotrype.T_PLAYER;
		
		name = "player";
		
		spritemap = new Spritemap("img/player.png", 32, 32);
		spritemap.add(MovingEntity.A_IDLE, [0]);
		spritemap.originX = 16;
		spritemap.originY = 16;
		
		spritemap.play(MovingEntity.A_IDLE);
		addGraphic(spritemap);
		
		centerOrigin();
		
		bulletPool = new BulletPool();
		
		currentColor = bulletPool.getNext();
		nextColor = bulletPool.getNext();
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
				scene.remove(e);
				HXP.screen.shake(3, 0.2);
			}
		}
		a = null;
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
	}
	
	public function swapColors () {
		var c = currentColor;
		currentColor = nextColor;
		nextColor = c;
	}
	
}
