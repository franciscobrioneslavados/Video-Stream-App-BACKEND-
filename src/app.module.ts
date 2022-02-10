import { MiddlewareConsumer, Module, RequestMethod } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { MongooseModule } from '@nestjs/mongoose';
import { MulterModule } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { ServeStaticModule } from '@nestjs/serve-static';
import { join } from 'path';
import { UserModule } from './user/user.module';
import { VideoModule } from './video/video.module';
import { v4 as uuidv4 } from 'uuid';
import { isAuthenticated } from './app.middleware';
import { VideoController } from './video/video.controller';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { SharedModule } from './shared/shared.module';
import { LoggerMiddleware } from './shared/logger/logger.middleware';
import { Configuration } from './shared/env.enum';

export const secret = 'secret';
const configService = new ConfigService();

@Module({
  imports: [
    ConfigModule.forRoot(),
    MongooseModule.forRoot(configService.get(Configuration.MONGO_URL), {
      useNewUrlParser: true,
    }),
    MulterModule.register({
      storage: diskStorage({
        destination: './public',
        filename: (req, file, cb) => {
          const ext = file.mimetype.split('/')[1];
          cb(null, `${uuidv4()}-${Date.now()}.${ext}`);
        },
      }),
    }),
    JwtModule.register({
      secret,
      signOptions: { expiresIn: '2h' },
    }),
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', 'public'),
    }),
    UserModule,
    VideoModule,
    SharedModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(isAuthenticated)
      .exclude({ path: 'video/:id', method: RequestMethod.GET })
      .forRoutes(VideoController);
    consumer.apply(LoggerMiddleware).forRoutes('*');
  }
}
