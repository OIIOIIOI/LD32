package ;

import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.RenderMode;
import com.haxepunk.utils.Key;

/**
 * ...
 * @author 01101101
 */
class Game extends Engine {
	
	public function new () {
		super(1000, 600);
		
		HXP.console.enable();
		HXP.console.debugDraw = true;
		HXP.console.toggleKey = Key.TAB;
		
		HXP.screen.scale = 2;
		HXP.screen.color = 0xCCCCCC;
		
		HXP.scene = new Protrotrype();
	}
	
}
