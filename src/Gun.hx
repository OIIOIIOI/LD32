package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import Protrotrype;

/**
 * ...
 * @author 01101101
 */
class Gun extends Entity {
	
	static public var A_RR:String = "a_rr";
	static public var A_RY:String = "a_ry";
	static public var A_RB:String = "a_rb";
	static public var A_BR:String = "a_br";
	static public var A_BY:String = "a_by";
	static public var A_BB:String = "a_bb";
	static public var A_YR:String = "a_yr";
	static public var A_YY:String = "a_yy";
	static public var A_YB:String = "a_yb";
	
	var spritemap:Spritemap;
	
	public function new (x:Float=0, y:Float=0) {
		super(x, y);
		
		spritemap = new Spritemap("img/gun.png", 44, 16);
		spritemap.add(A_RR, [0]);
		spritemap.add(A_RY, [1]);
		spritemap.add(A_RB, [2]);
		spritemap.add(A_BR, [3]);
		spritemap.add(A_BY, [4]);
		spritemap.add(A_BB, [5]);
		spritemap.add(A_YR, [6]);
		spritemap.add(A_YY, [7]);
		spritemap.add(A_YB, [8]);
		spritemap.originX = 22;
		spritemap.originY = 8;
		
		addGraphic(spritemap);
		
		centerOrigin();
	}
	
	public function updateColors (c1:Color, c2:Color) {
		var a = "a_";
		a += switch (c1) {
			case Color.RED: "r";
			case Color.BLUE: "b";
			case Color.YELLOW: "y";
		}
		a += switch (c2) {
			case Color.RED: "r";
			case Color.BLUE: "b";
			case Color.YELLOW: "y";
		}
		spritemap.play(a);
	}
	
}
