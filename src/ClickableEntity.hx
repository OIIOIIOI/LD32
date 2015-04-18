package ;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.utils.Input;

/**
 * ...
 * @author 01101101
 */
class ClickableEntity extends Entity {
	
	public var clickHandler:Void->Void;
	
	public function new (x:Float=0, y:Float=0, graphic:Graphic=null) {
		super(x, y, graphic);
		if (graphic != null)	setHitboxTo(graphic);
	}
	
	override public function update () :Void {
		super.update();
		
		if (clickHandler != null && Input.mouseReleased && collidePoint(x, y, scene.mouseX, scene.mouseY)) {
			clickHandler();
		}
	}
	
}