package ;

import com.haxepunk.graphics.Spritemap;

/**
 * ...
 * @author 01101101
 */
class DesertStuff extends MovingEntity {
	
	var item:UInt;
	
	public function new (x:Float = 0, y:Float = 0, i:UInt) {
		super(x, y);
		
		item = i;
		
		// HITBOX
		switch (item) {
			case 0x777777:
				setHitbox(24, 24, 12, 12);
				type = Protrotrype.T_WALLS;
			case 0x555555:
				setHitbox(24, 24, 12, 12);
				type = Protrotrype.T_WALLS;
			default:
		}
		
		// SPRITEMAP
		spritemap = switch (item) {
			case 0x999999:	new Spritemap("img/desert_skull.png", 39, 18);
			case 0x888888:	new Spritemap("img/desert_tree_01.png", 32, 67);
			case 0x777777:	new Spritemap("img/desert_tree_02.png", 42, 63);
			case 0x666666:	new Spritemap("img/desert_sand_castle.png", 45, 20);
			case 0x555555:	new Spritemap("img/desert_totem.png", 43, 50);
			case 0x444444:	new Spritemap("img/desert_chariot.png", 33, 31);
			default:		new Spritemap("img/unknown.png", 32, 32);
		}
		spritemap.add(MovingEntity.A_IDLE, [0]);
		spritemap.x = -spritemap.width / 2;
		spritemap.y = -spritemap.height + Player.ORIG_Y;
		
		addGraphic(spritemap);
		
		this.x += Level.GRID_SIZE / 2;
		this.y += Level.GRID_SIZE - Player.ORIG_Y;
	}
	
}
