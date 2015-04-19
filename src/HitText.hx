package ;

import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;
import openfl.Assets;

/**
 * ...
 * @author 01101101
 */
class HitText extends MovingEntity {
	
	static var colors:Array<UInt>;
	var colIndex:Int;
	var tick:Int;
	var text:Text;
	var shadow:Text;
	
	public function new (x:Float=0, y:Float=0, s:String="") {
		super(x, y);
		
		if (colors == null) {
			colors = new Array();
			var bd = Assets.getBitmapData("img/hit_text_colors.png");
			for (i in 0...bd.width) {
				colors.push(bd.getPixel(i, 0));
				//colors.push(0xFFFFFF);
			}
		}
		colIndex = 0;
		tick = 0;
		
		text = new Text(s);
		//text.font = "fonts/MANIFESTO.ttf";
		text.color = colors[colIndex];
		text.size = 16;
		text.centerOrigin();
		
		shadow = new Text(s);
		//text.font = "fonts/MANIFESTO.ttf";
		shadow.color = 0x000000;
		shadow.size = text.size;
		shadow.centerOrigin();
		shadow.y = 2;
		shadow.alpha = 0.25;
		
		addGraphic(shadow);
		addGraphic(text);
		
		dy = -0.2;
		
		layer = -10000;
	}
	
	override public function update () :Void {
		super.update();
		
		tick++;
		if (tick % 2 == 0) {
			colIndex++;
			if (colIndex >= colors.length)	colIndex = 0;
			text.color = colors[colIndex];
		}
		if (tick > 60) {
			destroy();
		}
	}
	
	function destroy () {
		text.destroy();
		shadow.destroy();
		text = shadow = null;
		if (scene != null)	scene.remove(this);
	}
	
}
