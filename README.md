# Simple FTP server
Simple FTP server for the homelab using containers.

Before building with `docker-compose`, create a `.env` file and add the following information:
```sh
SYSUSER=<username>
SYSUSERPASS=<password>
FTP_DIR=/path/to/ftp/dir
```

## Create an autostart service
1. **Create a Systemd Service File**: Systemd is used to manage services in most modern Linux distributions. You'll create a service file to manage the Docker Compose stack.
   1. Open a terminal and create a new service file:
   ```bash
   sudo nano /etc/systemd/system/docker-compose-app.service
   ```
   2. Add the following content to the file, customizing paths as needed:
   ```ini
   [Unit]
   Description=Docker Compose Application Service
   Requires=docker.service
   After=docker.service

   [Service]
   Type=oneshot
   RemainAfterExit=true
   WorkingDirectory=/path/to/your/docker-compose
   EnvironmentFile=/path/to/env/file
   ExecStart=/usr/bin/docker-compose up -d
   ExecStop=/usr/bin/docker-compose down

   [Install]
   WantedBy=multi-user.target
   ```

   - Replace `/path/to/your/docker-compose` with the directory containing [docker-compose.yml](./docker-compose.yml).
   - Replace `/path/to/env/file` with the full path to the `.env` file.
   - Ensure the paths to `docker-compose` are correct (e.g., `/usr/local/bin/docker compose` on some setups).
2. **Reload Systemd and Enable the Service**: 
   1. Reload the systemd daemon to recognize the new service:
   ```bash
   sudo systemctl daemon-reload
   ```
   2. Enable the service to start at boot:
   ```bash
   sudo systemctl enable docker-compose-app.service
   ```
3. **Start the Service**: Start the service manually to verify it works:
   ```bash
   sudo systemctl start docker-compose-app.service
   ```

   Check its status:
   ```bash
   sudo systemctl status docker-compose-app.service
   ```
4. **Verify at Startup**: Reboot your machine to test if the service starts automatically:
   ```bash
   sudo reboot
   ```
   After reboot, check if your containers are running:
   ```bash
   docker ps
   ```
**Additional Notes**
---
1. **Logs**: To troubleshoot, check the service logs:
   ```bash
   journalctl -u docker-compose-app.service
   ```
