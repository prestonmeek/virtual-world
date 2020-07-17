import Client from './client';
import logger from './logger';
import shortid from 'shortid';
import WebSocket from 'ws';

class Server {
    address: string;
    clients: Array<Client>;
    port: number;
    wss: WebSocket.Server;

    constructor() {
        this.address = '127.0.0.1';
        this.clients = [];
        this.port = 8080;
        this.wss = new WebSocket.Server({ port: this.port });

        this.init();
    }

    init() {
        this.wss.on('connection', (ws: WebSocket) => {
            const client: Client = new Client(
                shortid.generate(), 
                ws
            );

            this.clients.push(client);

            logger.write(`New client connected with ID ${client.id}`);

            ws.on('close', (code: number) => client.handleClose(code));
            ws.on('error', (err: Error) => client.handleError(err));
            ws.on('message', (message: WebSocket.Data) => client.handleMessage(message));
        });
    }
}

new Server;