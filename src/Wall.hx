package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

/**
 * ...
 * @author 01101101
 */
class Wall extends Entity {
	
	static public var A_IDLE:String = "a_idle";
	
	var spritemap:Spritemap;
	
	public function new (x:Float=0, y:Float=0) {
		super(x, y);
		
		setHitbox(44, 28, 6, -2);
		type = Protrotrype.T_WALLS;
		
		spritemap = new Spritemap("img/walls.png", Level.GRID_SIZE, Level.GRID_SIZE);
		spritemap.add(A_IDLE, [0]);
		
		addGraphic(spritemap);
	}
	
	override public function update () :Void {
		super.update();
		
		layer = -Std.int(y);
	}
	
}
