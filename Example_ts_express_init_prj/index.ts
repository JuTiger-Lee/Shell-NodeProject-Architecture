import "module-alias/register";
import "reflect-metadata";
import app from "@/app";
import env from "env-var";
import dotenv from "dotenv";

const { server, PORT } = app;

const init = () =>
  server.listen(PORT, () => console.log(`::${PORT} Server Start!`));

init();
