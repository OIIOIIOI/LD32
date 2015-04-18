package ;

import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
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
	
	var player:Player;
	var gun:Gun;
	
	var tick:Float;
	
	public function new () {
		super();
		
		VIEW_WIDTH = Std.int(HXP.screen.width / HXP.screen.scale);
		VIEW_HEIGHT = Std.int(HXP.screen.height / HXP.screen.scale);
		
		Input.define("up", [Key.UP, Key.Z, Key.W]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("down", [Key.DOWN, Key.S]);
		Input.define("left", [Key.LEFT, Key.Q, Key.A]);
		
		player = new Player(VIEW_WIDTH / 2, VIEW_HEIGHT / 2);
		add(player);
		
		gun = new Gun(player.x, player.y);
		gun.updateColors(player.nextColor, player.currentColor);
		add(gun);
		
		tick = 0;
	}
	
	override public function update ()  {
		super.update();
		
		tick += HXP.elapsed;
		if (tick >= 3) {
			spawnEnemy();
			tick -= 3;
		}
		
		// Player movement
		Main.TAP.x = Main.TAP.y = 0;
		if (Input.check("up"))		Main.TAP.y -= player.speed * HXP.elapsed;
		if (Input.check("right"))	Main.TAP.x += player.speed * HXP.elapsed;
		if (Input.check("down"))	Main.TAP.y += player.speed * HXP.elapsed;
		if (Input.check("left"))	Main.TAP.x -= player.speed * HXP.elapsed;
		Main.TAP.normalize(player.speed);
		player.dx += Main.TAP.x;
		player.dy += Main.TAP.y;
		
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
	
	function spawnEnemy () {
		var e = new Enemy(Std.random(VIEW_WIDTH - 100) + 100, Std.random(VIEW_HEIGHT - 100) + 100);
		add(e);
	}
	
}

enum Color {
	RED;
	YELLOW;
	BLUE;
}
