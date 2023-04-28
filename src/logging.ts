// SPDX-License-Identifier: UNLICENSED

import * as dotenv from "dotenv";
import { pino, Logger } from "pino";

dotenv.config();

// config is depending on logger
const LOG_LEVEL = process.env.LOG_LEVEL || "info";

export const logger = pino({
  level: LOG_LEVEL,
  console: true,
});

export class LoggerFactory {
  static getLogger(name: string): Logger {
    return logger.child({ module: name });
  }
}
