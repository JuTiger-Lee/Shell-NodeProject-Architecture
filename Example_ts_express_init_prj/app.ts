import express from "express";
import routers from "@/routers/index";
import env from "env-var";
import dotenv from "dotenv";

class App {
  public readonly server: express.Application;
  public readonly PORT: number;

  constructor() {
    this.PORT = env.get("PORT").default(8080).asPortNumber();
    this.server = express();
  }

  bootstrap() {
    this.checkEnv();
    this.initExpress();
    this.setRouter();
  }

  private checkEnv() {
    dotenv.config();
  }

  private initExpress() {
    this.server.use(express.urlencoded({ extended: true }));
    this.server.use(express.json());
  }

  private setRouter() {
    routers(this.server);
  }
}

const app = new App();
app.bootstrap();

export default app;
