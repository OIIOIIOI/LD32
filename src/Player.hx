package  ;

import com.haxepunk.graphics.Spritemap;

/**
 * ...
 * @author 01101101
 */
class Player extends MovingEntity {
	
	public function new (x:Float=0, y:Float=0) {
		super(x, y);
		
		speed = 0.8;
		friction = 0.8;
		
		setHitbox(32, 32, -16, -16);
		
		spritemap = new Spritemap("img/player.png", 32, 32);
		spritemap.add(MovingEntity.A_IDLE, [0]);
		spritemap.originX = 16;
		spritemap.originY = 16;
		
		spritemap.play(MovingEntity.A_IDLE);
		addGraphic(spritemap);
		
		centerOrigin();
	}
	
}
