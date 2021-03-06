package ;

import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.RenderMode;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import openfl.ui.Mouse;

/**
 * ...
 * @author 01101101
 */
class Game extends Engine {
	
	static public var SHAKENESS:Float = 1;
	
	public function new () {
		super(1000, 600);
		
		/*HXP.console.enable();
		HXP.console.debugDraw = true;
		HXP.console.toggleKey = Key.TAB;*/
		
		HXP.screen.color = 0xFFFFFF;
		
		Input.define("up", [Key.UP, Key.Z, Key.W]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("down", [Key.DOWN, Key.S]);
		Input.define("left", [Key.LEFT, Key.Q, Key.A]);
		Input.define("enter", [Key.SPACE, Key.ENTER, Key.NUMPAD_ENTER]);
		
		LevelMan.init();
		
		SoundMan.init();
		SoundMan.playMenuMood();
		//SoundMan.playMusic();
		
		HXP.scene = new SplashScreen();
		//HXP.scene = new Protrotrype();
		//HXP.scene = new CreditsScreen();
		//HXP.scene = new OptionsScreen();
		//HXP.scene = new LevelScreen();
		//HXP.scene = new GameOverScreen(true);
	}
	
	override public function update () {
		SoundMan.update();
		return super.update();
	}
	
}
