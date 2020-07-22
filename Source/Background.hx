package;

import openfl.Assets;
import openfl.display.MovieClip;

class Background extends MovieClip {
    private var sprite: Main;

    public var border: MovieClip;
    public var fill: MovieClip;

    public function new(sprite: Main) {
        super();

        this.sprite = sprite;

        border = Assets.getMovieClip('lib:Border');
        fill = Assets.getMovieClip('lib:Fill');

        border.x = sprite.NOMINAL_WIDTH / 2;
        border.y = sprite.NOMINAL_HEIGHT - (border.height / 2);

        fill.x = sprite.NOMINAL_WIDTH / 2;
        fill.y = sprite.NOMINAL_HEIGHT - (fill.height / 2);
    }
}