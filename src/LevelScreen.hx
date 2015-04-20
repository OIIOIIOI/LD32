package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import openfl.display.BitmapData;

/**
 * ...
 * @author 01101101
 */
class LevelScreen extends Scene {
	
	var background:Entity;
	var bar:Entity;
	var title:ClickableEntity;
	
	var backButton:ClickableEntity;
	var prevButton:ClickableEntity;
	var nextButton:ClickableEntity;
	
	public function new () {
		super();
		
		SoundMan.playMenuLevel();
		
		HXP.screen.scale = 1;
		
		// Splash
		var i = new Image("img/level_bg.png");
		i.centerOrigin();
		i.originY = 0;
		background = new Entity(0, 0, i);
		background.x = 500;
		
		i = new Image("img/level_title.png");
		i.centerOrigin();
		title = new ClickableEntity(0, 0, i);
		title.clickHandler = startGame;
		title.x = 500;
		title.y = 520;
		
		i = new Image(new BitmapData(1000, 70, false, 0xff000000));
		i.centerOrigin();
		bar = new Entity(0, 0, i);
		bar.x = 500;
		bar.y = title.y;
		
		// Menu
		var t = new Text("BACK");
		t.font = "fonts/MesquiteStd.otf";
		t.color = 0xFFFFFF;
		t.size = 48;
		t.centerOrigin();
		t.angle = (Std.random(3) + 1) * (Std.random(2) * 2 - 1);
		backButton = new ClickableEntity(0, 0, t);
		backButton.clickHandler = goBack;
		backButton.x = 50;
		backButton.y = bar.y + 4;
		
		t = new Text(" < ");
		t.font = "fonts/MesquiteStd.otf";
		t.color = 0xFFFFFF;
		t.size = 96;
		t.centerOrigin();
		t.angle = (Std.random(3) + 1) * (Std.random(2) * 2 - 1);
		prevButton = new ClickableEntity(0, 0, t);
		prevButton.clickHandler = selectNext.bind(-1);
		prevButton.x = 260;
		prevButton.y = bar.y + 4;
		
		t = new Text(" > ");
		t.font = "fonts/MesquiteStd.otf";
		t.color = 0xFFFFFF;
		t.size = 96;
		t.centerOrigin();
		t.angle = (Std.random(3) + 1) * (Std.random(2) * 2 - 1);
		nextButton = new ClickableEntity(0, 0, t);
		nextButton.clickHandler = selectNext.bind(1);
		nextButton.x = 740;
		nextButton.y = bar.y + 4;
		
		// Add splash elements
		add(background);
		add(bar);
		add(title);
		add(backButton);
		add(prevButton);
		add(nextButton);
		
		selectNext(0);
	}
	
	override public function update ()  {
		super.update();
		
		background.x = HXP.scaleClamp(mouseX, 0, 1000, 525, 475);//50
	}
	
	function selectNext (delta:Int) {
		LevelMan.index = Std.int(HXP.clamp(LevelMan.index + delta, 0, LevelMan.max));
		
		cast(prevButton.graphic, Text).alpha = cast(nextButton.graphic, Text).alpha = 1;
		if (LevelMan.index == 0) {
			cast(prevButton.graphic, Text).alpha = 0.2;
		} else if (LevelMan.index == LevelMan.max) {
			cast(nextButton.graphic, Text).alpha = 0.2;
		}
	}
	
	function startGame () {
		SoundMan.nav(true);
		SoundMan.playMenuLevel(true);
		removeAll();
		HXP.scene = new Protrotrype();
	}
	
	function goBack () {
		SoundMan.nav();
		SoundMan.playMenuLevel(true);
		removeAll();
		HXP.scene = new SplashScreen(2);
	}
	
}