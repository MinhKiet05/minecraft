# Vanilla Minecraft Server

This repo currently contains a Forge modded server setup. To turn it into a clean vanilla server, keep only the files you actually need to run the game and remove the modpack/tunnel extras manually.

## What to keep for vanilla

- `server.jar`
- `world/`
- `server.properties`
- `eula.txt`
- `start.sh`
- `stop.sh`
- `save.sh`

## What is modded or custom right now

- `mods/` contains Forge mods and dependencies.
- `config/` contains mod configuration files.
- `tacz/` and `tacz_backup/` belong to the TacZ content pack.
- `playit` and `playit.toml` are for the Playit tunnel agent.
- `init.sh` was previously used to install Forge and Playit automatically.

## Server type

This repo is currently a Forge 1.20.1 server, not vanilla.

## Java version

Use Java 17 for Minecraft 1.20.1 vanilla server.

## Simple Linux workflow

1. Install Java 17.
2. Put the official Minecraft server jar in the repo root and name it `server.jar`.
3. Run `chmod +x init.sh start.sh stop.sh save.sh` once.
4. Run `./init.sh`.
5. Run `./start.sh` to start the server.
6. Open the server console and type `stop` to shut it down cleanly, or run `./stop.sh` for a quick stop signal.
7. Run `./save.sh` to make a backup archive in `backups/`.

## Minimal scripts

### `start.sh`

Starts the vanilla server with configurable RAM.

Environment variables:

- `SERVER_JAR` default: `server.jar`
- `RAM_MIN` default: `1G`
- `RAM_MAX` default: `2G`

Example:

```bash
RAM_MIN=2G RAM_MAX=4G ./start.sh
```

### `stop.sh`

Sends a terminate signal to the running Java process that matches `server.jar`.

If you started the server in the foreground, the cleanest stop method is still typing `stop` in the server console or pressing `Ctrl+C` in that terminal.

### `save.sh`

Creates a `.tar.gz` backup in `backups/` with:

- `world/`
- `server.properties`
- `eula.txt`
- `start.sh`
- `stop.sh`

## From zero to running

### 1. Install Java 17

On Debian or Ubuntu:

```bash
sudo apt update
sudo apt install -y openjdk-17-jre-headless
java -version
```

### 2. Download the vanilla server jar

Download the official Minecraft server jar for your target version and save it as `server.jar` in the repo root.

### 3. Accept the EULA

Set `eula=true` in `eula.txt`.

### 4. Make scripts executable

```bash
chmod +x init.sh start.sh stop.sh save.sh
```

### 5. Start the server

```bash
./start.sh
```

### 6. Stop the server

Inside the server console:

```text
stop
```

Or from another terminal:

```bash
./stop.sh
```

### 7. Back up the world

```bash
./save.sh
```

## Public address options

### Playit

Playit creates a tunnel from your machine to a public address. In this repo, `playit` and `playit.toml` are the Playit agent files.

### ngrok

Ngrok is another tunneling service. You would point it at your local Minecraft port, usually `25565`, and share the generated address.

### joinmc.link

`gifts-tobago.gl.joinmc.link` is a public domain from the joinmc service. The repo does not contain a file that directly configures this domain, so it is likely managed outside the repo or by the tunnel provider.

### Port forwarding

With port forwarding, you open TCP port `25565` on your router and point it to the machine running the server.

## Current repo status

The current repo is too complex for a true one-click vanilla switch because it still contains Forge mods, TacZ content, and Playit config. The safest path is:

1. Keep the world only if you want to preserve the current map.
2. Remove the mod and tunnel folders manually.
3. Add a fresh vanilla `server.jar`.
4. Use the scripts in this repo as the new minimal launcher.
