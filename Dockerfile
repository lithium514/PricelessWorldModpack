# Priceless World Modpack - Docker Server with MCDReforged
# Multi-stage build for smaller final image

# Stage 1: Build stage
FROM eclipse-temurin:21-jdk AS builder

# Install required tools
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /build

# Download NeoForge installer
ARG NEOFORGE_VERSION=21.1.233
ARG MC_VERSION=1.21.1

RUN curl -L -o neoforge-installer.jar \
    "https://maven.neoforged.net/releases/net/neoforged/neoforge/${NEOFORGE_VERSION}/neoforge-${NEOFORGE_VERSION}-installer.jar"

# Install NeoForge server
RUN java -jar neoforge-installer.jar --installServer

# Stage 2: Runtime stage
FROM eclipse-temurin:21-jre

# Install required tools including Python 3 for MCDReforged
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Create minecraft user
RUN groupadd -r minecraft && useradd -r -g minecraft minecraft

# Set working directory
WORKDIR /server

# Copy NeoForge server files from builder
COPY --from=builder /build/ .

# Create necessary directories
RUN mkdir -p mods config kubejs world mcdr/plugins mcdr/config mcdr/logs

# Install MCDReforged
ARG MCDR_VERSION=2.15.7
RUN pip3 install --break-system-packages "mcdreforged==${MCDR_VERSION}" || \
    pip3 install --break-system-packages mcdreforged

# Copy modpack files
COPY mods/ ./mods/
COPY defaultconfigs/ ./config/
COPY kubejs/ ./kubejs/

# Create server.properties
RUN echo "#Minecraft server properties" > server.properties && \
    echo "#Priceless World Modpack Server" >> server.properties && \
    echo "sync-tab-ahead=true" >> server.properties && \
    echo "level-seed=" >> server.properties && \
    echo "gamemode=survival" >> server.properties && \
    echo "difficulty=normal" >> server.properties && \
    echo "server-port=25565" >> server.properties && \
    echo "level-name=world" >> server.properties && \
    echo "enable-command-block=false" >> server.properties && \
    echo "max-tick-time=60000" >> server.properties && \
    echo "allow-nether=true" >> server.properties && \
    echo "view-distance=10" >> server.properties && \
    echo "spawn-protection=16" >> server.properties && \
    echo "max-players=20" >> server.properties && \
    echo "network-compression-threshold=256" >> server.properties && \
    echo "require-resource-pack=false" >> server.properties && \
    echo "spawn-monsters=true" >> server.properties && \
    echo "spawn-npcs=true" >> server.properties && \
    echo "allow-flight=false" >> server.properties && \
    echo "generate-structures=true" >> server.properties && \
    echo "spawn-animals=true" >> server.properties && \
    echo "white-list=false" >> server.properties && \
    echo "enforce-whitelist=false" >> server.properties && \
    echo "hardcore=false" >> server.properties && \
    echo "pvp=true" >> server.properties && \
    echo "spawn-limit-ambient=15" >> server.properties && \
    echo "online-mode=true" >> server.properties && \
    echo "allow-rcon=false" >> server.properties && \
    echo "sync-chunk-writes=true" >> server.properties && \
    echo "entity-broadcast-range-percentage=100" >> server.properties && \
    echo "level-type=minecraft\:normal" >> server.properties && \
    echo "spawn-limit-water-animal=5" >> server.properties && \
    echo "max-world-size=29999984" >> server.properties && \
    echo "spawn-limit-axolotls=5" >> server.properties && \
    echo "rate-limit=0" >> server.properties && \
    echo "spawn-limit-golem=0" >> server.properties && \
    echo "enforce-secure-profile=true" >> server.properties && \
    echo "player-idle-timeout=0" >> server.properties && \
    echo "prevent-proxy-connections=false" >> server.properties && \
    echo "function-permission-level=2" >> server.properties && \
    echo "initial-disabled-packs=" >> server.properties && \
    echo "initial-enabled-packs=vanilla" >> server.properties && \
    echo "max-chained-neighbor-updates=1000000" >> server.properties && \
    echo "hide-online-players=false" >> server.properties && \
    echo "status-port=25565" >> server.properties && \
    echo "spawn-limit-monster=70" >> server.properties && \
    echo "spawn-limit-fish=5" >> server.properties && \
    echo "resource-pack=" >> server.properties && \
    echo "resource-pack-prompt=" >> server.properties && \
    echo "resource-pack-sha1=" >> server.properties && \
    echo "resource-pack-id=" >> server.properties && \
    echo "use-native-transport=true" >> server.properties

# Create eula.txt
RUN echo "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://aka.ms/MinecraftEULA)." > eula.txt && \
    echo "#Tue Jan 01 00:00:00 UTC 2024" >> eula.txt && \
    echo "eula=true" >> eula.txt

# Create MCDReforged configuration
ARG NEOFORGE_VERSION=21.1.233
ARG MEMORY_MIN=4G
ARG MEMORY_MAX=8G
RUN echo "# MCDReforged Configuration for Priceless World Modpack" > mcdr/config.yml && \
    echo "language: en_us" >> mcdr/config.yml && \
    echo "start_command: java -Dfile.encoding=UTF-8 -Dstdout.encoding=UTF-8 -Dstderr.encoding=UTF-8 -Xms${MEMORY_MIN} -Xmx${MEMORY_MAX} -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 @libraries/net/neoforged/neoforge/${NEOFORGE_VERSION}/win_args.txt nogui" >> mcdr/config.yml && \
    echo "handler: vanilla_handler" >> mcdr/config.yml && \
    echo "encoding: utf8" >> mcdr/config.yml && \
    echo "decoding: utf8" >> mcdr/config.yml && \
    echo "check_interval: 0.5" >> mcdr/config.yml && \
    echo "server_directory: ../" >> mcdr/config.yml

# Set ownership
RUN chown -R minecraft:minecraft /server

# Switch to minecraft user
USER minecraft

# Expose ports
EXPOSE 25565 25575

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5m --retries=3 \
    CMD pgrep -f "mcdreforged" || pgrep -f "neoforge" || exit 1

# Environment variables
ENV JAVA_FLAGS="-Xms4G -Xmx8G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"

# Start command with MCDReforged
CMD ["sh", "-c", "cd mcdr && python3 -m mcdreforged"]
