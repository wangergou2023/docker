# 使用官方的 ubuntu:20.04 镜像作为基础镜像
FROM ubuntu:20.04

# 避免在安装过程中出现与时区相关的交互式提示
ENV DEBIAN_FRONTEND=noninteractive

# 替换 sources.list
RUN sed -i -r 's#http://(archive|security).ubuntu.com#http://mirrors.tuna.tsinghua.edu.cn#g' /etc/apt/sources.list \
  && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo 'Asia/Shanghai' >/etc/timezone

# 更新软件包列表
RUN apt-get update

# 安装必要的工具
RUN apt-get install -y \
# 基础工具1
vim git ssh unzip curl tree \
# 基础工具2
make gcc cmake bear \
# 命令行补全
bash-completion \
# curl chatgpt api依赖
libcurl4-openssl-dev libcjson-dev \
# buildroot编译相关如下
rsync \
# 语言环境
locales language-selector-common \
# uboot kernel编译相关如下
# bison 语法分析器
# flex 词法分析器
# libssl-dev OpenSSL通用库
# lzop LZO压缩库的压缩软件
bison flex libssl-dev dpkg-dev lzop \
device-tree-compiler u-boot-tools libncurses-dev \
bc liblz4-tool kmod cpio \
lsof \
# rootfs
sudo binfmt-support qemu-user-static

# 安装 Python 3.11
RUN apt-get install -y software-properties-common \
  && add-apt-repository ppa:deadsnakes/ppa \
  && apt-get update \
  && apt-get install -y python3.11 python3.11-distutils python3.11-dev \
  && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 \
  && update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1 \
  && curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11

# 解决找不到python2
RUN ln -s /usr/bin/python3 /usr/bin/python2

# 清理不再需要的软件包，以减少镜像大小
RUN apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# 配置 zh_CN.utf8 语言环境
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
ENV LANG zh_CN.utf8

# 设置工作目录
WORKDIR /workspace

# 定义一个挂载点
VOLUME /myvolume

# 将你的项目文件复制到容器中
COPY ./tool_chain /workspace/tool_chain

# 主机使用 split 命令分割压缩文件 因为github现在文件大小
# split -b 50M gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu.tar.gz gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu-part-

# 合并分卷文件
# RUN cat /workspace/tool_chain/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu-part-* > /workspace/tool_chain/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu.tar.gz

# 解压所需文件
# RUN tar -xzf /workspace/tool_chain/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu.tar.gz -C /workspace/tool_chain

# 定编译工具链的绝对路径
# ENV PATH /workspace/tool_chain/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin:$PATH

# 解除 .bashrc 文件中关于 bash_completion 的注释
RUN sed -i '/if \[ -f \/etc\/bash_completion \] && ! shopt -oq posix; then/,/fi/s/^#//g' /root/.bashrc

# 下载并安装Go
RUN curl -LO "https://golang.google.cn/dl/go1.22.0.linux-amd64.tar.gz" && \
    tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz

# 添加Go到PATH环境变量
ENV PATH $PATH:/usr/local/go/bin

# 验证Go安装
RUN go version

