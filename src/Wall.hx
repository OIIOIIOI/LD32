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
	
	var spritemap:Spritemap;
	
	public function new (x:Float = 0, y:Float = 0, full:Bool = true, top:Bool = false) {
		super(x, y);
		
		setHitbox(32, 28, 0, -2);
		type = Protrotrype.T_WALLS;
		
		spritemap = new Spritemap("img/walls.png", Level.GRID_SIZE, Level.GRID_SIZE);
		spritemap.add(A_BORDER, [0]);
		spritemap.add(A_FULL, [1]);
		spritemap.add(A_TOP, [2]);
		
		addGraphic(spritemap);
		
		if (top)		spritemap.play(A_TOP);
		else if (full)	spritemap.play(A_FULL);
		else			spritemap.play(A_BORDER);
	}
	
	override public function update () :Void {
		super.update();
		
		layer = -Std.int(y);
	}
	
}
