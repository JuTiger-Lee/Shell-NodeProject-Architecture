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

# Swagger Choice

echo "Are you using Swagger? Y/N"
read choiceSwagger

if [[ $choiceSwagger == "Y" || $choiceSwagger == "y" ]]
then 
    echo "swagger init..."
    
    npm install swagger-jsdoc
    npm install @types/swagger-jsdoc

    npm install swagger-ui-express
    npm install @types/swagger-ui-express

    echo "Success install Swagger"
else
    echo "You Choice $choiceSwagger Thanks..."
fi

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

echo "init module install Success!"

npx tsc --init

touch tsconfig.build.json .env

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
touch app.ts index.ts
mkdir controllers/ 
mkdir handler/

if [[ $choiceSwagger == "Y" || $choiceSwagger == "y" ]]
then
    cd handler/
    touch SwaggerHandler.ts

    echo 'import { OAS3Options, Paths, PathItem } from "swagger-jsdoc";

const swaggerOpenApiVersion = "3.0.0";

const swaggerInfo = {
  title: "",
  version: "0.0.1",
  description: "" 
};

const swaggerTags = [
  {
    name: "User",
    description: "사용자 관련 API",
  },
];

const swaggerSchemes = ["http", "https"];

const swaggerSecurityDefinitions = {
  ApiKeyAuth: {
    type: "apiKey",
    name: "Authorization",
    in: "header",
  },
};

const swaggerProduces = ["application/json"];

const swaggerServers = [
  {
    url: "http://localhost:8080",
    description: "로컬 서버",
  },
];

const swaggerSecurityScheme = {
  bearerAuth: {
    type: "http",
    scheme: "bearer",
    bearerFormat: "Token",
    name: "Authorization",
    description: "인증 토큰 값을 넣어주세요.",
    in: "header",
  },
};

const swaggerComponents = {
  // JWT_ERROR: {
  //   description: "jwt token Error",
  //   type: "object",
  //   properties: {
  //     401: {
  //       type: "Error token 변조 에러",
  //     },
  //   },
  // },
  SERVER_ERROR: {
    description: "SERVER ERROR",
    type: "object",
    properties: {
      500: {
        type: "Internal Error",
        code: 800,
      },
    },
  },
};

/**
 * The Swagger Hanlder is having issues with concurrency
 * This is a problem with a Singleton Pattern
 */
export default class SwaggerHandler {
  private static swaggerInstance: SwaggerHandler;
  private option: OAS3Options = {
    definition: {
      openapi: swaggerOpenApiVersion,
      info: swaggerInfo,
      servers: swaggerServers,
      schemes: swaggerSchemes,
      securityDefinitions: swaggerSecurityDefinitions,

      /* open api 3.0.0 version option */
      produces: swaggerProduces,
      components: {
        securitySchemes: swaggerSecurityScheme,
        schemas: swaggerComponents,
      },
      tags: swaggerTags,
    },
    apis: [],
  };

  private setUpOption: {
    // search
    explorer: true;
  };

  private apiPaths = [];

  private constructor() {}

  static getSwaggerInstance() {
    if (!SwaggerHandler.swaggerInstance)
      SwaggerHandler.swaggerInstance = new SwaggerHandler();

    return SwaggerHandler.swaggerInstance;
  }

  private processAPI() {
    const path: Paths = {};

    for (let i = 0; i < this.apiPaths.length; i += 1) {
      for (const [key, value] of Object.entries(this.apiPaths[i])) {
        path[key] = value;
      }
    }

    return path;
  }

  addAPI(api: PathItem) {
    this.apiPaths.push(api);
  }

  /** TODO: add compoentns method  */
  addCompoents() {}

  getOption() {
    const path = this.processAPI();
    this.option.definition.paths = path;

    return {
      apiOption: this.option,
      setUpOption: this.setUpOption,
    };
  }
}' >> SwaggerHandler.ts
    cd ../

    cd controllers/
    touch ApiDocs.ts

    echo 'import swaggerUI from "swagger-ui-express";
import swaggerJsDoc from "swagger-jsdoc";
import SwaggerHandler from "@/handler/SwaggerHandler";
import userAPI from "@/controllers/apiDocs/user/index";

class ApiDocs {
  private apiDocOption: object;
  private swagger: SwaggerHandler;

  constructor() {
    this.apiDocOption = {
      ...userAPI,
    };

    this.swagger = SwaggerHandler.getSwaggerInstance();
  }

  init() {
    this.swagger.addAPI(this.apiDocOption);
  }

  getSwaggerOption() {
    const { apiOption, setUpOption } = this.swagger.getOption();

    const specs = swaggerJsDoc(apiOption);

    return {
      swaggerUI,
      specs,
      setUpOption,
    };
  }
}

export default ApiDocs;' >> ApiDocs.ts

    cd ../

    echo "Swagger Setting Success"
fi

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

echo "Project Folder Setting Success!"

# specific file wrtie

cd $prjFolderRoute

perl -p -i -e '$.==7 and print "\"build\": \"tsc --p tsconfig.build.json\",
\"dev:start\": \"npm run build && node dist/index.js\",
\"dev\": \"nodemon --watch src -e ts --exec npm run dev:start\",
\"start\": \"npm run build && node dist/index.js\",\n"' package.json

perl -p -i -e '$.==13 and print "\"moduleAliases\": { \n
    \"@\": \"./dist\"
}, \n"' package.json

perl -p -i -e '$.==3 and print "\"baseUrl\": \"./\",
\"paths\": {
    \"@/*\": [\"./src/*\"],
},"' tsconfig.json

if [[ $choiceGithub == "Y" || $choiceGithub == "y" ]]
then
    git add .
    git commit -m 'init'
    git pull origin master
    git push -u origin +master

    echo "Github Push origin Success" 
fi

echo "Project Success!" 
