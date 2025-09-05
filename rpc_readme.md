

## 🔧 Setup RPC Authentication Script

Before starting your Docker Compose stack, you need to generate RPC credentials (`rpcauth`) for secure communication between Bitcoin Knots and DATUM Gateway.

### How to Use the Script

The script accepts up to **four optional arguments** — if not provided, default values will be used:

```bash
./generate_rpc_auth.sh [BTC_SRC_DIR] [RPC_USERNAME] [BITCOIN_CONF_PATH] [ENV_FILE_PATH]
```

| Argument            | Description                      | Default          |
| ------------------- | -------------------------------- | ---------------- |
| `BTC_SRC_DIR`       | Path to Bitcoin source directory | `./bitcoin`      |
| `RPC_USERNAME`      | RPC username                     | `datumuser`      |
| `BITCOIN_CONF_PATH` | Path to your `bitcoin.conf` file | `./bitcoin.conf` |
| `ENV_FILE_PATH`     | Path to your `.env` file         | `.env`           |

---

### Example Usage

```bash
# Using all defaults
./generate_rpc_auth.sh

# Custom Bitcoin source path and RPC user
./generate_rpc_auth.sh /path/to/bitcoin myrpcuser

# Custom bitcoin.conf and .env paths
./generate_rpc_auth.sh /path/to/bitcoin myrpcuser /custom/path/bitcoin.conf /custom/path/.env
```

---

### What the script does

* Generates a secure RPC username/password (`rpcauth`) for Bitcoin Knots.
* Appends the `rpcauth` line to your `bitcoin.conf` if not already present.
* Updates your `.env` file with the new `BITCOIN_RPC_USER` and `BITCOIN_RPC_PASSWORD`.
* Prepares your environment for Docker Compose to pick up the new credentials.

---

### Next Steps

1. Run the script to generate and configure RPC credentials.
2. Start your services:

```bash
docker compose up -d
```

