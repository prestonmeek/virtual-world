package;

import js.html.CharacterData;
import openfl.geom.Point;

import haxe.Json;

import hx.ws.WebSocket;

import js.lib.Promise;

typedef Packet = {
    var action: String;
    @:optional var id: String;
    @:optional var info: PlayerInfo;
    @:optional var players: Array<PlayerInfo>;
    @:optional var coords: Point;
}

typedef PlayerInfo = {
    var id: String;
    var x: Float;
    var y: Float;
}

class Client {
    public var sprite: Main;

    private var players: Array<Player> = new Array();

    public var ws: WebSocket;
    private var address: String = 'localhost';
    private var port: Int = 8080;

    public function new(sprite: Main) {
        this.sprite = sprite;
        
        ws = new WebSocket('ws://${address}:${port}');

        ws.onopen = handleOpen;
        ws.onmessage = handleMessage;
    }

    private function handleOpen(): Void {
        trace('Connection established');
    }

    public function send(data: Packet): Void {
        ws.send(Json.stringify(data));
    }

    private function handleMessage(msg: Dynamic): Void {
        var data: Packet = Json.parse(msg.data);

        trace(data.action);

        if (data.action == 'setup') {
            sprite.setupExtras();

            var player = new Player(this, 'Preston');

            player.setup(500, 200, data.id);
            player.addMouseEventListener();
            players.push(player);
            
            for (p in data.players) {
                // getPlayerByID is used here to simply see if the player exists in the players array already or not
                getPlayerByID(p.id).then((player: Player) -> {
                    // player == null checks if the player doesn't already exist in the array
                    if (p.id != data.id && player == null) {
                        var newPlayer = new Player(this, 'Preston');
    
                        newPlayer.setup(p.x, p.y, p.id);
                        players.push(newPlayer);
                    }
                });
            }
        } else {
            switch (data.action) {
                case 'move':
                    handleMove(data.id, data.coords);

                case 'add new player':
                    handleAddNewPlayer(data.info);

                case 'remove player':
                    handleRemovePlayer(data.id);
            }
        }
    }

    private function handleMove(id: String, coords: Point): Void {
        getPlayerByID(id).then((player: Player) -> {
            player.move(coords);
        });
    }

    private function handleAddNewPlayer(info: PlayerInfo): Void {
        var newPlayer = new Player(this, 'Preston');

        newPlayer.setup(info.x, info.y, info.id);
        players.push(newPlayer);
    }

    private function handleRemovePlayer(id: String): Void {
        getPlayerByID(id).then((player: Player) -> {
            sprite.removeChild(player);
            players.remove(player);
        });
    }

    private function getPlayerByID(id: String): Promise<Player> {
        return new Promise((resolve, reject) -> {
            var res: Player = null;

            for (p in players) {
                if (p.id == id)
                    res = p;
            }

            resolve(res);
        });
    }
}