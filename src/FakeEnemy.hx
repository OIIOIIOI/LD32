package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
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
class FakeEnemy extends Enemy {
	
	public function new (x:Float=0, y:Float=0, ?c:Color) {
		super(x, y, c);
		
		cast(graphic, Graphiclist).removeAll();
		
		// Anim
		spritemap = new Spritemap("img/cibles_tuto.png", 32, 64);
		switch (c) {
			case Color.RED:
				spritemap.add(Enemy.A_IDLE, [4]);
				spritemap.add(Enemy.A_DEAD, [5]);
				spritemap.originX = 16;
				spritemap.originY = 32;
				spritemap.play(Enemy.A_IDLE);
			case Color.BLUE:
				spritemap.add(Enemy.A_IDLE, [2]);
				spritemap.add(Enemy.A_DEAD, [3]);
				spritemap.originX = 16;
				spritemap.originY = 32;
				spritemap.play(Enemy.A_IDLE);
			case Color.YELLOW:
				spritemap.add(Enemy.A_IDLE, [0]);
				spritemap.add(Enemy.A_DEAD, [1]);
				spritemap.originX = 16;
				spritemap.originY = 32;
				spritemap.play(Enemy.A_IDLE);
			default:
				throw new Error("Invalid color");
		}
		
		addGraphic(spritemap);
		
		centerOrigin();
	}
	
	override function getHurt (white:Bool = false)  {
		SoundMan.playerImpact();
	}
	
	override public function clone () :FakeEnemy {
		return new FakeEnemy(x, y, color);
	}
	
	override function shoot () {
	}
	
}