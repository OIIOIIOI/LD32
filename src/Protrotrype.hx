package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
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
	
	public var particles(default, null):ParticleMan;
	
	public var level:Level;
	
	var bloodLayer:Entity;
	
	var player:Player;
	
	var camCoeff:Float;
	var gameRunning:Bool;
	
	var cursor:Entity;
	public var scoreText:ScoreText;
	
	public function new () {
		super();
		
		HXP.screen.scale = 2;
		
		VIEW_WIDTH = Std.int(HXP.windowWidth / HXP.screen.scale);
		VIEW_HEIGHT = Std.int(HXP.windowHeight / HXP.screen.scale);
		
		ScoreMan.init();
		
		particles = new ParticleMan();
		add(particles);
		
		level = new Level(3);
		// Add flood
		add(level.floor);
		level.floor.layer = 999;
		// Add blood layer
		bloodLayer = new Entity(0, 0, particles.bloodEmitter);
		add(bloodLayer);
		bloodLayer.layer = 989;
		// Add entities
		for (e in level.entities) {
			add(e);
		}
		// Add enemies
		for (e in level.enemies) {
			add(e);
		}
		
		player = new Player(level.startingPos.x, level.startingPos.y);
		add(player);
		
		cursor = new Entity(0, 0, new Image("img/cursor.png"));
		cursor.layer = -99999;
		add(cursor);
		
		scoreText = new ScoreText();
		scoreText.x = camera.x;
		scoreText.y = camera.y;
		add(scoreText);
		
		camCoeff = 0.2;
		gameRunning = true;
	}
	
	override public function update ()  {
		super.update();
		
		if (gameRunning && !player.isDead() && !player.isStunned()) {
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
				Main.TAP.x = this.mouseX - player.x;
				Main.TAP.y = this.mouseY - player.y + 8;
				Main.TAP.normalize(16);
				var b = new Bullet(player.x + Main.TAP.x, player.y + 8 + Main.TAP.y, player.currentColor);
				Main.TAP.normalize(b.speed);
				b.dx = Main.TAP.x;
				b.dy = Main.TAP.y;
				add(b);
				// Recoil
				Main.TAP.normalize(3);
				player.dx -= Main.TAP.x;
				player.dy -= Main.TAP.y;
				player.cycleColors();
				// Shake
				HXP.screen.shake(1, 0.2);
			}
			
			// Swap
			if (Input.rightMousePressed) {
				player.swapColors();
			}
			
			// Camera
			Main.TAP.x = HXP.camera.x + (Main.TAP.x - HXP.camera.x) * camCoeff;
			Main.TAP.x = HXP.clamp(player.x - VIEW_WIDTH / 2, 0, level.width - VIEW_WIDTH);
			Main.TAP.y = HXP.camera.y + (Main.TAP.y - HXP.camera.y) * camCoeff;
			Main.TAP.y = HXP.clamp(player.y - VIEW_HEIGHT / 2, 0, level.height - VIEW_HEIGHT);
			HXP.setCamera(Std.int(Main.TAP.x), Std.int(Main.TAP.y));
			
			// Score
			scoreText.x = camera.x + 5;
			scoreText.y = camera.y;
		}
		
		// Particles
		if (Math.abs(player.dx) > 0.5 || Math.abs(player.dy) > 0.5)	particles.walk(player);
		
		cursor.x = mouseX - 6;
		cursor.y = mouseY - 6;
	}
	
	public function gameOver (win:Bool) {
		//gameRunning = false;
		
		/*HXP.screen.scale = 1;
		VIEW_WIDTH = Std.int(HXP.windowWidth / HXP.screen.scale);
		VIEW_HEIGHT = Std.int(HXP.windowHeight / HXP.screen.scale);*/
		
		/*HXP.setCamera(-(VIEW_WIDTH - level.width)/2, -(VIEW_HEIGHT - level.height)/2);
		
		var title = new Text("Level cleared");
		title.font = "fonts/MANIFESTO.ttf";
		title.color = 0x000000;
		title.size = 60;
		title.centerOrigin();
		var e = new Entity(HXP.halfWidth - HXP.camera.x / 4, HXP.halfHeight, title);
		e.layer = -9999;
		add(e);*/
	}
	
}

enum Color {
	RED;
	YELLOW;
	BLUE;
	WHITE;
}
