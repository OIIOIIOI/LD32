package ;

import Bullet;

/**
 * ...
 * @author 01101101
 */
class BulletPool {
	
	var list:Array<BulletColor>;
	
	public function new () {
		list = new Array();
		fill();
	}
	
	function fill () {
		for (i in 0...10) {
			list.push(switch (Std.random(3)) {
				case 0:		BulletColor.BLUE;
				case 1:		BulletColor.RED;
				default:	BulletColor.YELLOW;
			});
		}
	}
	
	public function getNext () :BulletColor {
		if (list.length == 0)	fill();
		return list.shift();
	}
	
}
