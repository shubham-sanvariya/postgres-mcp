PGHOST=host.docker.internal
PGUSER=
PGPASSWORD=
PGDATABASE=
PGPORT=

DATABASE_URI=postgresql://postgres:mypassword@host.docker.internal:5432/mydb

curl -N http://localhost:3000/sse


will get the session id from above command
curl -X POST "http://localhost:3000/messages/?session_id=85c1dd034d7940b992eb88bf582a7b01" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "notifications/initialized",
    "params": {}
  }'


docker build --no-cache -t postgres-mcp-http .

docker run -p 3000:3000 \
  --env-file .env \
  postgres-mcp-http


curl -X POST "http://localhost:3000/messages/?session_id=85c1dd034d7940b992eb88bf582a7b01" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":7,"method":"tools/call","params":{"name":"execute_sql","arguments":{"sql":"SELECT * FROM users;"}}}'
