import Socket from './socket';
import logger from './logger';
import shortid from 'shortid';
import WebSocket from 'ws';

export interface Packet {
    action: string,
    id?: string,
    info?: SocketInfo,
    players?: Array<SocketInfo>,
    coords?: Point
}

export class Point {
    x: number;
    y: number;

    constructor(x: number, y: number) {
        this.x = x;
        this.y = y;
    }
}

interface SocketInfo {
    id: string;
    x: number;
    y: number;
}

class Server {
    address: string;
    port: number;
    sockets: Array<Socket>;
    wss: WebSocket.Server;

    constructor() {
        this.address = 'localhost';
        this.port = 8080;

        this.sockets = [];

        this.wss = new WebSocket.Server({ port: this.port });

        this.init();
    }

    init(): void {
        this.wss.on('connection', (ws: WebSocket) => {
            const socket: Socket = new Socket(
                shortid.generate(), 
                ws
            );

            this.sockets.push(socket);

            logger.write(`New client connected with ID ${socket.id}`);

            socket.send({
                action: 'setup',
                id: socket.id,
                players: this.filterSockets()
            });

            this.broadcast({
                action: 'add new player',
                info: {
                    id: socket.id,
                    x: socket.x,
                    y: socket.y
                },
            }, socket.id);
        });
    }

    // exception is a socket ID that indicates a socket that will not receive the broadcast
    broadcast(data: Packet, exception?: string): void {
        for (let i in this.sockets) {
            if (this.sockets[i].id != exception) 
                this.sockets[i].send(data);
        }
    }

    remove(socket: Socket): void {
        const index: number = this.sockets.findIndex(element => element.id == socket.id);
        const id: string = this.sockets[index].id;
        
        this.sockets.splice(index, 1);

        this.broadcast({
            action: 'remove player',
            id: id
        }, id);
    }

    // removes ws property from Socket, leaving just the important info (id, x, y, etc.)
    filterSockets(): Array<SocketInfo> {
        const res = (function(sockets: Array<Socket>) {
            const arr = new Array<SocketInfo>();

            for (let i in sockets) {
                arr[i] = {
                    id: sockets[i].id,
                    x: sockets[i].x,
                    y: sockets[i].y
                }
            }

            return arr;
        })(this.sockets);

        return res;
    }
}

export const server = new Server();