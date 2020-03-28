const appRoot = require('app-root-path');
const winston = require('winston');

const logger = winston.createLogger({
    level: 'info',
    format: winston.format.combine(
        winston.format.timestamp({format: 'YYYY-MM-DD HH:mm:ss'}),
        winston.format.errors({ stack: true }),
        winston.format.splat(),
        winston.format.json()
    ),
    defaultMeta: { service: 'hue-mqtt' },
    transports: [
      new winston.transports.File({ 
          filename: `${appRoot}/logs/error.log`, 
          level: 'error' ,       
          maxsize: 5242880, // 5MB
          maxFiles: 5}),
      new winston.transports.File({ 
          filename: `${appRoot}/logs/app.log`, 
          maxsize: 5242880, // 5MB
          maxFiles: 5})
    ]
  });

if (process.env.NODE_ENV !== 'production') {
    logger.add(new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
      )
    }));
}

module.exports = logger;