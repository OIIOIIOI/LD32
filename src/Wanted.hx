package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.net.URLLoader;

/**
 * ...
 * @author 01101101
 */
class Wanted extends Entity {
	
	static public var T_SCORE:String = "t_score";
	static public var T_TIME:String = "t_time";
	
	var theType:String;
	
	var bg:Image;
	var pseudoTF:Text;
	var descTF:Text;
	var valueTF:Text;
	
	public function new (t:String, x:Float = 0, y:Float = 0) {
		super ();
		
		theType = t;
		
		bg = new Image("img/level_wanted.png");
		bg.centerOrigin();
		//bg.angle = rotation;
		addGraphic(bg);
		
		pseudoTF = new Text("");
		pseudoTF.font = "fonts/MesquiteStd.otf";
		pseudoTF.color = 0x000000;
		pseudoTF.size = 70;
		pseudoTF.centerOrigin();
		//pseudoTF.originY = -0;
		//pseudoTF.angle = rotation;
		addGraphic(pseudoTF);
		
		if (theType == T_SCORE)	descTF = new Text("AND HIS HIGHEST SCORE OF");
		else					descTF = new Text("AND HIS LOWEST TIME OF");
		descTF.font = "fonts/MesquiteStd.otf";
		descTF.color = 0x000000;
		descTF.size = 42;
		descTF.centerOrigin();
		descTF.originY = -65;
		//descTF.angle = rotation;
		addGraphic(descTF);
		
		valueTF = new Text("");
		valueTF.font = "fonts/MesquiteStd.otf";
		valueTF.color = 0x000000;
		valueTF.size = 80;
		valueTF.centerOrigin();
		valueTF.originY = -110;
		//valueTF.angle = rotation;
		addGraphic(valueTF);
		
		refresh();
	}
	
	public function refresh () {
		ScoreMan.get(LevelMan.index, gotTheScores, fail);
	}
	
	function fail (e:Event) {
		var pseudo:String = (theType == T_SCORE) ? "NO CONNECTION" : "NO CONNECTION";
		var value:Int = 0;
		var rotation = Std.random(4) + 2;
		if (theType == T_SCORE)	rotation = -rotation;
		bg.angle = pseudoTF.angle = descTF.angle = valueTF.angle = rotation;
		
		pseudoTF.text = pseudo;
		pseudoTF.centerOrigin();
		
		valueTF.text = Std.string(value);
		valueTF.centerOrigin();
		valueTF.originY = -110;
		
		graphic.y = 200 + Std.random(20);
	}
	
	function gotTheScores (e:Event) {
		var l:URLLoader = cast(e.currentTarget);
		var pseudo = "XXX";
		var value = 999;
		if (theType == T_SCORE) {
			pseudo = l.data.sp;
			value = l.data.sv;
		} else  {
			pseudo = l.data.tp;
			value = l.data.tv;
		}
		
		var rotation = Std.random(4) + 2;
		if (theType == T_SCORE)	rotation = -rotation;
		bg.angle = pseudoTF.angle = descTF.angle = valueTF.angle = rotation;
		
		pseudoTF.text = pseudo;
		pseudoTF.centerOrigin();
		
		valueTF.text = Std.string(value);
		valueTF.centerOrigin();
		valueTF.originY = -110;
		
		graphic.y = 200 + Std.random(20);
	}
	
}
