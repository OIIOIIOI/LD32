package ;

import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import openfl.display.BitmapData;

/**
 * ...
 * @author 01101101
 */
class OptionSlider extends ClickableEntity {
	
	var notches:Array<Image>;
	var setting:Int;
	
	public var value(get, null):Float;
	
	public function new (x:Float=0, y:Float=0) {
		super(x, y);
		
		notches = new Array();
		// Mute
		var n = new Image(new BitmapData(20, 44, false, 0xFF000000));
		addGraphic(n);
		notches.push(n);
		// Steps
		for (i in 0...5) {
			n = new Image(new BitmapData(20, 44, false, 0xFFFFFFFF));
			n.x = 30 * notches.length;
			addGraphic(n);
			notches.push(n);
		}
		
		setHitbox(170, 44);
		
		setting = 5;
		apply();
	}
	
	override public function update () :Void {
		if (Input.mouseReleased && collidePoint(x, y, scene.mouseX, scene.mouseY)) {
			setting = Std.int((scene.mouseX - x) / 30);
			apply();
		}
		super.update();
	}
	
	function apply () {
		for (i in 1...notches.length) {
			if (i <= setting) {
				notches[i].alpha = 1;
			} else {
				notches[i].alpha = 0.2;
			}
		}
	}
	
	function get_value () :Float {
		return HXP.scaleClamp(setting, 0, 5, 0.001, 1);
	}
	
}