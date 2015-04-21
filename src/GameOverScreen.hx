package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import haxe.Timer;
import openfl.display.BitmapData;

/**
 * ...
 * @author 01101101
 */
class GameOverScreen extends Scene {
	
	var win:Bool;
	
	var background:Entity;
	var title:Entity;
	var bar:Entity;
	var nextButton:ClickableEntity;
	var retryButton:ClickableEntity;
	var quitButton:ClickableEntity;
	
	public function new (won:Bool, ?capture:BitmapData) {
		super();
		
		win = won;
		
		HXP.screen.scale = 1;
		
		var i:Image;
		
		if (capture != null) {
			i = new Image(capture);
			i.centerOrigin();
			i.scale = 2.5;
			background = new Entity(0, 0, i);
			background.y = 300;
			add(background);
		}
		
		i = new Image("img/gameover_title.png");
		i.centerOrigin();
		title = new Entity(0, 0, i);
		title.x = 200;
		title.y = 520;
		
		i = new Image(new BitmapData(1000, 70, false, 0xff000000));
		i.centerOrigin();
		bar = new Entity(0, 0, i);
		bar.x = 500;
		bar.y = title.y;
		
		// Menu
		var t:Text;
		var xStart = 420;
		
		if (LevelMan.index < LevelMan.max) {
			t = new Text("NEXT");
			t.font = "fonts/MesquiteStd.otf";
			t.color = 0xFFFFFF;
			t.size = 48;
			t.centerOrigin();
			t.angle = (Std.random(3) + 1) * (Std.random(2) * 2 - 1);
			nextButton = new ClickableEntity(xStart, 0, t);
			nextButton.y = bar.y + 4;
			nextButton.clickHandler = nextLevel.bind(1);
			xStart += 100;
		}
		
		t = new Text("RETRY");
		t.font = "fonts/MesquiteStd.otf";
		t.color = 0xFFFFFF;
		t.size = 48;
		t.centerOrigin();
		t.angle = (Std.random(3) + 1) * (Std.random(2) * 2 - 1);
		retryButton = new ClickableEntity(xStart, 0, t);
		retryButton.y = bar.y + 4;
		retryButton.clickHandler = nextLevel.bind(0);
		xStart += 100;
		
		t = new Text("QUIT");
		t.font = "fonts/MesquiteStd.otf";
		t.color = 0xFFFFFF;
		t.size = 48;
		t.centerOrigin();
		t.angle = (Std.random(3) + 1) * (Std.random(2) * 2 - 1);
		quitButton = new ClickableEntity(xStart, 0, t);
		quitButton.y = bar.y + 4;
		quitButton.clickHandler = quit;
		
		// Add splash elements
		if (background != null)	add(background);
		add(bar);
		add(title);
		
		SoundMan.stopOnSand();
		activateFilter();
		Timer.delay(playJingle, 1000);
	}
	
	function nextLevel (inc:Int) {
		LevelMan.index += inc;
		SoundMan.nav(true);
		SoundMan.setFilter(22000);
		removeAll();
		HXP.scene = new Protrotrype();
	}
	
	function quit () {
		SoundMan.nav(true);
		SoundMan.setFilter(22000);
		SoundMan.musicSFX.soundChannel.stop();
		removeAll();
		HXP.scene = new SplashScreen(2);
	}
	
	override public function update ()  {
		super.update();
		
		if (background != null)	background.x = HXP.scaleClamp(mouseX, 0, 1000, 525, 475);//50
	}
	
	function activateFilter () {
		SoundMan.setFilter(100);
	}
	
	function playJingle () {
		if (win) {
			SoundMan.win();
			Timer.delay(deactivateFilter, 5000);
		} else {
			SoundMan.lose();
			Timer.delay(deactivateFilter, 5000);
		}
	}
	
	function deactivateFilter () {
		SoundMan.setFilter(800);
		if (nextButton != null)	add(nextButton);
		add(retryButton);
		add(quitButton);
	}
	
}