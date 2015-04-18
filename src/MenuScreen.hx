package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

/**
 * ...
 * @author 01101101
 */
class MenuScreen extends Scene {
	
	var title:Text;
	var startButton:Text;
	var optionsButton:Text;
	var creditsButton:Text;
	
	var menu:Array<Text>;
	var menuIndex:Int;
	
	public function new () {
		super();
		
		HXP.screen.scale = 1;
		
		menu = new Array();
		menuIndex = 0;
		
		title = new Text("LUDUM DARE 32");
		title.font = "fonts/MANIFESTO.ttf";
		title.color = 0x000000;
		title.size = 80;
		title.centerOrigin();
		var e = new Entity(HXP.halfWidth, 150, title);
		add(e);
		
		startButton = new Text("START");
		startButton.font = "fonts/MANIFESTO.ttf";
		startButton.color = 0;
		startButton.size = 30;
		startButton.centerOrigin();
		menu.push(startButton);
		e = new ClickableEntity(HXP.halfWidth, 300, startButton);
		cast(e, ClickableEntity).clickHandler = startGame;
		add(e);
		
		optionsButton = new Text("OPTIONS");
		optionsButton.font = "fonts/MANIFESTO.ttf";
		optionsButton.color = 0x666666;
		optionsButton.size = 30;
		optionsButton.centerOrigin();
		menu.push(optionsButton);
		e = new ClickableEntity(HXP.halfWidth, 350, optionsButton);
		add(e);
		
		creditsButton = new Text("CREDITS");
		creditsButton.font = "fonts/MANIFESTO.ttf";
		creditsButton.color = 0x666666;
		creditsButton.size = 30;
		creditsButton.centerOrigin();
		menu.push(creditsButton);
		e = new ClickableEntity(HXP.halfWidth, 400, creditsButton);
		add(e);
	}
	
	override public function update ()  {
		super.update();
		
		var old:Int = menuIndex;
		if (Input.pressed("up") && menuIndex > 0) {
			menuIndex--;
			menu[old].color = 0x666666;
			menu[menuIndex].color = 0;
		} else if (Input.pressed("down") && menuIndex < menu.length - 1) {
			menuIndex++;
			menu[old].color = 0x666666;
			menu[menuIndex].color = 0;
		} else if (Input.released("enter") && menuIndex == 0) {
			startGame();
		}
	}
	
	function startGame () {
		removeAll();
		
		HXP.scene = new Protrotrype();
	}
	
}
