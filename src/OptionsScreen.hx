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
class OptionsScreen extends Scene {
	
	var background:Entity;
	var char:Entity;
	var bar:Entity;
	var title:Entity;
	
	var sfxText:Entity;
	var musicText:Entity;
	var shakeText:Entity;
	
	var musicSlider:OptionSlider;
	var sfxSlider:OptionSlider;
	var shakeSlider:OptionSlider;
	
	var backButton:ClickableEntity;
	
	public function new () {
		super();
		
		SoundMan.playMenuOptions();
		
		HXP.screen.scale = 1;
		
		// Splash
		var i = new Image("img/options_bg.png");
		i.centerOrigin();
		i.originY = 0;
		background = new Entity(0, 0, i);
		background.x = 500;
		
		i = new Image("img/options_char.png");
		i.centerOrigin();
		char = new Entity(0, 0, i);
		char.x = 700;
		char.y = 315;
		
		i = new Image("img/options_title.png");
		i.centerOrigin();
		title = new Entity(0, 0, i);
		title.x = 170;
		title.y = 80;
		
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
		backButton.x = 370;
		backButton.y = bar.y + 4;
		
		// Options
		var t = new Text("MUSIC VOLUME");
		t.font = "fonts/MesquiteStd.otf";
		t.color = 0xFFFFFF;
		t.size = 60;
		t.originX = t.width;
		musicText = new Entity(0, 0, t);
		musicText.y = 250;
		
		var t = new Text("SFX VOLUME");
		t.font = "fonts/MesquiteStd.otf";
		t.color = 0xFFFFFF;
		t.size = 60;
		t.originX = t.width;
		sfxText = new Entity(0, 0, t);
		sfxText.y = 315;
		
		var t = new Text("SHAKE AMOUNT");
		t.font = "fonts/MesquiteStd.otf";
		t.color = 0xFFFFFF;
		t.size = 60;
		t.originX = t.width;
		shakeText = new Entity(0, 0, t);
		shakeText.y = 380;
		
		musicSlider = new OptionSlider();
		musicSlider.clickHandler = tweakVolumeMusic;
		musicSlider.y = musicText.y + 3;
		
		sfxSlider = new OptionSlider();
		sfxSlider.clickHandler = tweakVolumeSFX;
		sfxSlider.y = sfxText.y + 3;
		
		shakeSlider = new OptionSlider();
		shakeSlider.clickHandler = tweakShake;
		shakeSlider.y = shakeText.y + 3;
		
		// Add elements
		add(background);
		add(char);
		add(bar);
		add(title);
		add(backButton);
		add(sfxText);
		add(musicText);
		add(shakeText);
		add(musicSlider);
		add(sfxSlider);
		add(shakeSlider);
	}
	
	override public function update ()  {
		super.update();
		
		background.x = HXP.scaleClamp(mouseX, 0, 1000, 525, 475);//50
		char.x = HXP.scaleClamp(mouseX, 0, 1000, 800, 730);//70
		musicText.x = sfxText.x = shakeText.x = HXP.scaleClamp(mouseX, 0, 1000, 310, 220);//90
		musicSlider.x = sfxSlider.x = shakeSlider.x = musicText.x + 30;
	}
	
	function tweakVolumeMusic () {
		SoundMan.setMusicVol(musicSlider.value);
		SoundMan.nav(true);
		//trace(musicSlider.value);
	}
	
	function tweakVolumeSFX () {
		SoundMan.setSFXVol(sfxSlider.value);
		SoundMan.nav(true);
		//trace(sfxSlider.value);
	}
	
	function tweakShake () {
		SoundMan.nav(true);
		//trace(shakeSlider.value);
	}
	
	function goBack () {
		SoundMan.nav();
		SoundMan.playMenuOptions(true);
		removeAll();
		HXP.scene = new SplashScreen(2);
	}
	
}