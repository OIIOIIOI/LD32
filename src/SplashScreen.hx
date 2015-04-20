package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import haxe.Timer;
import openfl.display.BitmapData;

/**
 * ...
 * @author 01101101
 */
class SplashScreen extends Scene {
	
	var background:Entity;
	var char:Entity;
	var bar:Entity;
	var title:ClickableEntity;
	
	var startButton:ClickableEntity;
	
	var step:Int;
	
	public function new () {
		super();
		
		HXP.screen.scale = 1;
		
		// Splash
		
		var i = new Image("img/splash.png");
		i.centerOrigin();
		i.originY = 0;
		background = new Entity(0, 0, i);
		background.x = 500;
		
		i = new Image("img/splash_char.png");
		i.centerOrigin();
		char = new Entity(0, 0, i);
		char.x = 500;
		char.y = 315;
		
		i = new Image("img/splash_title.png");
		i.centerOrigin();
		title = new ClickableEntity(0, 0, i);
		title.clickHandler = makeRoomForMenu;
		title.x = 500;
		title.y = 520;
		
		i = new Image(new BitmapData(1000, 14, false, 0xff000000));
		i.centerOrigin();
		bar = new Entity(0, 0, i);
		bar.x = 500;
		bar.y = title.y;
		
		// Menu
		
		var t = new Text("START");
		t.font = "fonts/MesquiteStd.otf";
		t.color = 0xFFFFFF;
		t.size = 48;
		t.centerOrigin();
		startButton = new ClickableEntity(0, 0, t);
		startButton.y = bar.y + 4;
		
		// Add splash elements
		
		add(background);
		add(char);
		add(bar);
		add(title);
		
		step = 0;
	}
	
	override public function update ()  {
		super.update();
		
		if (step == 0) {
			background.x = HXP.scaleClamp(mouseX, 0, 1000, 525, 475);
			char.x = HXP.scaleClamp(mouseX, 0, 1000, 535, 465);
			title.x = HXP.scaleClamp(mouseX, 0, 1000, 550, 450);
			if (Input.released("enter")) {
				makeRoomForMenu();
			}
		} else if (step == 1) {
			background.x += (500 - background.x) * 0.1;
			char.x += (270 - char.x) * 0.1;
			title.x += (270 - title.x) * 0.1;
			cast(bar.graphic, Image).scaleY += (5 - cast(bar.graphic, Image).scaleY) * 0.1;
			if (5 - cast(bar.graphic, Image).scaleY < 0.01) {
				displayMenu1();
			}
		}
	}
	
	function makeRoomForMenu () {
		SoundMan.nav();
		step++;
		title.clickHandler = null;
	}
	
	function displayMenu1 () {
		step++;
		startButton.x = 580;
		add(startButton);
		//startButton.clickHandler = startGame;
		HXP.screen.shake(2, 0.2);
		SoundMan.playerImpact();
		Timer.delay(displayMenu2, 100);
	}
	
	function displayMenu2 () {
		//step++;
		startButton.x = 730;
		//add(startButton);
		//startButton.clickHandler = startGame;
		HXP.screen.shake(2, 0.2);
		SoundMan.playerImpact();
		Timer.delay(displayMenu3, 350);
	}
	
	function displayMenu3 () {
		//step++;
		startButton.x = 880;
		//add(startButton);
		startButton.clickHandler = startGame;
		HXP.screen.shake(2, 0.2);
		SoundMan.playerImpact();
		//Timer.delay(displayMenu2, 250);
	}
	
	function startGame () {
		SoundMan.nav();
		removeAll();
		HXP.scene = new Protrotrype();
	}
	
}
