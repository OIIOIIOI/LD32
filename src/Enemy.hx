package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import haxe.Timer;
import openfl.errors.Error;
import Protrotrype;

/**
 * ...
 * @author 01101101
 */
class Enemy extends MovingEntity {
	
	static public var A_RED:String = "a_red";
	static public var A_YELLOW:String = "a_yellow";
	static public var A_BLUE:String = "a_blue";
	
	static public var A_IDLE:String = "a_idle";
	static public var A_WALK:String = "a_walk";
	static public var A_SHOOT:String = "a_shoot";
	static public var A_DEAD:String = "a_dead";
	
	public var weakColor(default, null):Color;
	@:isVar public var color(default, set):Color;
	
	var fovRadius:Int;
	var shootInterval:Float;
	var shootTick:Float;
	
	var shadow:Image;
	
	public function new (x:Float=0, y:Float=0, ?c:Color) {
		super(x, y);
		
		speed = 0.8;
		friction = 0.8;
		
		setHitbox(32, 32, -16, -16);
		type = Protrotrype.T_ENEMY;
		
		// Shadow
		shadow = new Image("img/shadow.png");
		shadow.centerOrigin();
		shadow.x = 3;
		shadow.y = 19;
		shadow.alpha = 0.3;
		addGraphic(shadow);
		
		// Anim
		switch (c) {
			case Color.RED:
				spritemap = new Spritemap("img/skeleton_sprites_01.png", 32, 38);
				spritemap.add(A_IDLE, [0, 1], 5);
				spritemap.add(A_WALK, [1, 2], 5);
				spritemap.add(A_SHOOT, [3], 3, false);
				spritemap.add(A_DEAD, [4]);
				spritemap.originX = 16;
				spritemap.originY = 24;
				spritemap.play(A_IDLE);
				shadow.y = 14;
			default:
				spritemap = new Spritemap("img/enemies_alt.png", 32, 32);
				spritemap.add(A_YELLOW, [0]);
				spritemap.add(A_BLUE, [1]);
				spritemap.add(A_RED, [2]);
				spritemap.originX = 16;
				spritemap.originY = 16;
		}
		
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
		
		fovRadius = 256;
		shootInterval = 2 + Std.random(7) / 3;
		shootTick = 0;
	}
	
	override public function update () :Void {
		super.update();
		
		if (isDead()) return;
		
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
			// Get hit
			if (b.color == color || b.color == Color.WHITE) {
				health--;
				cast(scene, Protrotrype).particles.bulletHit(b);
				scene.remove(b);
				// Dead
				if (health <= 0) {
					spritemap.play(A_DEAD);
					//scene.remove(this);
					HXP.screen.shake(3, 0.2);
					// Check if end of level
					var enemies = cast(scene, Protrotrype).level.enemies;
					//cast(scene, Protrotrype).level.paintBlood(this);
					cast(scene, Protrotrype).particles.bloodStains(this);
					trace(this.layer);
					enemies.remove(this);
					if (enemies.length == 0) {
						Timer.delay(cast(scene, Protrotrype).gameOver.bind(true), 1000);
					}
					break;
				} else {
					HXP.screen.shake(1, 0.2);
				}
			}
			// Reflect bullet
			else {
				b.reflect();
			}
		}
		a = null;
		
		// Animation
		if (spritemap.currentAnim != A_IDLE && spritemap.complete) {
			spritemap.play(A_IDLE);
		}
	}
	
	function shoot () {
		var player = scene.getInstance("player");
		if (player != null && !cast(player, Player).isStunned() && !cast(player, Player).isDead()) {
			// Check view distance
			if (HXP.distance(x, y, player.x, player.y) > fovRadius)	return;
			// Flip
			if (player.x > x) {
				spritemap.flipped = true;
				shadow.x = -3;
			} else {
				spritemap.flipped = false;
				shadow.x = 3;
			}
			// Check line of sight
			var block = scene.collideLine(Protrotrype.T_WALLS, Std.int(x), Std.int(y), Std.int(player.x), Std.int(player.y), 4);
			if (block == null) {
				switch (color) {
					default:	spritemap.play(A_SHOOT);
				}
				
				var b = new Bullet(x, y, color, false);
				Main.TAP.x = player.x - x;
				Main.TAP.y = player.y - y;
				Main.TAP.normalize(b.speed);
				b.dx = Main.TAP.x;
				b.dy = Main.TAP.y;
				scene.add(b);
			}
		}
	}
	
	function set_color (c:Color) :Color {
		color = c;
		switch (color) {
			case Color.RED:
				weakColor = Color.RED;
				//spritemap.play(A_RED);
			case Color.YELLOW:
				weakColor = Color.YELLOW;
				//spritemap.play(A_YELLOW);
			case Color.BLUE:
				weakColor = Color.BLUE;
				//spritemap.play(A_BLUE);
			default:
				throw new Error("Unsupported value");
		}
		return color;
	}
	
}