package  ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import haxe.Timer;
import Protrotrype;

/**
 * ...
 * @author 01101101
 */
class Player extends MovingEntity {
	
	static public var ORIG_Y:Int = 19;
	
	static public var A_R:String = "a_r";
	static public var A_Y:String = "a_y";
	static public var A_B:String = "a_b";
	
	static public var A_WALK:String = "a_walk";
	static public var A_HIT:String = "a_hit";
	static public var A_DEATH:String = "a_death";
	
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
		
		setHitbox(24, 16);
		type = Protrotrype.T_PLAYER;
		
		name = "player";
		
		health = 3;
		
		// Shadow
		var shadow = new Image("img/shadow.png");
		shadow.centerOrigin();
		shadow.x = 3;
		shadow.y = ORIG_Y;
		shadow.alpha = 0.3;
		addGraphic(shadow);
		
		// Reserve
		reserveSpritemap = new Spritemap("img/reserve.png", 8, 15);
		reserveSpritemap.add(A_B, [0]);
		reserveSpritemap.add(A_R, [1]);
		reserveSpritemap.add(A_Y, [2]);
		reserveSpritemap.play(A_R);
		reserveSpritemap.originX = 16;
		reserveSpritemap.originY = 5;
		addGraphic(reserveSpritemap);
		
		// Char
		spritemap = new Spritemap("img/hero_sprites_01.png", 32, 38);
		spritemap.add(MovingEntity.A_IDLE, [3, 4], 5);
		spritemap.add(A_WALK, [0, 1, 0, 1, 0, 1, 0, 1, 2, 1], 5);
		spritemap.add(A_HIT, [5, 6, 5, 6], 4, false);
		spritemap.add(A_DEATH, [5, 6, 5, 6, 7, 8, 9, 10, 11], 4, false);
		spritemap.originX = 16;
		spritemap.originY = ORIG_Y;
		spritemap.play(MovingEntity.A_IDLE);
		addGraphic(spritemap);
		
		centerOrigin();
		originY = 4;
		
		// Gun
		gunSpritemap = new Spritemap("img/weapon.png", 26, 10);
		gunSpritemap.add(A_B, [0]);
		gunSpritemap.add(A_R, [1]);
		gunSpritemap.add(A_Y, [2]);
		gunSpritemap.play(A_R);
		gunSpritemap.centerOrigin();
		gunSpritemap.y = 12;
		addGraphic(gunSpritemap);
		
		updateColors();
	}
	
	public function isStunned () :Bool {
		return (spritemap.currentAnim == A_HIT);
	}
	
	override public function update () :Void {
		super.update();
		
		// Animation
		if (spritemap.currentAnim == A_HIT && spritemap.complete) {
			gunSpritemap.visible = true;
			reserveSpritemap.visible = true;
		}
		if (spritemap.currentAnim != A_DEATH && (spritemap.currentAnim != A_HIT || spritemap.complete)) {
			if (Math.abs(dx) > 0.5 || Math.abs(dy) > 0.5)	spritemap.play(A_WALK);
			else											spritemap.play(MovingEntity.A_IDLE);
		}
		
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
				
				health--;
				if (health <= 0) {
					HXP.screen.shake(8, 0.6);
					spritemap.play(A_DEATH);
					gunSpritemap.visible = false;
					reserveSpritemap.visible = false;
					Timer.delay(cast(scene, Protrotrype).gameOver.bind(false), 1000);
				} else {
					HXP.screen.shake(5, 0.3);
					spritemap.play(A_HIT);
					gunSpritemap.visible = false;
					reserveSpritemap.visible = false;
				}
				// Score
				ScoreMan.comboBreak();
			}
		}
		a = null;
		
		// Gun rotation and sprite flipping
		if (!isStunned() && !isDead()) {
			var an = Math.atan2(y - scene.mouseY, scene.mouseX - x) * 180 / Math.PI;
			if (an < 90 && an > -90) {
				reserveSpritemap.originX = 16;
				spritemap.flipped = false;
				gunSpritemap.flipped = false;
				gunSpritemap.angle = an;
				gunSpritemap.x = 5;
			} else {
				reserveSpritemap.originX = -8;
				spritemap.flipped = true;
				gunSpritemap.flipped = true;
				gunSpritemap.angle = an + 180;
				gunSpritemap.x = -5;
			}
		}
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
		updateColors();
	}
	
	public function swapColors () {
		var c = currentColor;
		currentColor = nextColor;
		nextColor = c;
		updateColors();
	}
	
	function updateColors () {
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
