package ;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.utils.Ease;
import Protrotrype;

/**
 * ...
 * @author 01101101
 */
class ParticleMan extends Entity {
	
	var walkEmitter:Emitter;
	var walkTick:Int;
	
	var bulletHitEmitter:Emitter;
	
	public var bloodEmitter:Emitter;
	
	public function new () {
		super();
		
		walkEmitter = new Emitter("img/sand_part.png", 8, 8);
		walkEmitter.newType("sand_part", [0, 1, 2, 3]);
		walkEmitter.setAlpha("sand_part", 1, 0);
		addGraphic(walkEmitter);
		walkTick = 0;
		
		bulletHitEmitter = new Emitter("img/hit_part.png", 8, 8);
		bulletHitEmitter.newType("hit_part", [0, 1, 2, 3]);
		bulletHitEmitter.setAlpha("hit_part", 1, 0.5);
		bulletHitEmitter.setGravity("hit_part", 2);
		addGraphic(bulletHitEmitter);
		
		bloodEmitter = new Emitter("img/blood.png", 40, 32);
		bloodEmitter.newType("a", [0]);
		bloodEmitter.newType("b", [1]);
		bloodEmitter.newType("c", [2]);
		bloodEmitter.setAlpha("a", 0.4, 0);
		bloodEmitter.setAlpha("b", 0.4, 0);
		bloodEmitter.setAlpha("c", 0.4, 0);
		//addGraphic(bloodEmitter);
		
		layer = -9999;
	}
	
	public function bulletHit (b:Bullet) {
		var c = switch (b.color) {
			case Color.WHITE:	0xFFFFFF;
			case Color.BLUE:	0x0776f9;
			case Color.RED:		0xc32a01;
			case Color.YELLOW:	0x81bd36;
		}
		
		var a = Math.atan2(b.dy, -b.dx) * 180 / Math.PI;
		for (i in 0...10) {
			bulletHitEmitter.setColor("hit_part", c, c);
			bulletHitEmitter.setMotion("hit_part", a - 45, 32, 0.4, 90, 16, 0.4, Ease.quadOut);
			bulletHitEmitter.emit("hit_part", b.x, b.y);
		}
	}
	
	public function walk (e:MovingEntity) {
		walkTick++;
		if (walkTick > 1000)	walkTick -= 1000;
		if (walkTick % 5 != 0)	return;
		
		var a = Math.atan2(e.dy, -e.dx) * 180 / Math.PI;
		walkEmitter.setMotion("sand_part", a, 8, 1, 0, 4, 0, Ease.quadOut);
		walkEmitter.emitInCircle("sand_part", e.centerX, e.bottom + 4, 8);
	}
	
	public function bloodStains (e:Enemy) {
		bloodEmitter.setMotion("a", 0, 0, 5);
		bloodEmitter.setMotion("b", 0, 0, 5);
		bloodEmitter.setMotion("c", 0, 0, 5);
		for (i in 0...6) {
			var a:String = switch (Std.random(3)) {
				case 0:		"a";
				case 1:		"b";
				default:	"c";
			}
			bloodEmitter.emitInCircle(a, e.x, e.bottom, 20);
		}
	}
	
}
