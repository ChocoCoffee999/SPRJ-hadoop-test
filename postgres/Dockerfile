# Dockerfile
FROM postgres:16

# 기본 관리자 계정 (원하면 실행 시 -e 로 덮어쓰기 가능)
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=admin_password
ENV POSTGRES_DB=postgres

# 최초 초기화 때 실행될 스크립트 복사
# *.sql / *.sh 는 /var/lib/postgresql/data 가 비어 있을 때 한 번만 실행됨
COPY init/ /docker-entrypoint-initdb.d/