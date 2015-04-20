package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;

/**
 * ...
 * @author 01101101
 */
class LevelNumber extends Entity {
	
	var text:Text;
	
	public function new (x:Float=0, y:Float=0) {
		super(x, y);
		
		var i = new Image("img/bg_lvl_number.png");
		i.centerOrigin();
		i.originY += 10;
		addGraphic(i);
		
		text = new Text("#" + LevelMan.index);
		text.font = "fonts/MesquiteStd.otf";
		text.color = 0xFFFFFF;
		text.size = 96;
		text.centerOrigin();
		addGraphic(text);
	}
	
	public function refresh () {
		text.text = "#" + LevelMan.index;
		text.centerOrigin();
	}
	
}