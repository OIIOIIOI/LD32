package ;

import flash.Lib;
import openfl.geom.Point;

/**
 * ...
 * @author 01101101
 */

class Main {
	
	static public var TAP:Point = new Point();
	
	public static function main () {
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Game());
	}
	
}
