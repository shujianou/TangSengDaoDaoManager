@echo off
chcp 65001
set VERSION=1.2.0-SNAPSHOT
set REGISTRY=registry.cn-shenzhen.aliyuncs.com
set IMAGE_NAME=golfonline-im-manager

docker build -t %REGISTRY%/golfonline-cloud/%IMAGE_NAME%:%VERSION% .

set /p push="是否要推送镜像到远程仓库? (Y/N) [Y]: "
if /i not "%push%"=="N" (
    echo 正在登录阿里云镜像仓库...
    docker login %REGISTRY% -u mse@greenjoy -p Htx2022!
    
    echo 正在推送镜像...
    docker push %REGISTRY%/golfonline-cloud/%IMAGE_NAME%:%VERSION%
    echo 镜像推送完成
) else (
    echo 取消推送镜像
)
pause