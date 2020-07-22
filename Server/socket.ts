import { Packet, Point, server } from './server';
import logger from './logger';
import WebSocket from 'ws';

export default class Socket {
    id: string;
    ws: WebSocket;

    x: number;
    y: number;

    constructor(id: string, ws: WebSocket) {
        this.id = id;
        this.ws = ws;

        this.x = 500;
        this.y = 200;

        this.ws.on('close', (code: number) => this.handleClose(code));
        this.ws.on('error', (err: Error) => this.handleError(err));
        this.ws.on('message', (msg: string) => this.handleMessage(msg));
    }

    send(data: Packet): void {
        this.ws.send(JSON.stringify(data));
    }

    handleMessage(msg: string): void {
        const data: Packet = JSON.parse(msg);

        logger.write('Received action: ' + data.action);

        switch (data.action) {
            case 'move':
                this.handleMove(data.id!, data.coords!);
                break;

            default:
                logger.warn('Unhandled action: ' + data.action);
        }
    }

    handleMove(id: string, coords: Point): void {
        this.x = coords.x;
        this.y = coords.y;
        
        server.broadcast({
            action: 'move',
            id: id,
            coords: coords
        });
    }

    handleError(err: Error): void {
        if (err.message !== 'read ECONNRESET')
            logger.error(err);
    }

    handleClose(code: number): void {
        server.remove(this);

        logger.write(`Client ${this.id} disconnected with code ${code}`);
    }
}
