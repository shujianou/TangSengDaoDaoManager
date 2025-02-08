#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import subprocess
import sys

def main():
    # 设置环境变量
    VERSION = "1.2.0-SNAPSHOT"
    REGISTRY = "registry.cn-shenzhen.aliyuncs.com"
    IMAGE_NAME = "golfonline-im-manager"
    
    # 构建完整的镜像名称
    full_image_name = f"{REGISTRY}/golfonline-cloud/{IMAGE_NAME}:{VERSION}"
    
    # 构建 Docker 镜像
    print("正在构建 Docker 镜像...")
    build_cmd = f"docker build -t {full_image_name} ."
    subprocess.run(build_cmd, shell=True, check=True)
    
    # 询问是否推送镜像
    push = input("是否要推送镜像到远程仓库? (Y/N) [Y]: ").strip().upper()
    
    if push != "N":
        print("正在登录阿里云镜像仓库...")
        login_cmd = f"docker login {REGISTRY} -u mse@greenjoy -p Htx2022!"
        subprocess.run(login_cmd, shell=True, check=True)
        
        print("正在推送镜像...")
        push_cmd = f"docker push {full_image_name}"
        subprocess.run(push_cmd, shell=True, check=True)
        print("镜像推送完成")
    else:
        print("取消推送镜像")
    
    input("按回车键继续...")

if __name__ == "__main__":
    main() 