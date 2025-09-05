#!/usr/bin/env bash
set -e

# 환경변수 읽기
APP_USER="${APP_USER:-ssafy}"
APP_PASSWORD="${APP_PASSWORD:-ssafy}"
APP_DB="${APP_DB:-b101}"

echo ">>> Creating role/database: ${APP_USER} / ${APP_DB}"

# 슈퍼유저(POSTGRES_USER=postgres)로 접속되어 실행됨
psql -v ON_ERROR_STOP=1 --username "postgres" <<-EOSQL
  DO \$\$
  BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${APP_USER}') THEN
      CREATE ROLE "${APP_USER}" LOGIN PASSWORD '${APP_PASSWORD}';
    END IF;
  END
  \$\$;
EOSQL

psql -v ON_ERROR_STOP=1 --username "postgres" <<-EOSQL
  SELECT 'CREATE DATABASE "${APP_DB}" OWNER "${APP_USER}"'
  WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${APP_DB}')
  \gexec
EOSQL

echo ">>> Granting schema privileges on ${APP_DB}"

# 애플리케이션 DB에서 기본 public 스키마 사용 권한 부여
psql -v ON_ERROR_STOP=1 --username "postgres" --dbname "${APP_DB}" <<-EOSQL
  GRANT ALL PRIVILEGES ON DATABASE "${APP_DB}" TO "${APP_USER}";
  GRANT USAGE, CREATE ON SCHEMA public TO "${APP_USER}";
  ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO "${APP_USER}";
  ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO "${APP_USER}";
EOSQL

echo ">>> App DB & role ready."