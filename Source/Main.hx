package;

import openfl.Assets;
import openfl.Lib;
import openfl.display.MovieClip;
import openfl.display.Stage;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite {
    public var NOMINAL_WIDTH: Int = 1600;
    public var NOMINAL_HEIGHT: Int = 1200;

    private var chat: Chat;
    public var background: Background;

    private var client: Client;

	public function new() {
        super();

        stage.addEventListener(Event.RESIZE, onResize);

        client = new Client(this);
    }

    public function setupExtras(): Void {
        chat = new Chat(this);
        background = new Background(this);

        var ordering = new MovieClip();     // allows us to ensure the order of the background and chat

        ordering.addChild(background.fill);
        ordering.addChild(chat);
        ordering.addChild(background.border);

        addChild(ordering);
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