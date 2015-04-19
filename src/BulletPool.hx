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
		var a = new Array<Color>();
		for (i in 0...4)	a.push(Color.BLUE);
		for (i in 0...4)	a.push(Color.RED);
		for (i in 0...4)	a.push(Color.YELLOW);
		while (a.length > 0) {
			list.push(a.splice(Std.random(a.length - 1), 1)[0]);
		}
		a = null;
	}
	
	public function getNext () :Color {
		if (list.length == 0)	fill();
		return list.shift();
	}
	
}
