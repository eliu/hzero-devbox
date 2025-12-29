# 本地开发环境 (devbox)

这是一个可以在本地快速启动用于本地开发的虚拟机模板，可提供容器化环境、Java后端和前端编译工具等。开发人员可以得到一个与服务器环境一致的本地开发环境。

项目具有以下特点：

1. 一致性体验：本地开发环境与生产环境一致，避免因环境差异导致的开发问题。
2. 国内加速器：预配置 DNS 以及国内仓库和软件源。


## 先决条件

本项目基于 Vagrant 和 VirtualBox 搭建，所以开发人员还是需要一些少量的软件安装工作。

- Vagrant： [Vagrant | HashiCorp Developer](https://developer.hashicorp.com/vagrant)
- VirtualBox：[Downloads – Oracle VM VirtualBox](https://www.virtualbox.org/wiki/Downloads)


## 预装软件清单

开发环境启动后会安装如下软件到虚拟机中：

| 软件/系统        | 默认版本              | 备注                                             |
| ---------------- | --------------------- | ------------------------------------------------ |
| Vagrant Box 镜像 | `bento/rockylinux-10` | 基础镜像，提供 Rocky Linux 9 操作系统            |
| OpenJDK          |                       |                                                  |
| Apache Maven     | 3.9.12                |                                                  |
| Git              | 2.47.3                | 版本控制                                         |
| CRI              | N/A                   | 容器运行时: docker 或者 podman                   |
| Compose          | N/A                   | 容器编排工具：docker compose 或者 podman compose |
| Node.js          | 24.1.0                | 前端工具                                         |

## 配置选项

devbox 中所安装的所有基础软件都可通过配置文件来控制是否要安装，配置文件路径为 `etc/devbox.properties`，支持的选项及说明如下表所示。默认选项是全部禁用的，开发人员按需更改选项，如需启用，将选项值从 `false` 改为 `true` 即可。

> 提示：`true` 代表安装，`false` 代表卸载。

| 选项                         | 类型   | 含义                                            | 默认值      |
| ---------------------------- | ------ | ----------------------------------------------- | ----------- |
| logging.level                | 字符串 | 日志级别，可选值有`info`, `verbose` ,`debug`    | info        |
| setup.host.enabled           | 布尔   | 是否配置主机名称                                | false       |
| setup.host.name              | 字符串 | 主机名称                                        | example.com |
| installer.git.enabled        | 布尔   | 是否安装 `Git`                                  | false       |
| installer.openjdk.enabled    | 布尔   | 是否安装 `Open JDK`                             | false       |
| installer.epel.enabled       | 布尔   | 是否安装 `EPEL`                                 | false       |
| installer.maven.enabled      | 布尔   | 是否安装 `Apache Maven`                         | false       |
| installer.npm.enabled   | 布尔   | 是否安装 Node.js | false       |
| installer.container.enabled  | 布尔   | 是否安装容器运行时                              | false       |
| installer.containert.runtime | 字符串 | 容器运行时：podman 或者 docker                  | docker      |

以上选项既可以在一键启动命令 `vagrant up` 之前配置，也可以在其执行之后配置。在调整完之后，运行 `vagrant provision` 命令以生效配置。

## 一键启动

启动命令很简单，按照 Vagrant 官方建议，只需要执行 `vagrant up` 即可一键启动，命令如下：

```bash
$ vagrant up
```

> 提示：初次运行时由于开发人员本地还未下载任何 Vagrant 基础镜像文件，因此初次运行时会花费更多的时间来下载基础镜像。此处暂无国内环境下的提速方法，所以此时体验不佳。但随后的初始化过程由于使用了国内加速镜像站，速度上会有保障。

安装过程中会输出日志，最后会输出所有已安装成功的软件版本清单。在所有配置项均启用的时候，日志内容大致如下：

```shell
default: Running provisioner: shell...
default: Running: inline script
default: installer.container.enabled  =  true
default: installer.container.runtime  =  docker
default: installer.epel.enabled       =  false
default: installer.git.enabled        =  true
default: installer.maven.enabled      =  true
default: installer.maven.version      =  3.9.12
default: installer.npm.enabled        =  true
default: installer.npm.version        =  24.1.0
default: installer.openjdk.enabled    =  true
default: installer.openjdk.version    =  21
default: logging.level                =  verbose
default: setup.host.enabled           =  false
default: setup.host.name              =  example.com
default: VERBOSE: (13) properties already cached.
default: [INFO] Installing node and npm...
default: VERBOSE: Downloading https://mirrors.aliyun.com/nodejs-release/v24.1.0/node-v24.1.0-linux-x64.tar.xz
default: VERBOSE: Extracting files to /opt...
default: VERBOSE: Setting up environment for PATH...
default: [INFO] Accelerating npm registry...
default: VERBOSE: Gathering facts for networks...
default: dns  =  114.114.114.114,8.8.8.8,0.187.2.4,192.168.3.1,fd17:625c:f037:2::3
default: ip   =  192.168.133.100
default: VERBOSE: Installation complete! Wrap it up...
default: CATEGORY   NAME     VALUE
default: ---------  ----     -----
default: PROPERTY   OS       Rocky Linux release 10.0 (Red Quartz)
default: PROPERTY   IP       192.168.133.100
default: PROPERTY   DNS      114.114.114.114,8.8.8.8,0.187.2.4,192.168.3.1,fd17:625c:f037:2::3
default: ---------  ----     -----
default: VERSION    GIT      2.47.3
default: VERSION    OPENJDK  21.0.9
default: VERSION    MAVEN    3.9.12
default: VERSION    PIP3     23.3.2
default: VERSION    docker   29.1.3
default: VERSION    NODE     v24.1.0
default: VERSION    NPM      11.3.0
```

## 置备器

当前的开发环境提供了一个常用的置备器（Provisioner）来按需执行特定的任务。开发环境通过 `vagrant up` 启动成功之后，就可以通过 `vagrant provision --provision-with <provisioner>` 来运行置备器。

### base_services

#### 命令1：base_services_up

该命令用来以容器化的方式、通过  `Compose`  来启动基础服务，包括 `mysql` ，`redis` 和 `MinIO`，服务组件版本如下：

| 服务  | 版本                         |
| ----- | ---------------------------- |
| mysql | 5.7                          |
| redis | 4-alpine                     |
| minio | RELEASE.2019-10-12T01-39-57Z |

你也可以在 `provisioners/base_services/config/docker-compose.yaml` 中查看详细的定义，包括默认的数据库用户名和密码等等。启动置备器的命令如下：

```bash
$ vagrant provision --provision-with "base_services_up"
```

#### 命令2：base_services_ps

该命令用于在 `base_services_up` 执行完之后，查看服务的启动和运行状态，运行命令如下：

```bash
$ vagrant provision --provision-with "base_services_ps"
```

得到如下类似的检查结果：

```
Name               Command                  State                     Ports
-----------------------------------------------------------------------------------------
minio   /usr/bin/docker-entrypoint ...   Up (healthy)   0.0.0.0:9000->9000/tcp
mysql   docker-entrypoint.sh mysqld      Up             0.0.0.0:3306->3306/tcp, 33060/tcp
redis   docker-entrypoint.sh redis ...   Up             0.0.0.0:6379->6379/tcp
```

### 自定义置备器

你可以根据置备器 `base_services` 的格式，自定义自己的置备器，基本步骤如下：

1. [必需] 在 `provisioners` 目录下创建一个新的目录，目录名就是你自定义的置备器名称，例如 `my_provisioner`。
2. [可选] 在新目录下创建一个 `config` 目录，用于存放置备器的配置文件。
3. [必需] 在新目录下创建一个 `provision.rb` 文件，用于定义置备器的运行环境和任务，例如：
```ruby
# my_provisioner/provision.rb
# my_provisioner -> MyProvisioner
class MyProvisioner
  @name = "my_provisioner"
  @enabled = true

  def provision(config)
    config.vm.provision 'shell', inline: 'echo "Hello, World!"'
  end
end
```

之后运行：`vagrant provision --provision-with "my_provisioner"`


## License

[Apache-2.0](LICENSE)

