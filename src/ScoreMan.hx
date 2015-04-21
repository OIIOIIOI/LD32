package ;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import openfl.events.Event;

/**
 * ...
 * @author 01101101
 */
class ScoreMan {
	
	static public var score(default, null):Int;
	static public var combo(default, null):Int;
	static public var chain(default, null):Int;
	static public var comboSteps:Array<Int>;
	
	static public function reset () {
		score = 0;
		combo = 1;
		chain = 0;
		comboSteps = [0, 2, 5, 9, 13, 19];
	}
	
	static public function awardShot (e:Entity, white:Bool = false) {
		chain++;
		if (chain >= comboSteps[combo]) {
			combo++;
			// Update GUI
			cast(HXP.scene, Protrotrype).scoreText.setCombo(combo);
		}
		var pts = 101 * combo;
		if (white)	pts = 164 * combo;
		score += pts;
		// Spawn hit text
		HXP.scene.add(new HitText(e.centerX, e.top, Std.string(pts)));
		// Update GUI
		cast(HXP.scene, Protrotrype).scoreText.setScore(Std.string(score));
	}
	
	static public function comboBreak () {
		chain = 0;
		combo = 1;
		// Update GUI
		cast(HXP.scene, Protrotrype).scoreText.setCombo(combo);
	}
	
	static public function save (level:Int, pseudo:String, score:Int, time:Int, ?cb:Event->Void, ?failcb:IOErrorEvent->Void) {
		var vars:URLVariables = new URLVariables();
		vars.level = level;
		vars.pseudo = pseudo;
		vars.score = score;
		vars.time = time;
		
		var req:URLRequest = new URLRequest("save.php");
		req.method = URLRequestMethod.POST;
		req.data = vars;
		
		var loader:URLLoader = new URLLoader();
		loader.dataFormat = URLLoaderDataFormat.VARIABLES;
		if (cb != null)	loader.addEventListener(Event.COMPLETE, cb);
		if (failcb != null)	loader.addEventListener(IOErrorEvent.IO_ERROR, failcb);
		else				loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		loader.load(req);
	}
	
	static public function get (level:Int, ?cb:Event->Void, ?failcb:IOErrorEvent->Void) {
		var vars:URLVariables = new URLVariables();
		vars.level = level;
		
		var req:URLRequest = new URLRequest("getScores.php");
		req.method = URLRequestMethod.POST;
		req.data = vars;
		
		var loader:URLLoader = new URLLoader();
		loader.dataFormat = URLLoaderDataFormat.VARIABLES;
		if (cb != null)		loader.addEventListener(Event.COMPLETE, cb);
		if (failcb != null)	loader.addEventListener(IOErrorEvent.IO_ERROR, failcb);
		else				loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		loader.load(req);
	}
	
	static function errorHandler (e:IOErrorEvent) { trace(e); }
	
	//ScoreMan.get.bind(11, gotTheScores);
	//ScoreMan.save.bind(11, "01101101", Std.random(999999), Std.random(999999));
	/*function gotTheScores (e:Event) {
		var l:URLLoader = cast(e.currentTarget);
		trace(l.data.sp + ", " + l.data.sv + ", " + l.data.tp + ", " + l.data.tv);
	}*/
	
}
