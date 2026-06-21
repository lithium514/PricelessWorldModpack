# PricelessWorldModpack
The modpack of PricelessWorldServer

## Server Setup

This modpack includes server packaging options with MCDReforged support. See [server/README.md](server/README.md) for details.

### Quick Start

**Option 1: NeoForge Server with MCDReforged (Recommended)**
```bash
cd server
./setup.sh
cd server-files
./start-mcdr.sh
```

**Option 2: NeoForge Server (Direct)**
```bash
cd server
./setup.sh
cd server-files
./start.sh
```

**Option 3: Docker**
```bash
docker-compose up -d
```

### Requirements
- Java 21 or higher
- Python 3.8 or higher (for MCDReforged)
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
2. Server Package (.tar.gz) with MCDReforged
3. Docker Image (.tar.gz) with MCDReforged

## License

See LICENSE file for details.
