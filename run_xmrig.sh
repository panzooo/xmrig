#!/bin/bash

# 安装依赖
sudo apt update && sudo apt upgrade -y
sudo apt install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev -y

# 下载并编译 XMRig
cd ~
git clone https://github.com/xmrig/xmrig.git
cd xmrig
mkdir build && cd build
cmake ..
make -j$(nproc)

# 写入配置文件
cat > config.json << EOF
{
  "autosave": true,
  "cpu": true,
  "pools": [
    {
      "url": "pool.supportxmr.com:7777",
      "user": "45MQKzDPTVvbWechMZY1L3iGwq3vu2thf7W9PrSAspHiPCHtPbEQ49D5HPXkd8WcXGTZgarFoWChx8qo8bQB9ok24FkauVG",
      "pass": "x",
      "keepalive": true,
      "tls": false
    }
  ]
}
EOF

# 开启大页内存
sudo sysctl -w vm.nr_hugepages=1280

# 启动挖矿
echo "启动 XMRig 挖矿程序..."
./xmrig -c config.json
