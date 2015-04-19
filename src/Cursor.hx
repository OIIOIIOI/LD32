package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import Protrotrype;

/**
 * ...
 * @author 01101101
 */
class Cursor extends Entity {
	
	static var A_R:String = "a_r";
	static var A_Y:String = "a_y";
	static var A_B:String = "a_b";
	
	var spritemap:Spritemap;
	
	public function new () {
		super();
		
		spritemap = new Spritemap("img/cursor.png", 13, 13);
		spritemap.add(A_Y, [0]);
		spritemap.add(A_B, [1]);
		spritemap.add(A_R, [2]);
		spritemap.originX = 6;
		spritemap.originY = 6;
		addGraphic(spritemap);
		
		layer = -99999;
	}
	
	public function changeColor (c:Color) {
		switch (c) {
			case Color.RED:	spritemap.play(A_R);
			case Color.BLUE:	spritemap.play(A_B);
			case Color.YELLOW:	spritemap.play(A_Y);
			default:
		}
	}
	
}