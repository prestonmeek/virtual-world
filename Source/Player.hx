package;

import openfl.Assets;
import openfl.display.MovieClip;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.text.TextField;

import motion.Actuate;
import motion.easing.Linear;

class Player extends MovieClip {
    public var id: String;

    private var client: Client;
    private var sprite: Main;

    private var body: MovieClip;
    private var textname: String;       // actual displayed name as a string
    private var username: TextField;    // textfield for the displayed name
    private var speed: Int;

    public function new(client: Client, name: String) {
        super();
        
        this.client = client;
        sprite = client.sprite;

        textname = name;
    }
    
    // sets up everything except the mouse event listener. that happens separately (see Client.hx) since it only happens once
    public function setup(x: Float, y: Float, id: String): Void {
        speed = 350;

        body = Assets.getMovieClip('lib:Avatar');

        body.x = x;
        body.y = y;

        username = cast(Assets.getMovieClip('lib:Username').getChildByName('Text'), TextField);
        username.text = textname;

        body.addChild(username);

        addChild(body);
        
        sprite.addChild(this);

        this.id = id;
    }

    public function addMouseEventListener(): Void {
        sprite.stage.addEventListener(MouseEvent.CLICK, handleMovement);
    }

    private function handleMovement(?event: MouseEvent): Void {
        if (event.target == sprite.background.fill) {    // if the click is within the border
            var coords: Point = globalToLocal(new Point(event.stageX, event.stageY));

            client.send({
                action: 'move',
                id: id,
                coords: coords
            });
        }
    }

    public function move(coords: Point) {
        var x: Float = coords.x;
        var y: Float = coords.y;
        var time: Float;

        var xDist: Float = Math.abs(body.x - x);
        var yDist: Float = Math.abs(body.y - y);

        if (xDist > yDist)
            time = xDist / speed;
        else
            time = yDist / speed;

        Actuate.tween(body, time, {x: x, y: y}).ease(Linear.easeNone);
    }
}