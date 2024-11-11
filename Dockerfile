FROM python:3.8-slim

RUN apt-get update && apt-get install -y \
    curl \
    sed \
    python3-watchdog \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app/public

RUN curl -L https://github.com/swagger-api/swagger-ui/archive/v4.15.5.tar.gz | tar -xz --strip-components=2 swagger-ui-4.15.5/dist

RUN echo "window.onload = function() { window.ui = SwaggerUIBundle({ url: './swagger.yaml', dom_id: '#swagger-ui' }); };" > /app/public/swagger-initializer.js
RUN sed -i 's|<title>Swagger UI</title>|<title>API Documentation</title>|' /app/public/index.html

EXPOSE 8080
CMD watchmedo auto-restart --patterns="*.yaml;*.html;*.js;*.css" --recursive -- python3 -m http.server 8080 --directory /app/public
