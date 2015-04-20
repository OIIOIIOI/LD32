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
class CreditsScreen extends Scene {
	
	var background:Entity;
	var chars:Entity;
	var bubbles:Entity;
	var bar:Entity;
	var title:Entity;
	
	var backButton:ClickableEntity;
	
	public function new () {
		super();
		
		SoundMan.playMenuLevel();
		
		HXP.screen.scale = 1;
		
		// Splash
		var i = new Image("img/credits_bg.png");
		i.centerOrigin();
		i.originY = 0;
		background = new Entity(0, 0, i);
		background.x = 500;
		
		i = new Image("img/credits_chars.png");
		i.centerOrigin();
		chars = new Entity(0, 0, i);
		chars.x = 500;
		chars.y = 440;
		
		i = new Image("img/credits_bubbles.png");
		i.centerOrigin();
		bubbles = new Entity(0, 0, i);
		bubbles.x = 500;
		bubbles.y = 280;
		
		i = new Image("img/credits_title.png");
		i.centerOrigin();
		title = new Entity(0, 0, i);
		title.x = 850;
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
		backButton.x = 650;
		backButton.y = bar.y + 4;
		
		// Add splash elements
		add(background);
		add(chars);
		add(bubbles);
		add(bar);
		add(title);
		add(backButton);
	}
	
	override public function update ()  {
		super.update();
		
		background.x = HXP.scaleClamp(mouseX, 0, 1000, 525, 475);//50
		chars.x = HXP.scaleClamp(mouseX, 0, 1000, 320, 260);//60
		bubbles.x = HXP.scaleClamp(mouseX, 0, 1000, 370, 300);//70
	}
	
	function goBack () {
		SoundMan.nav();
		SoundMan.playMenuLevel(true);
		removeAll();
		HXP.scene = new SplashScreen(2);
	}
	
}