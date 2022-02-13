export const configVar = () => ({
  PORT: process.env.PORT || 5000,
  NODE_ENV: process.env.NODE_ENV,
  NODE_NAME: process.env.NODE_NAME,
  MONGO_URL: process.env.MONGO_URL,
});
