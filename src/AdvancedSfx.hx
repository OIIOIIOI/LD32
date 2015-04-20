package ;

import com.haxepunk.Sfx;
import openfl.media.Sound;

/**
 * ...
 * @author 01101101
 */
class AdvancedSfx extends Sfx {
	
	public function new (source:Dynamic, complete:Void->Void=null) {
		super(source, complete);
	}
	
	public function getSound () :Sound {
		return _sound;
	}
	
}