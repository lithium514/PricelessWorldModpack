#!/bin/bash
set -e

# Priceless World Modpack - Server Setup Script
# This script sets up a NeoForge server for the modpack

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Default values
MC_VERSION="1.21.1"
NEOFORGE_VERSION="21.1.233"
SERVER_DIR="${SCRIPT_DIR}/server-files"
MEMORY_MIN="4G"
MEMORY_MAX="8G"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --memory-min)
            MEMORY_MIN="$2"
            shift 2
            ;;
        --memory-max)
            MEMORY_MAX="$2"
            shift 2
            ;;
        --server-dir)
            SERVER_DIR="$2"
            shift 2
            ;;
        --neoforge-version)
            NEOFORGE_VERSION="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "=========================================="
echo "  Priceless World Modpack - Server Setup"
echo "=========================================="
echo ""

# Check for Java 21
print_status "Checking for Java 21..."
if ! command -v java &> /dev/null; then
    print_error "Java not found. Please install Java 21."
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 21 ]; then
    print_error "Java 21 or higher required. Found: Java $JAVA_VERSION"
    exit 1
fi
print_status "Java $JAVA_VERSION found"

# Create server directory
print_status "Creating server directory..."
mkdir -p "$SERVER_DIR"

# Download NeoForge installer
print_status "Downloading NeoForge $NEOFORGE_VERSION installer..."
NEOFORGE_URL="https://maven.neoforged.net/releases/net/neoforged/neoforge/${NEOFORGE_VERSION}/neoforge-${NEOFORGE_VERSION}-installer.jar"
INSTALLER_JAR="$SERVER_DIR/neoforge-installer.jar"

if [ ! -f "$INSTALLER_JAR" ]; then
    curl -L -o "$INSTALLER_JAR" "$NEOFORGE_URL"
    if [ $? -ne 0 ]; then
        print_error "Failed to download NeoForge installer"
        exit 1
    fi
fi
print_status "NeoForge installer downloaded"

# Run NeoForge installer
print_status "Installing NeoForge server..."
cd "$SERVER_DIR"
java -jar neoforge-installer.jar --installServer
if [ $? -ne 0 ]; then
    print_error "Failed to install NeoForge server"
    exit 1
fi
print_status "NeoForge server installed"

# Create mods directory and copy mods
print_status "Setting up mods..."
mkdir -p "$SERVER_DIR/mods"

# Copy .pw.toml files (packwiz mod definitions) - these will be resolved by packwiz
if [ -d "$ROOT_DIR/mods" ]; then
    cp -r "$ROOT_DIR/mods" "$SERVER_DIR/"
    print_status "Copied mod definitions"
fi

# Copy actual .jar files if they exist
if [ -f "$ROOT_DIR/mods/"*.jar ]; then
    cp "$ROOT_DIR/mods/"*.jar "$SERVER_DIR/mods/" 2>/dev/null || true
fi

# Create config directory and copy configs
print_status "Setting up configs..."
mkdir -p "$SERVER_DIR/config"
if [ -d "$ROOT_DIR/defaultconfigs" ]; then
    cp -r "$ROOT_DIR/defaultconfigs"/* "$SERVER_DIR/config/" 2>/dev/null || true
fi

# Create KubeJS directory and copy scripts
print_status "Setting up KubeJS..."
mkdir -p "$SERVER_DIR/kubejs"
if [ -d "$ROOT_DIR/kubejs" ]; then
    # Copy server scripts
    if [ -d "$ROOT_DIR/kubejs/server_scripts" ]; then
        cp -r "$ROOT_DIR/kubejs/server_scripts" "$SERVER_DIR/kubejs/"
    fi
    # Copy startup scripts
    if [ -d "$ROOT_DIR/kubejs/startup_scripts" ]; then
        cp -r "$ROOT_DIR/kubejs/startup_scripts" "$SERVER_DIR/kubejs/"
    fi
    # Copy config
    if [ -d "$ROOT_DIR/kubejs/config" ]; then
        cp -r "$ROOT_DIR/kubejs/config" "$SERVER_DIR/kubejs/"
    fi
fi

# Create server.properties
print_status "Creating server.properties..."
cat > "$SERVER_DIR/server.properties" << 'EOF'
#Minecraft server properties
#Priceless World Modpack Server
sync-tab-ahead=true
level-seed=
gamemode=survival
difficulty=normal
server-port=25565
level-name=world
enable-command-block=false
max-tick-time=60000
allow-nether=true
view-distance=10
spawn-protection=16
max-players=20
network-compression-threshold=256
require-resource-pack=false
spawn-monsters=true
spawn-npcs=true
allow-flight=false
generate-structures=true
spawn-animals=true
white-list=false
enforce-whitelist=false
hardcore=false
pvp=true
spawn-limit-ambient=15
online-mode=true
allow-rcon=false
sync-chunk-writes=true
entity-broadcast-range-percentage=100
level-type=minecraft\:normal
spawn-limit-water-animal=5
max-world-size=29999984
spawn-limit-axolotls=5
rate-limit=0
spawn-limit-golem=0
enforce-secure-profile=true
player-idle-timeout=0
prevent-proxy-connections=false
function-permission-level=2
initial-disabled-packs=
initial-enabled-packs=vanilla
max-chained-neighbor-updates=1000000
hide-online-players=false
status-port=25565
spawn-limit-monster=70
spawn-limit-fish=5
resource-pack=
resource-pack-prompt=
resource-pack-sha1=
resource-pack-id=
use-native-transport=true
EOF

# Create eula.txt
print_status "Creating eula.txt..."
cat > "$SERVER_DIR/eula.txt" << 'EOF'
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://aka.ms/MinecraftEULA).
#Tue Jan 01 00:00:00 UTC 2024
eula=true
EOF

# Create startup script for Linux/Mac
print_status "Creating startup scripts..."
cat > "$SERVER_DIR/start.sh" << EOF
#!/bin/bash
# Priceless World Modpack Server - Startup Script

# Adjust these values as needed
JAVA_FLAGS="-Xms${MEMORY_MIN} -Xmx${MEMORY_MAX} -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"

echo "Starting Priceless World Modpack Server..."
echo "Memory: ${MEMORY_MIN} - ${MEMORY_MAX}"
echo ""

java \$JAVA_FLAGS @libraries/net/neoforged/neoforge/${NEOFORGE_VERSION}/win_args.txt nogui

echo ""
echo "Server stopped. Press any key to exit..."
read -n 1 -s
EOF
chmod +x "$SERVER_DIR/start.sh"

# Create startup script for Windows
cat > "$SERVER_DIR/start.bat" << EOF
@echo off
# Priceless World Modpack Server - Startup Script

# Adjust these values as needed
set JAVA_FLAGS=-Xms${MEMORY_MIN} -Xmx${MEMORY_MAX} -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1

echo Starting Priceless World Modpack Server...
echo Memory: ${MEMORY_MIN} - ${MEMORY_MAX}
echo.

java %JAVA_FLAGS% @libraries/net/neoforged/neoforge/${NEOFORGE_VERSION}/win_args.txt nogui

echo.
echo Server stopped. Press any key to exit...
pause >nul
EOF

# Create README
cat > "$SERVER_DIR/README.md" << 'EOF'
# Priceless World Modpack - Server

## Requirements
- Java 21 or higher
- 4GB+ RAM recommended

## Quick Start

### Linux/Mac
```bash
chmod +x start.sh
./start.sh
```

### Windows
```cmd
start.bat
```

## Configuration

Edit `server.properties` to customize your server settings.

### Recommended Settings
- `difficulty`: normal, hard
- `gamemode`: survival, creative, adventure
- `max-players`: 20 (adjust as needed)
- `view-distance`: 10 (lower for better performance)
- `simulation-distance`: 10 (lower for better performance)

## Performance Tips

1. **Allocate more RAM**: Edit the startup script to increase `-Xmx` value
2. **Use Aikar's Flags**: The startup scripts include optimized JVM flags
3. **Adjust view-distance**: Lower values improve performance
4. **Use Lithium**: Already included in the modpack for server optimization

## Troubleshooting

### Out of Memory
Increase the `-Xmx` value in the startup script.

### Performance Issues
- Reduce `view-distance` in server.properties
- Reduce `simulation-distance` in server.properties
- Close unnecessary programs

### Mods Not Loading
Ensure all mod files are in the `mods/` directory.
EOF

print_status "Server setup complete!"
echo ""
echo "=========================================="
echo "  Server files created in: $SERVER_DIR"
echo "=========================================="
echo ""
echo "To start the server:"
echo "  Linux/Mac:   cd $SERVER_DIR && ./start.sh"
echo "  Windows:     cd $SERVER_DIR && start.bat"
echo ""
echo "Note: First run will download additional files."
echo ""
