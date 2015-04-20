package ;

import com.anttikupila.media.CustomSoundFX;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import openfl.Assets;
import openfl.media.SoundChannel;

/**
 * ...
 * @author 01101101
 */
class SoundMan {
	
	static public var MUSIC_VOL(default, null):Float = 1;
	static public var SFX_VOL(default, null):Float = 1;
	
	static var menuMood:Sfx;
	static var menuSplash:Sfx;
	static var menuLevel:Sfx;
	static var menuOptions:Sfx;
	static var menuCredits:Sfx;
	
	static var musicSFX:AdvancedSfx;
	//static var musicSFX:CustomSoundFX;
	//static var musicChannel:SoundChannel;
	
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
	static var navSFX:Sfx;
	
	public static function init () {
		menuMood = new Sfx(Assets.getSound("snd/MenuMood.mp3"));
		menuSplash = new Sfx(Assets.getSound("snd/MenuSplash.mp3"));
		menuLevel = new Sfx(Assets.getSound("snd/MenuLevel.mp3"));
		menuOptions = new Sfx(Assets.getSound("snd/MenuOptions.mp3"));
		menuCredits = new Sfx(Assets.getSound("snd/MenuCredits.mp3"));
		
		musicSFX = new AdvancedSfx(Assets.getSound("snd/v2.mp3"));
		//musicSFX = new CustomSoundFX(asfx.getSound());
		
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
		
		navSFX = new Sfx(Assets.getSound("snd/Navigation.mp3"));
	}
	
	public static function setMusicVol (v:Float) {
		//trace(v);
		apply(v);
		MUSIC_VOL = v;
	}
	
	public static function setSFXVol (v:Float) {
		//apply(v);
		SFX_VOL = v;
	}
	
	static function apply (v:Float) {
		// Set to normal volume * new MUSIC_VOL
		menuMood.volume = menuMood.volume / MUSIC_VOL * v;
		menuSplash.volume = menuSplash.volume / MUSIC_VOL * v;
		menuLevel.volume = menuLevel.volume / MUSIC_VOL * v;
		menuOptions.volume = menuOptions.volume / MUSIC_VOL * v;
		menuCredits.volume = menuCredits.volume / MUSIC_VOL * v;
		musicSFX.volume = musicSFX.volume / MUSIC_VOL * v;
		//musicSFX.
	}
	
	public static function playMenuMood (stop:Bool = false, vol:Float = 0.2, pan:Float = 0) {
		if (stop)	menuMood.stop();
		else		menuMood.play(vol*MUSIC_VOL, pan, true);
	}
	public static function playMenuSplash (stop:Bool = false, vol:Float = 0.2, pan:Float = 0) {
		if (stop)	menuSplash.stop();
		else		menuSplash.play(vol*MUSIC_VOL, pan, true);
	}
	public static function playMenuLevel (stop:Bool = false, vol:Float = 0.2, pan:Float = 0) {
		if (stop)	menuLevel.stop();
		else		menuLevel.play(vol*MUSIC_VOL, pan, true);
	}
	public static function playMenuOptions (stop:Bool = false, vol:Float = 0.2, pan:Float = 0) {
		if (stop)	menuOptions.stop();
		else		menuOptions.play(vol*MUSIC_VOL, pan, true);
	}
	public static function playMenuCredits (stop:Bool = false, vol:Float = 0.2, pan:Float = 0) {
		if (stop)	menuCredits.stop();
		else		menuCredits.play(vol*MUSIC_VOL, pan, true);
	}
	
	public static function playMusic (vol:Float = 0.2, pan:Float = 0) {
		musicSFX.play(vol*MUSIC_VOL, pan, true);
		//musicChannel = musicSFX.play();
	}
	
	public static function swap (vol:Float = 0.3, pan:Float = 0) { swapSFX.play(vol*SFX_VOL, pan); }
	
	public static function shoot (vol:Float = 0.3, pan:Float = 0) {
		shootSFX[Std.random(shootSFX.length)].play(vol*SFX_VOL, pan);
	}
	
	public static function enemyDie (vol:Float = 0.2, pan:Float = 0) {
		enemyHurtSFX[Std.random(enemyHurtSFX.length)].play(vol*SFX_VOL, pan);
		enemyDieSFX.play(vol*SFX_VOL, pan);
	}
	
	public static function banditShoot (vol:Float = 0.3, pan:Float = 0) { banditShootSFX.play(vol*SFX_VOL, pan); }
	public static function indianShoot (vol:Float = 0.3, pan:Float = 0) { indianShootSFX.play(vol*SFX_VOL, pan); }
	public static function mexicanShoot (vol:Float = 0.3, pan:Float = 0) { mexicanShootSFX.play(vol*SFX_VOL, pan); }
	
	public static function wallImpact (vol:Float = 0.3, pan:Float = 0) {
		wallImpactSFX[Std.random(wallImpactSFX.length)].play(vol*SFX_VOL, pan);
	}
	
	public static function reflectBullet (vol:Float = 0.3, pan:Float = 0) { reflectBulletSFX.play(vol*SFX_VOL, pan); }
	
	public static function playerImpact (vol:Float = 0.2, pan:Float = 0) { playerImpactSFX.play(vol*SFX_VOL, pan); }
	
	public static function playerHurt (vol:Float = 0.2, pan:Float = 0) {
		playerHurtSFX[Std.random(playerHurtSFX.length)].play(vol * SFX_VOL, pan);
	}
	
	public static function playerDie (vol:Float = 0.25, pan:Float = 0) { playerDieSFX.play(vol*SFX_VOL, pan); }
	
	public static function walkOnSand (vol:Float = 0.15, pan:Float = 0) {
		if (!walkOnSandSFX.playing)	walkOnSandSFX.play(vol * SFX_VOL, pan, true);
	}
	public static function stopOnSand () {
		if (walkOnSandSFX.playing)	walkOnSandSFX.stop();
	}
	
	public static function nav (splash:Bool = false, vol:Float = 0.3, pan:Float = 0) {
		if (splash)	navSFX.play(vol*SFX_VOL, pan);
		else		indianShootSFX.play(vol*SFX_VOL, pan);
	}
	
}
