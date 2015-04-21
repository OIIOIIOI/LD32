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
class Turret extends Enemy {
	
	public function new (x:Float=0, y:Float=0, ?c:Color) {
		super(x, y, c);
		
		fovRadius = 999;
		shootInterval = 1.5;
		shootTick = 0;
	}
	
	override public function clone () :Turret {
		return new Turret(x, y, color);
	}
	
	override function shoot () {
		var player = scene.getInstance("player");
		if (player == null || cast(player, Player).isStunned() || cast(player, Player).isDead()) return;
		
		var block:Entity;
		
		var dLeft = 10000.0;
		block = scene.collideLine(Protrotrype.T_WALLS, Std.int(centerX), Std.int(centerY), Std.int(centerX - 10000), Std.int(centerY), 5);
		if (block != null) dLeft = HXP.distance(centerX, centerY, block.centerX, block.centerY);
		
		var dRight = 10000.0;
		block = scene.collideLine(Protrotrype.T_WALLS, Std.int(centerX), Std.int(centerY), Std.int(centerX + 10000), Std.int(centerY), 5);
		if (block != null) dRight = HXP.distance(centerX, centerY, block.centerX, block.centerY);
		
		var dDown = 10000.0;
		block = scene.collideLine(Protrotrype.T_WALLS, Std.int(centerX), Std.int(centerY), Std.int(centerX), Std.int(centerY - 10000), 5);
		if (block != null) dDown = HXP.distance(centerX, centerY, block.centerX, block.centerY);
		
		switch (color) {
			default:	spritemap.play(Enemy.A_SHOOT);
		}
		// Spawn bullet
		var b = new Bullet(x, y, weakColor, false);
		Main.TAP.x = 0;
		Main.TAP.y = 0;
		if (dLeft > dRight && dLeft > dDown)		Main.TAP.x = -b.speed * 0.75;
		else if (dRight > dLeft && dRight > dDown)	Main.TAP.x = b.speed * 0.75;
		else										Main.TAP.y = b.speed * 0.75;
		b.dx = Main.TAP.x;
		b.dy = Main.TAP.y;
		scene.add(b);
		// Sound
		switch (color) {
			case Color.BLUE:	SoundMan.indianShoot();
			case Color.RED:		SoundMan.mexicanShoot();
			case Color.YELLOW:	SoundMan.banditShoot();
			default:
		}
		
		
		/*var player = scene.getInstance("player");
		if (player != null && !cast(player, Player).isStunned() && !cast(player, Player).isDead()) {
			// Check view distance
			if (HXP.distance(x, y, player.x, player.y) > fovRadius)	return;
			// Flip
			if (player.x > x) {
				spritemap.flipped = true;
				if (color == Color.RED)			shadow.x = -3;
				else if (color == Color.YELLOW)	shadow.x = 2;
			} else {
				spritemap.flipped = false;
				if (color == Color.RED)			shadow.x = 3;
				else if (color == Color.YELLOW)	shadow.x = -2;
			}
			// Check line of sight
			var block = scene.collideLine(Protrotrype.T_WALLS, Std.int(x), Std.int(y), Std.int(player.x), Std.int(player.y), 4);
			if (block == null) {
				switch (color) {
					default:	spritemap.play(A_SHOOT);
				}
				// Spawn bullet
				var b = new Bullet(x, y, weakColor, false);
				Main.TAP.x = player.x - x;
				Main.TAP.y = player.y - y;
				Main.TAP.normalize(b.speed);
				b.dx = Main.TAP.x;
				b.dy = Main.TAP.y;
				scene.add(b);
				// Sound
				switch (color) {
					case Color.BLUE:	SoundMan.indianShoot();
					case Color.RED:		SoundMan.mexicanShoot();
					case Color.YELLOW:	SoundMan.banditShoot();
					default:
				}
			}
		}*/
	}
	
	override function collBullets ()  {
		var b:Bullet;
		var a:Array<Entity> = new Array();
		collideInto(Protrotrype.T_PLAYER_BULLET, x, y, a);
		for (e in a) {
			b = cast(e);
			cast(scene, Protrotrype).particles.bulletHit(b);
			scene.remove(b);
			SoundMan.wallImpact();
		}
		a = null;
	}
	
}