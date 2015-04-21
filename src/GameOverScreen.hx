package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import openfl.display.BitmapData;

/**
 * ...
 * @author 01101101
 */
class GameOverScreen extends Scene {
	
	var bg:Entity;
	
	public function new (win:Bool, capture:BitmapData) {
		super();
		
		if (win)	SoundMan.win();
		else		SoundMan.lose();
		
		HXP.screen.scale = 1;
		
		var i = new Image(capture);
		i.angle = 5;
		bg = new Entity(0, 0, i);
		add(bg);
	}
	
}