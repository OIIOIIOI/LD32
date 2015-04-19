package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.ColorTween;
import com.haxepunk.tweens.misc.VarTween;

/**
 * ...
 * @author 01101101
 */
class ScoreText extends Entity {
	
	var pointsText:Text;
	var pointsShadow:Text;
	
	var comboText:Text;
	var comboShadow:Text;
	
	var pointsTween:ColorTween;
	var comboTween:ColorTween;
	
	public function new () {
		super();
		
		// Points
		
		pointsText = new Text("0");
		pointsText.color = 0xFFFFFF;
		pointsText.size = 24;
		
		pointsShadow = new Text(pointsText.text);
		pointsShadow.color = 0x000000;
		pointsShadow.size = pointsText.size;
		pointsShadow.y = pointsText.y + 3;
		pointsShadow.alpha = 0.25;
		
		addGraphic(pointsShadow);
		addGraphic(pointsText);
		
		// Combo
		
		comboText = new Text("");
		comboText.color = 0xFFFFFF;
		comboText.size = 16;
		comboText.y = 24;
		
		comboShadow = new Text(comboText.text);
		comboShadow.color = 0x000000;
		comboShadow.size = comboText.size;
		comboShadow.y = comboText.y + 2;
		comboShadow.alpha = 0.25;
		
		addGraphic(comboShadow);
		addGraphic(comboText);
		
		// Tweens
		
		pointsTween = new ColorTween(null, TweenType.Persist);
		pointsTween.tween(1, 0xffcc00, 0xFFFFFF);
		addTween(pointsTween);
		
		comboTween = new ColorTween(null, TweenType.Persist);
		comboTween.tween(1, 0xffaa00, 0xFFFFFF);
		addTween(comboTween);
		
		layer = -10000;
	}
	
	public function setScore (s:String) {
		pointsText.text = s;
		pointsShadow.text = pointsText.text;
		pointsTween.start();
	}
	
	public function setCombo (i:Int) {
		if (i <= 1)	comboText.text = "";
		else		comboText.text = i + "x COMBO";
		comboShadow.text = comboText.text;
		comboTween.start();
	}
	
	override public function update () :Void {
		super.update();
		
		pointsText.color = pointsTween.color;
		comboText.color = comboTween.color;
	}
	
}
