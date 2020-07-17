export default class Logger {
    static write(data: string) {
        console.log(`[INFO] > ${data}`);
    }

    static warn(data: string) {
        console.log(`[WARN] > ${data}`);
    }

    static error(err: Error) {
        console.log(`[ERROR] > ${err}`);
    }
}