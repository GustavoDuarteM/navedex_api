JWTSessions.encryption_key = "secret"
JWTSessions.token_store = :redis, {
  redis_host: "redis",
  redis_port: "6379",
  redis_db_name: "0",
  token_prefix: "jwt_"
}