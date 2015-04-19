package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

/**
 * ...
 * @author 01101101
 */
class Wall extends Entity {
	
	static public var A_BORDER:String = "a_border";
	static public var A_FULL:String = "a_full";
	static public var A_TOP:String = "a_top";
	static public var A_BOTH:String = "a_both";
	
	var spritemap:Spritemap;
	
	public function new (x:Float, y:Float, down:UInt, up:UInt) {
		super(x, y);
		
		setHitbox(32, 28, 0, -2);
		type = Protrotrype.T_WALLS;
		
		spritemap = new Spritemap("img/desert_walls.png", Level.GRID_SIZE, Level.GRID_SIZE);
		spritemap.add(A_BORDER, [0]);
		spritemap.add(A_FULL, [1]);
		spritemap.add(A_TOP, [2]);
		spritemap.add(A_BOTH, [3]);
		
		addGraphic(spritemap);
		
		if (down == 0) {
			if (up == 0)	spritemap.play(A_FULL);
			else			spritemap.play(A_TOP);
		} else {
			if (up == 0)	spritemap.play(A_BORDER);
			else			spritemap.play(A_BOTH);
		}
	}
	
	override public function update () :Void {
		super.update();
		
		layer = -Std.int(y);
	}
	
}
