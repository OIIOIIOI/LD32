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
	
	public var isTuto:Bool;
	
	public static function getData (n:Int) :BitmapData {
		return Assets.getBitmapData("img/level_" + n + ".png");
	}
	
	public function new (n:Int) {
		data = getData(n);
		if (data == null)	throw new Error("Level not found");
		
		entities = new Array();
		enemies = new Array();
		startingPos = new Point();
		
		width = data.width * GRID_SIZE;
		height = data.height * GRID_SIZE;
		
		var fd = Assets.getBitmapData("img/desert_floor.png");
		floorData = new BitmapData(width, height, false, 0xFFFFFFFF);
		for (yy in 0...Math.ceil(height / fd.height)) {
			Main.TAP.y = yy * fd.height;
			for (xx in 0...Math.ceil(width / fd.width)) {
				Main.TAP.x = xx * fd.width;
				floorData.copyPixels(fd, fd.rect, Main.TAP);
			}
		}
		floor = new Entity(0, 0, new Image(floorData));
		
		var p:UInt = 0;
		var e:Entity = null;
		for (yy in 0...data.height) {
			for (xx in 0...data.width) {
				p = data.getPixel(xx, yy);
				if (p == 0x000000) {
					e = new Wall(xx * GRID_SIZE, yy * GRID_SIZE, data.getPixel(xx, yy + 1), data.getPixel(xx, yy - 1));
					entities.push(e);
				} else if (p == 0xFF0000) {
					e = new Enemy(xx * GRID_SIZE, yy * GRID_SIZE, Color.RED);
					e.x += GRID_SIZE / 2;
					e.y += GRID_SIZE / 2;
					enemies.push(e);
				} else if (p == 0xFFFF00) {
					e = new Enemy(xx * GRID_SIZE, yy * GRID_SIZE, Color.YELLOW);
					e.x += GRID_SIZE / 2;
					e.y += GRID_SIZE / 2;
					enemies.push(e);
				} else if (p == 0x0000FF) {
					e = new Enemy(xx * GRID_SIZE, yy * GRID_SIZE, Color.BLUE);
					e.x += GRID_SIZE / 2;
					e.y += GRID_SIZE / 2;
					enemies.push(e);
				} else if (p == 0x990000) {
					e = new FakeEnemy(xx * GRID_SIZE, yy * GRID_SIZE, Color.RED);
					e.x += GRID_SIZE / 2;
					e.y += GRID_SIZE / 2;
					enemies.push(e);
				} else if (p == 0x999900) {
					e = new FakeEnemy(xx * GRID_SIZE, yy * GRID_SIZE, Color.YELLOW);
					e.x += GRID_SIZE / 2;
					e.y += GRID_SIZE / 2;
					enemies.push(e);
				} else if (p == 0x000099) {
					e = new FakeEnemy(xx * GRID_SIZE, yy * GRID_SIZE, Color.BLUE);
					e.x += GRID_SIZE / 2;
					e.y += GRID_SIZE / 2;
					enemies.push(e);
				} else if (p == 0xCC0000) {
					e = new Turret(xx * GRID_SIZE, yy * GRID_SIZE, Color.RED);
					e.x += GRID_SIZE / 2;
					e.y += GRID_SIZE / 2;
					enemies.push(e);
				} else if (p == 0xCCCC00) {
					e = new Turret(xx * GRID_SIZE, yy * GRID_SIZE, Color.YELLOW);
					e.x += GRID_SIZE / 2;
					e.y += GRID_SIZE / 2;
					enemies.push(e);
				} else if (p == 0x0000CC) {
					e = new Turret(xx * GRID_SIZE, yy * GRID_SIZE, Color.BLUE);
					e.x += GRID_SIZE / 2;
					e.y += GRID_SIZE / 2;
					enemies.push(e);
				} else if (p == 0x00FF00) {
					startingPos.x = xx * GRID_SIZE;
					startingPos.y = yy * GRID_SIZE;
				} else if (p != 0xFFFFFF) {
					e = new DesertStuff(xx * GRID_SIZE, yy * GRID_SIZE, p);
					entities.push(e);
				}
			}
		}
	}
	
}
