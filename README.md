
# Bitcoin Knots + DATUM Gateway (Docker Compose)

This project sets up a local Bitcoin Knots node and a DATUM Gateway instance using Docker Compose. It allows easy orchestration, persistent volumes, and dynamic configuration using environment variables.

---

## 📦 Components

- **Bitcoin Knots (`bitcoind`)**  
  A Bitcoin node built from source with `--disable-wallet`.

- **[DATUM Gateway]**  
  Decentralized Mining

---

## 🚀 Getting Started

### 1. Clone the Repositories

```bash
git clone https://github.com/electricalgrade/bitcoin 
git clone https://github.com/OCEAN-xyz/datum_gateway
````

Make sure Dockerfiles are present in each directory:

* `bitcoin/contrib/docker/Dockerfile`
* `datum_gateway/Dockerfile`

### 2. Build Docker Images

Build the Bitcoin Knots image:

```bash
cd bitcoin
docker build -t bitcoinknots-custom .
```

Build the DATUM Gateway image:

```bash
cd ../../datum_gateway
docker build -t datum-gateway-custom .
```

---

### 3. Setup `.env`

Create a `.env` file in the same directory as your `docker-compose.yml`:

```env
# .env

# Host volume for Bitcoin node data
BITCOIN_DATA_PATH=/your/local/path/to/bitcoin-data
BITCOIN_CONF_PATH=/your/local/path/to/bitcoin.conf


# Host volume for DATUM Gateway config
DATUM_CONFIG_PATH=/absolute/path/to/datum_config

# RPC Connection Details
BITCOIN_RPC_HOST=bitcoind
BITCOIN_RPC_PORT=8332
BITCOIN_RPC_USER=bitcoin
BITCOIN_RPC_PASSWORD=secret123
```

> ✅ Use **absolute paths** for volume mounts.
> ❗ Replace RPC credentials to match your `bitcoin.conf`.

---

### 4. Prepare DATUM Config

In your `${DATUM_CONFIG_PATH}/config.json`, provide the correct RPC connection:

```json
{
  "rpc_host": "bitcoind",
  "rpc_port": 8332,
  "rpc_user": "bitcoin",
  "rpc_pass": "secret123"
}
```
> Ensure the file exists before you start the containers.

---
## 🔔 Blocknotify Setup

In your `bitcoin.conf` (on the host, within `BITCOIN_DATA_PATH`), set:

```ini
rpcuser=bitcoin
rpcpassword=secret123
blocknotify=wget -q -O /dev/null http://datum_gateway:7152/NOTIFY
```



---

### 5. Run with Docker Compose

```bash
docker compose up -d
```

---

## 🔁 Runtime Behavior

* **bitcoind** exposes ports:

  * `8333`: P2P
  * `8332`: RPC

* **datum\_gateway** exposes:

  * `23334`: Gateway UI / API
  * `7152`: Notification endpoint

---



## 📂 Directory Structure

```
project-root/
├── docker-compose.yml
├── .env
├── bitcoin_data/               # Mapped volume for bitcoind
├── datum_config/
│   └── config.json             # Your DATUM Gateway config
```

---

## 🧪 Health Check

You can verify both services are running:

```bash
docker ps
docker logs datum_gateway
docker logs bitcoind
```

---

## 🧹 Cleanup

To stop and remove everything:

```bash
docker compose down
```

---

## 📄 License

MIT License — your usage may vary depending on upstream licenses of Bitcoin Knots and DATUM Gateway.





