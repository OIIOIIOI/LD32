package ;

import Protrotrype;

/**
 * ...
 * @author 01101101
 */
class InfoBullet extends Bullet {
	
	public function new (x:Float=0, y:Float=0, c:Color) {
		super(x, y, c);
		
		setHitbox();
		type = "";
		layer = -999;
	}
	
	override public function update () :Void {
		
	}
	
}