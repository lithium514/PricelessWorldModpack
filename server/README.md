# Priceless World Modpack - Server

This directory contains server packaging for the Priceless World Modpack.

## Quick Start

### Option 1: NeoForge Server (Recommended)

```bash
# Run the setup script
./setup.sh

# Start the server
cd server-files
./start.sh  # Linux/Mac
start.bat   # Windows
```

### Option 2: Docker

```bash
# Build and start with Docker Compose
docker-compose up -d

# View logs
docker-compose logs -f

# Stop server
docker-compose down
```

### Option 3: Manual Setup

1. Download NeoForge 1.21.1 server from [NeoForge](https://neoforged.net/)
2. Run the installer: `java -jar neoforge-21.1.227-installer.jar --installServer`
3. Copy the `mods/` folder from this modpack to the server
4. Copy `defaultconfigs/` to the server's `config/` folder
5. Create `eula.txt` with `eula=true`
6. Start the server

## Requirements

- Java 21 or higher
- 4GB+ RAM recommended
- Docker (for Docker deployment)

## Configuration

### Server Properties

Edit `server.properties` to customize:
- `difficulty`: easy, normal, hard
- `gamemode`: survival, creative, adventure
- `max-players`: Default 20
- `view-distance`: Lower for better performance
- `simulation-distance`: Lower for better performance

### JVM Memory

Edit the startup script to adjust memory:
- Linux/Mac: Edit `start.sh`
- Windows: Edit `start.bat`
- Docker: Edit `docker-compose.yml`

Default: 4GB min, 8GB max

## Performance Tips

1. **Use Lithium**: Already included for server optimization
2. **Reduce view-distance**: Set to 8-10 for better performance
3. **Reduce simulation-distance**: Set to 6-8 for better performance
4. **Allocate more RAM**: Increase `-Xmx` value in startup script

## Troubleshooting

### Out of Memory
Increase the `-Xmx` value in the startup script.

### Performance Issues
- Reduce `view-distance` in server.properties
- Reduce `simulation-distance` in server.properties
- Close unnecessary programs

### Mods Not Loading
Ensure all mod files are in the `mods/` directory.

### Docker Issues
- Check logs: `docker-compose logs`
- Restart: `docker-compose restart`
- Rebuild: `docker-compose up -d --build`

## File Structure

```
server/
├── setup.sh          # Server setup script
├── README.md         # This file
└── server-files/     # Created by setup.sh
    ├── mods/         # Mod files
    ├── config/       # Server configs
    ├── kubejs/       # KubeJS scripts
    ├── world/        # World data
    ├── server.properties
    ├── eula.txt
    ├── start.sh      # Linux/Mac startup
    └── start.bat     # Windows startup
```

## GitHub Actions

The GitHub Actions workflow automatically builds:
1. **Modrinth Pack** (.mrpack) - For Modrinth launcher
2. **Server Package** (.tar.gz) - Pre-configured NeoForge server
3. **Docker Image** (.tar.gz) - Containerized server

Download artifacts from the Actions tab.
