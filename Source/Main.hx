package;

import openfl.Assets;
import openfl.Lib;

import openfl.display.MovieClip;
import openfl.display.Sprite;

import openfl.events.Event;
import openfl.events.MouseEvent;

import openfl.geom.Point;

class Main extends Sprite {
    private static inline var NOMINAL_WIDTH: Int = 1600;
    private static inline var NOMINAL_HEIGHT: Int = 1200;
    
    private var player: Player;

	public function new() {
        super();

        stage.addEventListener(Event.RESIZE, onResize);
        
        player = new Player('Preston');

        addChild(player);

        stage.addEventListener(MouseEvent.CLICK, handleMovement);
    }
    
    private function handleMovement(?event: MouseEvent): Void {
        if (event.currentTarget == event.target) {
            var coords: Point = globalToLocal(new Point(event.stageX, event.stageY));

            player.move(coords.x, coords.y);
        }
    }

    private function onResize(?event: Event): Void {
        var stageScaleX: Float = stage.stageWidth / NOMINAL_WIDTH;
        var stageScaleY: Float = stage.stageHeight / NOMINAL_HEIGHT;
        
        var stageScale: Float = Math.min(stageScaleX, stageScaleY);
        
        Lib.current.x = 0;
        Lib.current.y = 0;
        Lib.current.scaleX = stageScale;
        Lib.current.scaleY = stageScale;
        
        if (stageScaleX > stageScaleY) {
            Lib.current.x = (stage.stageWidth - NOMINAL_WIDTH * stageScale) / 2;
        } else {
            Lib.current.y = (stage.stageHeight - NOMINAL_HEIGHT * stageScale) / 2;
        }
    }
}