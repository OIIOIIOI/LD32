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
		
		setHitbox(32, 32, -16, -16);
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
				HXP.screen.shake(3, 0.2);
				scene.remove(e);
			}
		}
		a = null;
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
