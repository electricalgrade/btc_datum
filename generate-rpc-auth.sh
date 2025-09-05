#!/bin/bash

# === Configuration ===
btc_src_dir="${1:-./bitcoin}"  # Path to bitcoin source (can be overridden by CLI arg)
rpc_username="${2:-datumuser}" # RPC username (default: datumuser)
conf_path="${3:-./bitcoin.conf}" # Path to bitcoin.conf
env_path="${4:-.env}"            # Path to .env file for Docker

# === Path to the rpcauth.py script ===
rpcauth_script="$btc_src_dir/share/rpcauth/rpcauth.py"

# === Check script presence ===
if [[ ! -f "$rpcauth_script" ]]; then
  echo "❌ Error: rpcauth.py not found at $rpcauth_script"
  exit 1
fi

# === Generate rpcauth output ===
echo "🔐 Generating rpcauth for user: $rpc_username"
rpc_output=$(python3 "$rpcauth_script" "$rpc_username")

# === Parse rpcauth line ===
rpcauth_line=$(echo "$rpc_output" | grep "^rpcauth=" | head -n 1)

# === Parse password (line after "Your password:") ===
rpc_password=""
if grep -q "^Your password:" <<< "$rpc_output"; then
    pwd_line_num=$(grep -n "^Your password:" <<< "$rpc_output" | cut -d':' -f1)
    if [ -n "$pwd_line_num" ]; then
        next_line=$((pwd_line_num + 1))
        rpc_password=$(sed -n "${next_line}p" <<< "$rpc_output" | xargs)
    fi
fi

# === Validate ===
if [[ -z "$rpcauth_line" || -z "$rpc_password" ]]; then
    echo "❌ Failed to parse rpcauth or password"
    echo "--- Raw Output ---"
    echo "$rpc_output"
    exit 1
fi

echo "✅ Parsed:"
echo "  rpcauth line : $rpcauth_line"
echo "  password     : $rpc_password"

# === Append to bitcoin.conf ===
if [[ -f "$conf_path" ]] && grep -q "^rpcauth=${rpc_username}:" "$conf_path"; then
    echo "ℹ️  rpcauth already exists in $conf_path. Skipping."
else
    echo -e "\n# RPC credentials for $rpc_username" >> "$conf_path"
    echo "$rpcauth_line" >> "$conf_path"
    echo "✅ Added rpcauth to $conf_path"
fi

# === Update .env file ===
touch "$env_path"
sed -i "/^BITCOIN_RPC_USER=/d" "$env_path"
sed -i "/^BITCOIN_RPC_PASSWORD=/d" "$env_path"
echo "BITCOIN_RPC_USER=$rpc_username" >> "$env_path"
echo "BITCOIN_RPC_PASSWORD=$rpc_password" >> "$env_path"
echo "✅ Updated $env_path with credentials"
