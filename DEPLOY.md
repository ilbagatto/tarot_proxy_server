# Deploy Instructions for Tarot Proxy Server

---

## Requirements

- VPS with Ubuntu 20.04/22.04
- Dart SDK 3.7.2 installed (only locally for build, not on server)
- Systemd available on server (standard on Ubuntu)
- SSH access to server


## GitHub Secrets

Add these secrets under GitHub repository **Settings -> Secrets and variables -> Actions**:

| Secret | Description |
|:-------|:------------|
| `SSH_HOST` | Public IP address or domain of the server |
| `SSH_USER` | SSH user on the server |
| `SSH_PRIVATE_KEY` | Private SSH key (without passphrase preferred) |


## GitHub Variables

Add these variables under GitHub repository **Settings -> Variables -> Actions**:

| Variable | Description |
|:---------|:------------|
| `SERVER_PATH` | Directory on server where the proxy will live (e.g., `/opt/tarot_proxy_server`) |
| `RESTART_SERVICE` | Set to `true` if you want to restart the service after deployment |


## Folder Structure on Server

After deployment, the server will have:

```
/opt/tarot_proxy_server/
  |- tarot_proxy_server          # Compiled Dart binary
  |- tarot-proxy.service         # systemd service file (optional for initial setup)
  |- .env.example                # Example environment configuration
  |- .env                        # Real environment file (created from .env.example if missing)
```


## How CI/CD Works

1. **On push to `main`** or **push of a `v*` tag**:
   - Run unit tests.
   - Build binary with Dart compiler.
   - Upload binary and config files to the server.
   - Copy `.env.example` as `.env` if `.env` does not exist.
   - Optionally restart `tarot-proxy.service`.


## Manual First-time Setup on Server

1. Deploy first time (GitHub Actions will upload files).
2. SSH into the server:

```bash
ssh youruser@yourserver
```

3. Move the `tarot-proxy.service` to `/etc/systemd/system/`:

```bash
sudo cp /opt/tarot_proxy_server/tarot-proxy.service /etc/systemd/system/tarot-proxy.service
```

4. Reload systemd:

```bash
sudo systemctl daemon-reload
```

5. Enable and start service:

```bash
sudo systemctl enable tarot-proxy.service
sudo systemctl start tarot-proxy.service
```

6. Check status:

```bash
sudo systemctl status tarot-proxy.service
```


## Notes

- **Important:** Once `.env` is created, it will not be overwritten automatically on next deployments.
- Ensure correct file permissions on `/opt/tarot_proxy_server`.
- Make sure `sudo systemctl restart tarot-proxy.service` does not require a password (edit sudoers if needed).

---

Good luck and happy deployments! 🚀

