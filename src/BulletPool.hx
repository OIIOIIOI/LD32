package ;

import Bullet;
import Protrotrype;

/**
 * ...
 * @author 01101101
 */
class BulletPool {
	
	var list:Array<Color>;
	
	public function new () {
		list = new Array();
		fill();
	}
	
	function fill () {
		for (i in 0...10) {
			list.push(switch (Std.random(3)) {
				case 0:		Color.BLUE;
				case 1:		Color.RED;
				default:	Color.YELLOW;
			});
		}
	}
	
	public function getNext () :Color {
		if (list.length == 0)	fill();
		return list.shift();
	}
	
}
