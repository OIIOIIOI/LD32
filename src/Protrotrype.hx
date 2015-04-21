package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import Bullet;
import openfl.ui.Mouse;

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
	
	//public var level:LevelExt;
	public var level:Level;
	
	var bloodLayer:Entity;
	
	var player:Player;
	
	var gameRunning:Bool;
	
	public var cursor:Cursor;
	
	public var scoreText:ScoreText;
	
	public function new () {
		super();
		
		HXP.screen.color = 0xa53c34;
		
		gameRunning = false;
		
		// Particles
		particles = new ParticleMan();
		
		// Generate level
		ready = false;
		//level = new LevelExt(loaded);
		//level = new Level(LevelMan.index, true);
		level = new Level(LevelMan.index);
		loaded();
	}
	
	var ready:Bool;
	
	function loaded () {
		// Add blood layer
		bloodLayer = new Entity(0, 0, particles.bloodEmitter);
		
		// Cursor
		cursor = new Cursor();
		
		// Score
		scoreText = new ScoreText();
		scoreText.x = camera.x;
		scoreText.y = camera.y;
		
		// Music
		SoundMan.playMusic();// TODO check if already playing from previous level
		
		// Reset
		reset();
		
		ready = true;
	}
	
	function reset () {
		removeAll();
		
		// Screen
		HXP.screen.scale = 2;
		VIEW_WIDTH = Std.int(HXP.windowWidth / HXP.screen.scale);
		VIEW_HEIGHT = Std.int(HXP.windowHeight / HXP.screen.scale);
		
		// Scores
		ScoreMan.reset();
		scoreText.setScore("0");
		scoreText.setCombo(1);
		add(scoreText);
		
		// Particles
		add(particles);
		
		// Add flood
		add(level.floor);
		level.floor.layer = 999;
		
		// Blood layer
		add(bloodLayer);
		bloodLayer.layer = 989;
		
		// Add entities
		var a = new Array<Entity>();
		a = a.concat(level.entities);
		for (e in a) {
			add(e);
		}
		// Add enemies
		for (e in level.enemies) {
			add(cast(e, Enemy).clone());
		}
		
		// Player
		if (player != null) {
			remove(player);
			player = null;
		}
		player = new Player(level.startingPos.x, level.startingPos.y);
		player.x += Level.GRID_SIZE / 2;
		player.y += Level.GRID_SIZE / 2;
		add(player);
		
		// Cursor color
		cursor.changeColor(player.currentColor);
		add(cursor);
		Mouse.hide();
		
		// Start
		gameRunning = true;
	}
	
	override public function update ()  {
		if (!ready)	return;
		
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
			
			// Particles
			if (Math.abs(player.dx) > 0.5 || Math.abs(player.dy) > 0.5)	particles.walk(player);
			
			// Shoot
			if (Input.mousePressed) {
				Main.TAP.x = this.mouseX - player.x;
				Main.TAP.y = this.mouseY - player.y + 8;
				Main.TAP.normalize(16);
				// Spawn bullet
				var b = new Bullet(player.x + Main.TAP.x, player.y + 8 + Main.TAP.y, player.currentColor);
				Main.TAP.x = this.mouseX - b.x;
				Main.TAP.y = this.mouseY - b.y;
				
				Main.TAP.normalize(b.speed);
				b.dx = Main.TAP.x;
				b.dy = Main.TAP.y;
				add(b);
				// Recoil
				Main.TAP.normalize(3);
				player.dx -= Main.TAP.x;
				player.dy -= Main.TAP.y;
				player.cycleColors();
				cursor.changeColor(player.currentColor);
				// Shake
				HXP.screen.shake(Math.ceil(1 * Game.SHAKENESS), 0.1 * Game.SHAKENESS);
				// Sound
				SoundMan.shoot();
			}
			
			// Swap
			if (Input.rightMousePressed) {
				player.swapColors();
				cursor.changeColor(player.currentColor);
				// Sound
				SoundMan.swap();
			}
			
			// Camera
			Main.TAP.x = HXP.camera.x + (Main.TAP.x - HXP.camera.x) * 0.2;
			Main.TAP.x = HXP.clamp(player.x - VIEW_WIDTH / 2, 0, level.width - VIEW_WIDTH);
			Main.TAP.y = HXP.camera.y + (Main.TAP.y - HXP.camera.y) * 0.2;
			Main.TAP.y = HXP.clamp(player.y - VIEW_HEIGHT / 2, 0, level.height - VIEW_HEIGHT);
			HXP.setCamera(Std.int(Main.TAP.x), Std.int(Main.TAP.y));
			
			// Score
			scoreText.x = camera.x + 5;
			scoreText.y = camera.y;
		}
		
		cursor.x = mouseX - 6;
		cursor.y = mouseY - 6;
	}
	
	var restart:ClickableEntity;
	
	public function gameOver (win:Bool) {
		// Stop the game
		gameRunning = false;
		
		// Get the mouse back
		remove(cursor);
		Mouse.show();
		
		var bd = HXP.buffer.clone();
		
		if (win) LevelMan.index++;
		
		HXP.screen.color = 0xffffff;
		removeAll();
		HXP.scene = new GameOverScreen(win, bd);
		
		// Capture?
		/*var bd = HXP.buffer.clone();
		
		removeAll();
		
		camera.setTo(0, 0);
		HXP.screen.scale = 1;
		VIEW_WIDTH = Std.int(HXP.windowWidth / HXP.screen.scale);
		VIEW_HEIGHT = Std.int(HXP.windowHeight / HXP.screen.scale);
		
		var i = new Image(bd);
		i.scale = 2;
		var e = new Entity(0, 0, i);
		add(e);
		
		// Display lose screen
		if (!win) {
			if (restart == null) {
				var button = new Text("RESTART");
				button.font = "fonts/MesquiteStd.otf";
				button.color = 0;
				button.size = 50;
				button.centerOrigin();
				restart = new ClickableEntity(camera.x + VIEW_WIDTH / 2, camera.y + VIEW_HEIGHT / 2, button);
				restart.clickHandler = reset;
				restart.layer = -99999;
			}
			add(restart);
		}
		// Display win screen
		else {
			trace("restart level, start next level, back to start screen?");
			// TODO if not restart level, clean for real
		}*/
	}
	
}

enum Color {
	RED;
	YELLOW;
	BLUE;
	WHITE;
}
