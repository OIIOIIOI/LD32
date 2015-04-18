package ;

import com.haxepunk.Entity;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.errors.Error;
import openfl.geom.Point;
import Protrotrype;

/**
 * ...
 * @author 01101101
 */
class Level {
	
	public static var GRID_SIZE:Int = 32;
	
	public var width:Int;
	public var height:Int;
	
	public var entities(default, null):Array<Entity>;
	public var enemies(default, null):Array<Entity>;
	
	public var startingPos(default, null):Point;
	
	var data:BitmapData;
	
	public function new (n:Int) {
		data = Assets.getBitmapData("img/level" + n + ".png");
		if (data == null)	throw new Error("Level not found");
		
		entities = new Array();
		enemies = new Array();
		startingPos = new Point();
		
		width = data.width * GRID_SIZE;
		height = data.height * GRID_SIZE;
		var p:UInt = 0;
		var e:Entity;
		for (yy in 0...data.height) {
			for (xx in 0...data.width) {
				p = data.getPixel(xx, yy);
				if (p == 0x000000) {
					e = new Wall(xx * GRID_SIZE, yy * GRID_SIZE);
					entities.push(e);
				} else if (p == 0xFF0000) {
					e = new Enemy(xx * GRID_SIZE, yy * GRID_SIZE, Color.RED);
					enemies.push(e);
				} else if (p == 0xFFFF00) {
					e = new Enemy(xx * GRID_SIZE, yy * GRID_SIZE, Color.YELLOW);
					enemies.push(e);
				} else if (p == 0x0000FF) {
					e = new Enemy(xx * GRID_SIZE, yy * GRID_SIZE, Color.BLUE);
					enemies.push(e);
				} else if (p == 0x00FF00) {
					startingPos.x = xx * GRID_SIZE;
					startingPos.y = yy * GRID_SIZE;
				}
			}
		}
	}
	
}