package ;

import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.RenderMode;
import com.haxepunk.utils.Input;
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
		
		HXP.screen.color = 0xAF8F69;
		
		Input.define("up", [Key.UP, Key.Z, Key.W]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("down", [Key.DOWN, Key.S]);
		Input.define("left", [Key.LEFT, Key.Q, Key.A]);
		Input.define("enter", [Key.SPACE, Key.ENTER, Key.NUMPAD_ENTER]);
		
		HXP.scene = new Protrotrype();
		//HXP.scene = new MenuScreen();
	}
	
}
