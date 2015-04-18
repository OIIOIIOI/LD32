package ;

import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import Bullet;

/**
 * ...
 * @author 01101101
 */
class Protrotrype extends Scene {
	
	public static var VIEW_WIDTH:Int;
	public static var VIEW_HEIGHT:Int;
	
	public static var T_PLAYER_BULLET:String = "t_player_bullet";
	public static var T_ENEMY_BULLET:String = "t_enemy_bullet";
	public static var T_PLAYER:String = "t_player";
	public static var T_ENEMY:String = "t_enemy";
	public static var T_WALLS:String = "t_walls";
	
	public var level:Level;
	
	var player:Player;
	var gun:Gun;
	
	public function new () {
		super();
		
		HXP.screen.scale = 2;
		
		VIEW_WIDTH = Std.int(HXP.screen.width / HXP.screen.scale);
		VIEW_HEIGHT = Std.int(HXP.screen.height / HXP.screen.scale);
		
		level = new Level(1);
		for (e in level.entities) {
			add(e);
		}
		
		player = new Player(level.startingPos.x, level.startingPos.y);
		add(player);
		
		gun = new Gun(player.x, player.y);
		gun.updateColors(player.nextColor, player.currentColor);
		add(gun);
	}
	
	override public function update ()  {
		super.update();
		
		// Player movement
		Main.TAP.x = Main.TAP.y = 0;
		if (Input.check("up"))		Main.TAP.y -= player.speed * HXP.elapsed;
		if (Input.check("right"))	Main.TAP.x += player.speed * HXP.elapsed;
		if (Input.check("down"))	Main.TAP.y += player.speed * HXP.elapsed;
		if (Input.check("left"))	Main.TAP.x -= player.speed * HXP.elapsed;
		Main.TAP.normalize(player.speed);
		player.dx += Main.TAP.x;
		player.dy += Main.TAP.y;
		
		// Camera
		Main.TAP.x = HXP.clamp(player.x - VIEW_WIDTH / 2, 0, level.width - VIEW_WIDTH);
		Main.TAP.x = HXP.camera.x + (Main.TAP.x - HXP.camera.x) * 0.2;
		Main.TAP.y = HXP.clamp(player.y - VIEW_HEIGHT / 2, 0, level.height - VIEW_HEIGHT);
		Main.TAP.y = HXP.camera.y + (Main.TAP.y - HXP.camera.y) * 0.2;
		HXP.setCamera(Std.int(Main.TAP.x), Std.int(Main.TAP.y));
		
		// Gun
		gun.x = player.x;
		gun.y = player.y;
		gun.layer = player.layer - 1;
		var a = Math.atan2(player.y - this.mouseY, this.mouseX - player.x) * 180 / Math.PI;
		cast(gun.graphic, Spritemap).angle = a;
		
		// Shoot
		if (Input.mousePressed) {
			var b = new Bullet(player.x, player.y, player.currentColor);
			Main.TAP.x = this.mouseX - player.x;
			Main.TAP.y = this.mouseY - player.y;
			Main.TAP.normalize(b.speed);
			b.dx = Main.TAP.x;
			b.dy = Main.TAP.y;
			add(b);
			
			player.cycleColors();
			gun.updateColors(player.nextColor, player.currentColor);
		}
		
		// Swap
		if (Input.rightMousePressed) {
			player.swapColors();
			gun.updateColors(player.nextColor, player.currentColor);
		}
	}
	
}

enum Color {
	RED;
	YELLOW;
	BLUE;
	WHITE;
}
