package;

import openfl.Assets;
import openfl.display.MovieClip;
import openfl.text.TextField;
import openfl.text.TextFieldType;

class Chat extends MovieClip {
    private var sprite: Main;

    private var body: MovieClip;
    private var text: MovieClip;

    public function new(sprite: Main) {
        super();

        this.sprite = sprite;

        body = Assets.getMovieClip('lib:Chatbox');

        body.x = sprite.NOMINAL_WIDTH / 2;
        body.y = sprite.NOMINAL_HEIGHT - (body.height / 2);

        body.scaleX = 2;

        text = Assets.getMovieClip('lib:ChatText');

        var textField = cast(text.getChildByName('Text'), TextField);
        textField.type = TextFieldType.INPUT;

        text.x = sprite.NOMINAL_WIDTH / 2;
        text.y = sprite.NOMINAL_HEIGHT - (body.height / 2) + (textField.height / 4);

        addChild(body);
        addChild(text);
    }
}