package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import haxe.Timer;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.net.URLLoader;

/**
 * ...
 * @author 01101101
 */
class SplashScreen extends Scene {
	
	var background:Entity;
	var char:Entity;
	var bar:Entity;
	var title:Entity;
	
	var startButton:ClickableEntity;
	var optionsButton:ClickableEntity;
	var creditsButton:ClickableEntity;
	
	var step:Int;
	
	public function new (s:Int = 0) {
		super();
		
		SoundMan.playMenuSplash();
		
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
		title = new Entity(0, 0, i);
		//title.clickHandler = makeRoomForMenu;
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
		t.angle = (Std.random(3) + 1) * (Std.random(2) * 2 - 1);
		startButton = new ClickableEntity(0, 0, t);
		startButton.y = bar.y + 4;
		
		t = new Text("OPTIONS");
		t.font = "fonts/MesquiteStd.otf";
		t.color = 0xFFFFFF;
		t.size = 48;
		t.centerOrigin();
		t.angle = (Std.random(3) + 1) * (Std.random(2) * 2 - 1);
		optionsButton = new ClickableEntity(0, 0, t);
		optionsButton.y = bar.y + 4;
		
		t = new Text("CREDITS");
		t.font = "fonts/MesquiteStd.otf";
		t.color = 0xFFFFFF;
		t.size = 48;
		t.centerOrigin();
		t.angle = (Std.random(3) + 1) * (Std.random(2) * 2 - 1);
		creditsButton = new ClickableEntity(0, 0, t);
		creditsButton.y = bar.y + 4;
		
		// Add splash elements
		add(background);
		add(char);
		add(bar);
		add(title);
		
		step = s;
		if (step == 2) {
			title.x = 270;
			cast(bar.graphic, Image).scaleY = 5;
			startButton.x = 590;
			add(startButton);
			optionsButton.x = 740;
			add(optionsButton);
			creditsButton.x = 890;
			add(creditsButton);
			startButton.clickHandler = startGame;
			optionsButton.clickHandler = goOptions;
			creditsButton.clickHandler = goCredits;
		}
	}
	
	override public function update ()  {
		super.update();
		
		if (step == 0 && Input.mousePressed) {
			makeRoomForMenu();
		}
		
		background.x = HXP.scaleClamp(mouseX, 0, 1000, 525, 475);//50
		if (step > 0)	char.x = HXP.scaleClamp(mouseX, 0, 1000, 305, 235);//70
		
		if (step == 0) {
			char.x = HXP.scaleClamp(mouseX, 0, 1000, 535, 465);//70
			title.x = HXP.scaleClamp(mouseX, 0, 1000, 550, 450);//100
			if (Input.released("enter")) {
				makeRoomForMenu();
			}
		} else if (step == 1) {
			title.x += (270 - title.x) * 0.1;
			cast(bar.graphic, Image).scaleY += (5 - cast(bar.graphic, Image).scaleY) * 0.2;
			if (5 - cast(bar.graphic, Image).scaleY < 0.01) {
				displayMenu1();
			}
		}
	}
	
	function makeRoomForMenu () {
		SoundMan.nav();
		step++;
	}
	
	function displayMenu1 () {
		step++;
		startButton.x = 590;
		add(startButton);
		//
		HXP.screen.shake(Math.ceil(2 * Game.SHAKENESS), 0.2 * Game.SHAKENESS);
		SoundMan.playerImpact();
		Timer.delay(displayMenu2, 75);
	}
	
	function displayMenu2 () {
		optionsButton.x = 740;
		add(optionsButton);
		//
		HXP.screen.shake(Math.ceil(2 * Game.SHAKENESS), 0.2 * Game.SHAKENESS);
		SoundMan.playerImpact();
		Timer.delay(displayMenu3, 350);
	}
	
	function displayMenu3 () {
		creditsButton.x = 890;
		add(creditsButton);
		//
		startButton.clickHandler = startGame;
		optionsButton.clickHandler = goOptions;
		creditsButton.clickHandler = goCredits;
		//
		HXP.screen.shake(Math.ceil(2 * Game.SHAKENESS), 0.2 * Game.SHAKENESS);
		SoundMan.playerImpact();
	}
	
	function startGame () {
		SoundMan.nav(true);
		SoundMan.playMenuSplash(true);
		removeAll();
		HXP.scene = new Protrotrype();
	}
	
	function goOptions () {
		SoundMan.nav(true);
		SoundMan.playMenuSplash(true);
		removeAll();
		HXP.scene = new OptionsScreen();
	}
	
	function goCredits () {
		SoundMan.nav(true);
		SoundMan.playMenuSplash(true);
		removeAll();
		HXP.scene = new CreditsScreen();
	}
	
}
