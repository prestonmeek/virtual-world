package;

import openfl.Assets;

import openfl.display.MovieClip;

import openfl.text.TextField;

import motion.Actuate;

import motion.easing.Linear;

class Player extends MovieClip {
    private var body: MovieClip;
    private var username: TextField;
    private var speed: Int;

    public function new(name: String) {
        super();

        speed = 350;

        body = Assets.getMovieClip('lib:Body');

        body.x = 500;
        body.y = 200;

        username = cast(Assets.getMovieClip('lib:Username').getChildByName('Text'), TextField);
        username.text = name;

        body.addChild(username);

        this.addChild(body);
    }

    public function move(x: Float, y: Float) {
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