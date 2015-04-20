package ;

import com.haxepunk.Sfx;
import openfl.Assets;

/**
 * ...
 * @author 01101101
 */
class SoundMan {
	
	static var swapSFX:Sfx;
	static var shootSFX:Array<Sfx>;
	static var enemyDieSFX:Sfx;
	static var enemyHurtSFX:Array<Sfx>;
	static var banditShootSFX:Sfx;
	static var indianShootSFX:Sfx;
	static var mexicanShootSFX:Sfx;
	static var wallImpactSFX:Array<Sfx>;
	static var reflectBulletSFX:Sfx;
	static var playerImpactSFX:Sfx;
	static var playerHurtSFX:Array<Sfx>;
	static var playerDieSFX:Sfx;
	static var walkOnSandSFX:Sfx;
	
	public static function init () {
		swapSFX = new Sfx(Assets.getSound("snd/Gun Swap.mp3"));
		
		shootSFX = new Array();
		shootSFX.push(new Sfx(Assets.getSound("snd/Gun Launch 01.mp3")));
		shootSFX.push(new Sfx(Assets.getSound("snd/Gun Launch 02.mp3")));
		shootSFX.push(new Sfx(Assets.getSound("snd/Gun Launch 03.mp3")));
		
		enemyDieSFX = new Sfx(Assets.getSound("snd/Ennemy Death Sound.mp3"));
		
		enemyHurtSFX = new Array();
		enemyHurtSFX.push(new Sfx(Assets.getSound("snd/Ennemy Ouch 01.mp3")));
		enemyHurtSFX.push(new Sfx(Assets.getSound("snd/Ennemy Ouch 02.mp3")));
		enemyHurtSFX.push(new Sfx(Assets.getSound("snd/Ennemy Ouch 03.mp3")));
		
		banditShootSFX = new Sfx(Assets.getSound("snd/Bandit Fire.mp3"));
		indianShootSFX = new Sfx(Assets.getSound("snd/Indian Fire.mp3"));
		mexicanShootSFX = new Sfx(Assets.getSound("snd/Mexican Fire.mp3"));
		
		wallImpactSFX = new Array();
		wallImpactSFX.push(new Sfx(Assets.getSound("snd/Ball on Wall 01.mp3")));
		wallImpactSFX.push(new Sfx(Assets.getSound("snd/Ball on Wall 02.mp3")));
		
		reflectBulletSFX = new Sfx(Assets.getSound("snd/Ball Rebound.mp3"));
		
		playerImpactSFX = new Sfx(Assets.getSound("snd/Heros Hurted Impact.mp3"));
		
		playerHurtSFX = new Array();
		playerHurtSFX.push(new Sfx(Assets.getSound("snd/Heros Hurted 01.mp3")));
		playerHurtSFX.push(new Sfx(Assets.getSound("snd/Heros Hurted 02.mp3")));
		playerHurtSFX.push(new Sfx(Assets.getSound("snd/Heros Hurted 03.mp3")));
		
		playerDieSFX = new Sfx(Assets.getSound("snd/Heros Death.mp3"));
		
		walkOnSandSFX = new Sfx(Assets.getSound("snd/Walk on Sand.mp3"));
	}
	
	public static function swap (vol:Float = 0.3, pan:Float = 0) { swapSFX.play(vol, pan); }
	
	public static function shoot (vol:Float = 0.3, pan:Float = 0) {
		shootSFX[Std.random(shootSFX.length)].play(vol, pan);
	}
	
	public static function enemyDie (vol:Float = 0.3, pan:Float = 0) {
		enemyHurtSFX[Std.random(enemyHurtSFX.length)].play(vol, pan);
		enemyDieSFX.play(vol, pan);
	}
	
	public static function banditShoot (vol:Float = 0.3, pan:Float = 0) { banditShootSFX.play(vol, pan); }
	public static function indianShoot (vol:Float = 0.3, pan:Float = 0) { indianShootSFX.play(vol, pan); }
	public static function mexicanShoot (vol:Float = 0.3, pan:Float = 0) { mexicanShootSFX.play(vol, pan); }
	
	public static function wallImpact (vol:Float = 0.3, pan:Float = 0) {
		wallImpactSFX[Std.random(wallImpactSFX.length)].play(vol, pan);
	}
	
	public static function reflectBullet (vol:Float = 0.3, pan:Float = 0) { reflectBulletSFX.play(vol, pan); }
	
	public static function playerImpact (vol:Float = 0.3, pan:Float = 0) { playerImpactSFX.play(vol, pan); }
	
	public static function playerHurt (vol:Float = 0.3, pan:Float = 0) {
		playerHurtSFX[Std.random(playerHurtSFX.length)].play(vol, pan);
	}
	
	public static function playerDie (vol:Float = 0.3, pan:Float = 0) { playerDieSFX.play(vol, pan); }
	
	public static function walkOnSand (vol:Float = 0.05, pan:Float = 0) {
		if (!walkOnSandSFX.playing)	walkOnSandSFX.play(vol, pan, true);
	}
	public static function stopOnSand () {
		if (walkOnSandSFX.playing)	walkOnSandSFX.stop();
	}
	
}
