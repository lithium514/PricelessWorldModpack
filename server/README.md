# Priceless World Modpack - Server

This directory contains server packaging for the Priceless World Modpack with MCDReforged support.

## Quick Start

### Option 1: NeoForge Server with MCDReforged (Recommended)

```bash
# Run the setup script
./setup.sh

# Start the server with MCDReforged
cd server-files
./start-mcdr.sh  # Linux/Mac
start-mcdr.bat   # Windows
```

### Option 2: NeoForge Server (Direct)

```bash
# Run the setup script
./setup.sh

# Start the server directly
cd server-files
./start.sh  # Linux/Mac
start.bat   # Windows
```

### Option 3: Docker

```bash
# Build and start with Docker Compose
docker-compose up -d

# View logs
docker-compose logs -f

# Stop server
docker-compose down
```

### Option 4: Manual Setup

1. Download NeoForge 1.21.1 server from [NeoForge](https://neoforged.net/)
2. Run the installer: `java -jar neoforge-21.1.233-installer.jar --installServer`
3. Copy the `mods/` folder from this modpack to the server
4. Copy `defaultconfigs/` to the server's `config/` folder
5. Create `eula.txt` with `eula=true`
6. Start the server

## Requirements

- Java 21 or higher
- Python 3.8 or higher (for MCDReforged)
- 4GB+ RAM recommended
- Docker (for Docker deployment)

## MCDReforged

MCDReforged is a Python-based Minecraft server control tool that provides:
- Plugin system for server management
- Event-driven automation
- Hot-reloadable plugins
- Multi-platform compatibility

### MCDR Plugins

Place MCDR plugins in the `mcdr/plugins/` directory.

### MCDR Configuration

Edit `mcdr/config.yml` to customize MCDR settings.

### MCDR Commands

- `!!help` - Show MCDR help
- `!!status` - Show server status
- `!!reload` - Reload MCDR plugins

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
- Linux/Mac: Edit `start.sh` or `start-mcdr.sh`
- Windows: Edit `start.bat` or `start-mcdr.bat`
- Docker: Edit `docker-compose.yml`

Default: 4GB min, 8GB max

## Performance Tips

1. **Use Lithium**: Already included for server optimization
2. **Reduce view-distance**: Set to 8-10 for better performance
3. **Reduce simulation-distance**: Set to 6-8 for better performance
4. **Allocate more RAM**: Increase `-Xmx` value in startup script
5. **Use MCDR Plugins**: Install performance monitoring plugins

## Troubleshooting

### Out of Memory
Increase the `-Xmx` value in the startup script.

### Performance Issues
- Reduce `view-distance` in server.properties
- Reduce `simulation-distance` in server.properties
- Close unnecessary programs

### Mods Not Loading
Ensure all mod files are in the `mods/` directory.

### MCDReforged Issues
- Ensure Python 3.8+ is installed
- Check `mcdr/config.yml` configuration
- View MCDR logs in `mcdr/logs/`

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
    ├── mcdr/         # MCDReforged directory
    │   ├── plugins/  # MCDR plugins
    │   ├── config/   # MCDR config
    │   ├── logs/     # MCDR logs
    │   ├── config.yml
    │   └── permission.yml
    ├── server.properties
    ├── eula.txt
    ├── start.sh      # Linux/Mac startup
    ├── start.bat     # Windows startup
    ├── start-mcdr.sh # Linux/Mac MCDR startup
    └── start-mcdr.bat # Windows MCDR startup
```

## GitHub Actions

The GitHub Actions workflow automatically builds:
1. **Modrinth Pack** (.mrpack) - For Modrinth launcher
2. **Server Package** (.tar.gz) - Pre-configured NeoForge server with MCDReforged
3. **Docker Image** (.tar.gz) - Containerized server with MCDReforged

Download artifacts from the Actions tab.
