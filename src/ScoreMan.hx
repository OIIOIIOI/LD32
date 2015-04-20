package ;

import com.haxepunk.HXP;

/**
 * ...
 * @author 01101101
 */
class ScoreMan {
	
	static public var score(default, null):Int;
	static public var combo(default, null):Int;
	static public var chain(default, null):Int;
	static public var comboSteps:Array<Int>;
	
	static public function reset () {
		score = 0;
		combo = 1;
		chain = 0;
		comboSteps = [0, 1, 2, 3, 4, 5];
	}
	
	static public function awardShot (e:Enemy) {
		chain++;
		if (chain >= comboSteps[combo]) {
			combo++;
			// Update GUI
			cast(HXP.scene, Protrotrype).scoreText.setCombo(combo);
		}
		var pts = 1234 * combo;
		score += pts;
		// Spawn hit text
		HXP.scene.add(new HitText(e.centerX, e.top, Std.string(pts)));
		// Update GUI
		cast(HXP.scene, Protrotrype).scoreText.setScore(Std.string(score));
	}
	
	static public function comboBreak () {
		chain = 0;
		combo = 1;
		// Update GUI
		cast(HXP.scene, Protrotrype).scoreText.setCombo(combo);
	}
	
}
