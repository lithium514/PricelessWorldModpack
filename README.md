# PricelessWorldModpack
The modpack of PricelessWorldServer

## Server Setup

This modpack includes server packaging options. See [server/README.md](server/README.md) for details.

### Quick Start

**Option 1: NeoForge Server**
```bash
cd server
./setup.sh
cd server-files
./start.sh
```

**Option 2: Docker**
```bash
docker-compose up -d
```

### Requirements
- Java 21 or higher
- 4GB+ RAM recommended

## Development

### Building
```bash
# Install packwiz
curl -o packwiz https://github.com/lithium514/packwiz/releases/download/tag/packwiz
chmod +x packwiz

# Refresh mods
./packwiz refresh
```

### GitHub Actions
The workflow automatically builds:
1. Modrinth Pack (.mrpack)
2. Server Package (.tar.gz)
3. Docker Image (.tar.gz)

## License

See LICENSE file for details.
