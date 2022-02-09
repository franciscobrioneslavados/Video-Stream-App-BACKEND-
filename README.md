npm i -D @types/multer @types/bcrypt @types/uuid
npm i @nestjs/mongoose mongoose @nestjs/jwt passport-jwt bcrypt @nestjs/serve-static


docker run -d -p 27017:27017 --name docker-mongo -e MONGO_INITDB_ROOT_USERNAME=mongoadmin -e MONGO_INITDB_ROOT_PASSWORD=secret mongo

docker exec -it docker-mongo bash

mongosh

db.auth("mongoadmin", passwordPrompt())

use test
db.createUser(
  {
    user: "usermongo",
    pwd:  "secret",
    roles: [ { role: "readWrite", db: "test" },
             { role: "read", db: "reporting" } ]
  }
)

mongosh -u "usermongo" --authenticationDatabase "test" -p