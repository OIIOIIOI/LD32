package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.filters.BlurFilter;
import openfl.geom.Point;
import openfl.net.URLRequest;
import Protrotrype;

/**
 * ...
 * @author 01101101
 */
class LevelExt {
	
	public static var GRID_SIZE:Int = 32;
	
	public var width:Int;
	public var height:Int;
	
	public var entities(default, null):Array<Entity>;
	public var enemies(default, null):Array<Entity>;
	
	public var startingPos(default, null):Point;
	
	var data:BitmapData;
	
	public var floor:Entity;
	public var floorData:BitmapData;
	
	var call:Void->Void;
	
	public function new (cb:Void->Void) {
		call = cb;
		
		var l = new Loader();
		l.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
		//l.load(new URLRequest("../../../assets/img/level1.png"));
		l.load(new URLRequest("level99.png"));
	}
	
	function loaded (ev:Event) {
		data = cast(cast(ev.currentTarget.loader, Loader).content, Bitmap).bitmapData;
		//data = cast(ev.currentTarget, Loader).content
		
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
					//var full = data.getPixel(xx, yy + 1) == 0x000000;
					//var top = full && data.getPixel(xx, yy - 1) != 0x000000;
					//var both = data.getPixel(xx, yy + 1) != 0x000000 && data.getPixel(xx, yy - 1) != 0x000000;
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
				} else if (p == 0x00FF00) {
					startingPos.x = xx * GRID_SIZE;
					startingPos.y = yy * GRID_SIZE;
				} else if (p != 0xFFFFFF) {
					e = new DesertStuff(xx * GRID_SIZE, yy * GRID_SIZE, p);
					entities.push(e);
				}
			}
		}
		
		if (call != null) call();
	}
	
}
