package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

/**
 * ...
 * @author 01101101
 */
class MovingEntity extends Entity {
	
	static public var A_IDLE:String = "a_idle";
	
	public var dx:Float;
	public var dy:Float;
	public var speed:Float;
	var friction:Float;
	
	var spritemap:Spritemap;
	var health:Int;
	
	public function new (x:Float = 0, y:Float = 0) {
		super(x, y);
		
		dx = dy = 0;
		speed = 0;
		friction = 1;
		health = 1;
	}
	
	override public function update () :Void {
		collision();
		
		x += dx;
		dx *= friction;
		if (Math.abs(dx) < 0.01)	dx = 0;
		
		y += dy;
		dy *= friction;
		if (Math.abs(dy) < 0.01)	dy = 0;
		
		layer = -Std.int(y);
	}
	
	function collision () { }
	
	public function isDead () :Bool {
		return health <= 0;
	}
	
	public function clone () :MovingEntity {
		return new MovingEntity(x, y);
	}
	
}