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
	static public var A_WHITE:String = "a_white";
	static public var A_PLAYER_RED:String = "a_player_red";
	static public var A_PLAYER_YELLOW:String = "a_player_yellow";
	static public var A_PLAYER_BLUE:String = "a_player_blue";
	static public var A_PLAYER_WHITE:String = "a_player_white";
	
	@:isVar public var color(default, set):Color;
	
	public function new (x:Float=0, y:Float=0, c:Color, mine:Bool = true) {
		super(x, y);
		
		friction = 1;
		
		setHitbox(16, 16, -8, -8);
		
		if (!mine) {
			type = Protrotrype.T_ENEMY_BULLET;
			speed = 3;
		} else {
			type = Protrotrype.T_PLAYER_BULLET;
			speed = 8;
		}
		
		spritemap = new Spritemap("img/ammo.png", 16, 16);
		spritemap.add(A_RED, [2, 6, 10], 4);
		spritemap.add(A_YELLOW, [1, 5, 9], 4);
		spritemap.add(A_BLUE, [0, 4, 8], 4);
		spritemap.add(A_WHITE, [3, 7], 5);
		spritemap.add(A_PLAYER_RED, [2, 6, 10], 4);
		spritemap.add(A_PLAYER_YELLOW, [1, 5, 9], 4);
		spritemap.add(A_PLAYER_BLUE, [0, 4, 8], 4);
		spritemap.add(A_PLAYER_WHITE, [3, 7], 5);
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
		
		if (health <= 0 || right < 0 || left > cast(scene, Protrotrype).level.width || bottom < 0 || top > cast(scene, Protrotrype).level.height) {
			cast(scene, Protrotrype).particles.bulletHit(this);
			scene.remove(this);
		}
		
		if (collide(Protrotrype.T_WALLS, x, y) != null) {
			cast(scene, Protrotrype).particles.bulletHit(this);
			scene.remove(this);
			SoundMan.wallImpact();
		}
	}
	
	public function reflect () {
		health--;// Lose health (limits number of bounces)
		if (!isDead())	SoundMan.reflectBullet();
		
		if (type == Protrotrype.T_PLAYER_BULLET) {
			type = Protrotrype.T_ENEMY_BULLET;
			speed = 3;
		} else {
			type = Protrotrype.T_PLAYER_BULLET;
			//speed = 8;
		}
		
		Main.TAP.x = dx * (Std.random(9) + 1) / 10;
		Main.TAP.y = dy * (Std.random(9) + 1) / 10;
		Main.TAP.normalize(speed);
		dx = -Main.TAP.x;
		dy = -Main.TAP.y;
		
		color = Color.WHITE;
	}
	
	function set_color (c:Color) :Color {
		color = c;
		if (type == Protrotrype.T_PLAYER_BULLET) {
			switch (color) {
				case Color.RED:			spritemap.play(A_PLAYER_RED);
				case Color.YELLOW:		spritemap.play(A_PLAYER_YELLOW);
				case Color.BLUE:		spritemap.play(A_PLAYER_BLUE);
				case Color.WHITE:		spritemap.play(A_PLAYER_WHITE);
			}
		} else {
			switch (color) {
				case Color.RED:			spritemap.play(A_RED);
				case Color.YELLOW:		spritemap.play(A_YELLOW);
				case Color.BLUE:		spritemap.play(A_BLUE);
				case Color.WHITE:		spritemap.play(A_WHITE);
			}
		}
		return color;
	}
	
}
