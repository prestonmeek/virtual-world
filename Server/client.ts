import logger from './logger';
import WebSocket from 'ws';

export default class Client {
    id: string;
    ws: WebSocket;

    constructor(id: string, ws: WebSocket) {
        this.id = id;
        this.ws = ws;
    }

    handleMessage(message: WebSocket.Data) {
        logger.write('Received message: ' + message);
    }

    handleError(err: Error) {
        if (err.message !== 'read ECONNRESET')
            logger.error(err);
    }

    handleClose(code: number) {
        logger.write(`Client ${this.id} disconnected with code ${code}`);
    }
}