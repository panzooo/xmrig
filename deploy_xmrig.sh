#!/bin/bash
set -e

# === 配置参数 ===
POOL="141.148.173.232:3333"
WALLET="45MQKzDPTVvbWechMZY1L3iGwq3vu2thf7W9PrSAspHiPCHtPbEQ49D5HPXkd8WcXGTZgarFoWChx8qo8bQB9ok24FkauVG"
RIG_ID="node_$(hostname)"
WORK_DIR="/opt/xmrig"
CPU_USAGE=90

# === 设置 needrestart 为自动模式（避免交互提示） ===
export NEEDRESTART_MODE=a
export DEBIAN_FRONTEND=noninteractive

# === 安装依赖 ===
apt-get update
apt-get install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev

# === 下载并编译 xmrig ===
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"
if [ ! -d "xmrig" ]; then
    git clone https://github.com/xmrig/xmrig.git
fi
cd xmrig
mkdir -p build && cd build
cmake ..
make -j$(nproc)

# === 启动矿工（前台运行一次看是否成功）===
"$WORK_DIR/xmrig/build/xmrig" -o "$POOL" -u "$WALLET" -p x --rig-id "$RIG_ID" -k --coin monero --threads $(($(nproc)*CPU_USAGE/100))