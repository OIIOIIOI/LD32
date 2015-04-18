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
	
	var bulletPool:BulletPool;
	
	var player:Player;
	
	var currentBullet:Bullet;
	var nextBullet:Bullet;
	
	public function new () {
		super();
		
		VIEW_WIDTH = Std.int(HXP.screen.width / HXP.screen.scale);
		VIEW_HEIGHT = Std.int(HXP.screen.height / HXP.screen.scale);
		
		Input.define("up", [Key.UP, Key.Z, Key.W]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("down", [Key.DOWN, Key.S]);
		Input.define("left", [Key.LEFT, Key.Q, Key.A]);
		
		bulletPool = new BulletPool();
		
		player = new Player(VIEW_WIDTH / 2, VIEW_HEIGHT / 2);
		add(player);
		
		currentBullet = new Bullet(40, 16, bulletPool.getNext());
		cast(currentBullet.graphic, Spritemap).scale = 1.5;
		add(currentBullet);
		nextBullet = new Bullet(16, 16, bulletPool.getNext());
		add(nextBullet);
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
		
		// Shoot
		if (Input.mousePressed) {
			var a = Math.atan2(player.y - this.mouseY, this.mouseX - player.x) * 180 / Math.PI;
			var b = new Bullet(player.x, player.y, currentBullet.color);
			Main.TAP.x = this.mouseX - player.x;
			Main.TAP.y = this.mouseY - player.y;
			Main.TAP.normalize(b.speed);
			b.dx = Main.TAP.x;
			b.dy = Main.TAP.y;
			add(b);
			
			cycleBullets();
		}
		
		// Swap
		if (Input.rightMousePressed) {
			swapBullets();
		}
	}
	
	function cycleBullets () {
		currentBullet.color = nextBullet.color;
		nextBullet.color = bulletPool.getNext();
	}
	
	function swapBullets () {
		var c = currentBullet.color;
		currentBullet.color = nextBullet.color;
		nextBullet.color = c;
	}
	
}
