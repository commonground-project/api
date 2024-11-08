mkdir -p public
cp -R node_modules/swagger-ui-dist/* public/
cp openapi.yaml public/swagger.yaml
echo "window.onload = function() { window.ui = SwaggerUIBundle({ url: './swagger.yaml', dom_id: '#swagger-ui' }); };" > public/swagger-initializer.js
sed -i 's|<title>Swagger UI</title>|<title>API Documentation</title>|' public/index.html

http-server public -p 8080 &
SERVER_PID=$!

cleanup() {
  echo "Stopping server and cleanup files..."
  kill $SERVER_PID
  rm -rf public/*
  exit 0
}

trap cleanup SIGINT SIGTERM

wait $SERVER_PID