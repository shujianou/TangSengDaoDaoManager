#!/bin/sh
# 检查命令执行状态
check_status() {
    if [ $? -ne 0 ]; then
        echo "Error: Command failed"
        exit 1
    fi
}

# 检查必需的环境变量
if [ -z "$API_URL" ]; then
    echo "Error: API_URL environment variable is not set"
    exit 1
fi

# 替换配置文件中的环境变量
envsubst '${API_URL}' < /nginx.conf.template > /etc/nginx/conf.d/default.conf
check_status

# 执行传入的命令
exec "$@"