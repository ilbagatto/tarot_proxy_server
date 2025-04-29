# Tarot Proxy Server

A lightweight Dart proxy server for Tarot MiniApp.

It securely handles API requests, hides credentials from clients, and adds CORS headers to allow browser access.

---

## Features

- Proxy API requests with Basic Authentication
- Clean CORS middleware for safe browser access
- Optimized for Telegram MiniApps (same domain policy)
- Simple and minimal server, ready for production

---

## Requirements

- Dart SDK >=3.0.0 <4.0.0
- A VPS with Ubuntu 20.04/22.04 (or any Linux)

---

## .env Configuration

Create a `.env` file in the root directory:

```dotenv
API_BASE=https://your-real-api.com
API_USERNAME=your_api_username
API_PASSWORD=your_api_password
PORT=3000
```

> **Important:**  
> Do not commit `.env` to Git repositories.  
> Add it to `.gitignore`.

---

## Running Locally (Development Mode)

```bash
dart pub get
dart run bin/main.dart
```

Server will start on:

```
http://localhost:3000
```

---

## Building Production Binary

To create a native executable (Linux):

```bash
dart compile exe bin/main.dart -o tarot_proxy_server
```

Result:  
`tarot_proxy_server` executable in the project root.

✅ Then copy the binary to your VPS.

---

## Recommended Deployment (Linux server)

1. Upload the binary and `.env` to your VPS.
2. Setup a systemd service (optional, for auto-start).
3. Proxy requests through Apache/Nginx to the server.

Example Apache config snippet:

```apache
ProxyPass "/proxy/" "http://localhost:3000/"
ProxyPassReverse "/proxy/" "http://localhost:3000/"
```

---

## Architecture Overview

```
[Browser / Telegram MiniApp]
         ↓ (HTTPS request)
[Apache2 reverse proxy at https://yourdomain.com/proxy/]
         ↓ (HTTP)
[Dart Proxy Server (shelf)]
         ↓ (HTTPS request with Basic Auth)
[Real External API Server]
```

---

## Logging

- In development: colorized pretty logs
- In production: plain text logs
- All requests, errors and timings are logged

---

## Future Plans

- Switch from Basic Auth to Bearer Token authentication
- Caching of frequent API requests (optional)
- Rate limiting for better protection
- Unit and integration tests for core modules

---

