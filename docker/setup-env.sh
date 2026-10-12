#!/bin/bash

# ==================================================================================================
# HOW TO COPY AND RUN THIS SCRIPT FROM WINDOWS 11 TO WSL 2 (UBUNTU)
# ==================================================================================================
# 1. Open your Ubuntu terminal (WSL 2).
# 2. Run the following command to copy and execute the script in one step:
# cd ~ && cp /mnt/e/repository/java-restaurant-reactive-platform/docker/setup-env.sh . && chmod +x setup-env.sh && ./setup-env.sh
# ==================================================================================================

set -e # Stop the script if a critical error occurs.

# Configuring internal routes in Linux
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
TARGET_DIR="$HOME/docker/java-restaurant-reactive-platform"
WINDOWS_SRC="/mnt/e/repository/java-restaurant-reactive-platform/docker"

echo "Initiating idempotent deployment in the Linux environment (WSL 2)..."

# 0. Take down previous services if the destination directory and compose already exist
if [ -d "$TARGET_DIR" ] && [ -f "$TARGET_DIR/docker-compose.yml" ]; then
    echo "Taking down existing services securely to prevent data corruption..."
    cd "$TARGET_DIR"
    docker compose down --remove-orphans
    cd - > /dev/null
fi

# 1. Create volume directories in /var/opt/[TECHNOLOGY] with sudo if they do not exist
echo "Checking data directories in /var/opt/..."
for tech in postgres mongodb rabbitmq/data rabbitmq/log kafka; do
    if [ ! -d "/var/opt/$tech" ]; then
        echo "   -> Creating /var/opt/$tech"
        sudo mkdir -p "/var/opt/$tech"
        # Assign permissions to the current user so that Docker does not have write conflicts
        sudo chown -R $(whoami):$(whoami) "/var/opt/$tech"
    else
        echo "   -> /var/opt/$tech already exists."
    fi
done

# 2. Create the project directory in your home directory if it does not exist.
if [ ! -d "$TARGET_DIR" ]; then
    echo "Creating the operating environment directory: $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
fi

# 3. Copy configuration files from Windows (Overwrites to keep them up to date)
echo "Copying configuration files from the Windows repository..."
if [ -f "$WINDOWS_SRC/docker-compose.yml" ]; then
    cp "$WINDOWS_SRC/docker-compose.yml" "$TARGET_DIR/"
    echo "   -> docker-compose.yml successfully copied."
else
    echo "Error: docker-compose.yml was not found in $WINDOWS_SRC"
    exit 1
fi

if [ -f "$WINDOWS_SRC/.env" ]; then
    cp "$WINDOWS_SRC/.env" "$TARGET_DIR/"
    echo "   -> .env copied successfully."
else
    echo "Warning: No .env file was found on Windows; the local file will be used if it exists."
fi

# 4. Create a shared external Docker network (To connect the future backend)
echo "Verifying Docker shared network..."
docker network inspect ops-network >/dev/null 2>&1 || docker network create ops-network

# 4.5 Idempotent cleaning of orphaned or problematic containers
echo "Checking for container name conflicts..."
for container_name in rabbitmq postgres mongodb kafka; do
    if [ $(docker ps -a -q -f name=^/${container_name}$) ]; then
        echo "   -> Detected conflicting old container: $container_name. Removing..."
        docker rm -f $container_name
    fi
done

# 5. Change to the destination directory and start the infrastructure
cd "$TARGET_DIR"

echo "Starting or updating containers with Docker Compose..."
docker compose up -d --remove-orphans

echo "¡Infrastructure environment successfully initialized on $TARGET_DIR!"
echo "You can check the containers by running: docker ps"

if [ -f "$SCRIPT_PATH" ]; then
    rm -f "$SCRIPT_PATH"
    if [ -f "$SCRIPT_PATH" ]; then
        echo "Error: Temporary installation script could not delete. Try running the script with sudo if necessary."
    else
        echo "Info: Temporary installation script successfully deleted itself."
    fi
fi