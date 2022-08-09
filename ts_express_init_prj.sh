echo "Please write You are project folder routes"
echo "Example: C://User//~"
read prjFolderRoute

if [[ $prjFolderRoute == "" ]]
then 
    echo "Please wirte project folder routes"
    exit 1
fi

if [[ ! -d $prjFolderRoute ]] ; then
 echo "$prjFolderRoute folder does not exist."
 exit 1
fi

echo "The project path you submitted: $prjFolderRoute"

cd $prjFolderRoute

# git repo choice

echo "Are you using github? Y/N"
read choiceGithub

if [[ $choiceGithub == "Y" || $choiceGithub == "y" ]]
then 
    echo "git init..."
    touch .gitignore
    echo '/node_modules' >> .gitignore
    echo '/dist' >> .gitignore
    echo '.env' >> .gitignore
    git init
    echo "git init success!"

    echo "Please write git Repo URL"
    read gitRepo
    git remote add origin $gitRepo

    echo "Success Setting $gitRepo"
else
    echo "You Choice $choiceGithub Thanks..."
fi

# TODO Swagger choice


# module install

npm init
npm install dotenv
npm install env-var
npm install module-alias
npm install reflect-metadata
npm install --save-dev typescript
npm install --save-dev ts-node
npm install --save-dev @types/node
npm install --save-dev @types/module-alias
npm install --save-dev nodemon

npm install express
npm install --save-dev @types/express
npx tsc --init

touch tsconfig.build.json app.ts index.ts .env

# file write

echo 'NODE_ENV="dev"
PORT=8080' >> .env

echo '{
    "extends": "./tsconfig.json",
    // dist를 넣어줌으로써 여러번 build 시 에러 해결
    "exclude": ["node_modules", "dist"]
  }' >> tsconfig.build.json

echo 'import "module-alias/register";
import "reflect-metadata";
import app from "@/app";
import env from "env-var";
import dotenv from "dotenv";

const { server, PORT } = app;

const init = () =>
  server.listen(PORT, () => console.log(`::${PORT} Server Start!`));

init();' >> index.ts

echo 'import express from "express";
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

export default app;' >> app.ts

# project folder make

mkdir src/
cd src/
mkdir controllers/ 
mkdir handlr/
mkdir repos/

mkdir routers/
cd routers/
touch index.ts
echo 'import express from "express";

export default (app: express.Application) => {
  app.get("/", (req, res) => res.send("Hello World"));
};' >> index.ts
cd ../

mkdir services/
mkdir utils/

# specific file wrtie

cd $prjFolderRoute

perl -p -i -e '$.==7 and print "\"build\": \"tsc --p tsconfig.build.json\",
\"dev:start\": \"npm run build && node dist/index.js\",
\"dev\": \"nodemon --watch src -e ts --exec npm run dev:start\",
\"start\": \"npm run build && node dist/index.js\",\n"' package.json

perl -p -i -e '$.==3 and print "\"baseUrl\": \"./\",
\"paths\": {
    \"@/*\": [\"./src/*\"],
},"' tsconfig.json

git add .
git commit -m 'init'
git pull origin master
git push -u origin +master 
