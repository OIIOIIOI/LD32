package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.errors.Error;
import openfl.filters.BlurFilter;
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
	
	public var floor:Entity;
	public var floorData:BitmapData;
	
	static var bloodStains:Array<BitmapData>;
	
	public function new (n:Int) {
		data = Assets.getBitmapData("img/level" + n + ".png");
		if (data == null)	throw new Error("Level not found");
		
		if (bloodStains == null)	initBloodStains();
		
		entities = new Array();
		enemies = new Array();
		startingPos = new Point();
		
		width = data.width * GRID_SIZE;
		height = data.height * GRID_SIZE;
		
		var fd = Assets.getBitmapData("img/floor.png");
		floorData = new BitmapData(width, height, false, 0xFFFFFFFF);
		for (yy in 0...Math.ceil(height / fd.height)) {
			Main.TAP.y = yy * fd.height;
			for (xx in 0...Math.ceil(width / fd.width)) {
				Main.TAP.x = xx * fd.width;
				floorData.copyPixels(fd, fd.rect, Main.TAP);
			}
		}
		floor = new Entity(0, 0, new Image(floorData));
		entities.push(floor);
		
		var p:UInt = 0;
		var e:Entity;
		for (yy in 0...data.height) {
			for (xx in 0...data.width) {
				p = data.getPixel(xx, yy);
				if (p == 0x000000) {
					var p2 = data.getPixel(xx, yy + 1);
					e = new Wall(xx * GRID_SIZE, yy * GRID_SIZE, (p2 == 0x000000));
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
	
	public function initBloodStains () {
		bloodStains = new Array();
		var bd = Assets.getBitmapData("img/blood.png");
		var hor = Std.int(bd.width / 40);
		var ver = Std.int(bd.height / 32);
		var stain:BitmapData;
		Main.TAP.x = Main.TAP.y = 0;
		Main.TAR.width = 40;
		Main.TAR.height = 32;
		for (yy in 0...ver) {
			Main.TAR.y = yy * 32;
			for (xx in 0...hor) {
				Main.TAR.x = xx * 40;
				stain = new BitmapData(40, 32, true, 0x00000000);
				stain.copyPixels(bd, Main.TAR, Main.TAP);
				bloodStains.push(stain);
			}
		}
	}
	
	public function paintBlood (e:Enemy, n:Int = 3) {
		for (i in 0...n) {
			Main.TAP.x = e.x - Std.random(20);
			Main.TAP.y = e.y - Std.random(20);
			var index = switch (e.weakColor) {
				case Color.RED:		0;
				case Color.YELLOW:	3;
				default:			6;
			}
			index += Std.random(3);
			floorData.copyPixels(bloodStains[index], bloodStains[index].rect, Main.TAP, null, null, true);
		}
		floor.graphic.destroy();
		floor.graphic = null;
		floor.graphic = new Image(floorData);
	}
	
}
