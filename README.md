# HZERO 本地开发环境

基于 `eliu/devbox` 开发的适用于 HZERO 的本地开发环境。

项目具有以下特点：

1. 一致性体验：本地开发环境与生产环境一致，避免因环境差异导致的开发问题。
2. 国内加速器：预配置 DNS 以及国内仓库和软件源。


## 先决条件

本项目基于 Vagrant 和 VirtualBox 搭建，所以开发人员还是需要一些少量的软件安装工作。

- Vagrant： [Vagrant | HashiCorp Developer](https://developer.hashicorp.com/vagrant)
- VirtualBox：[Downloads – Oracle VM VirtualBox](https://www.virtualbox.org/wiki/Downloads)


## 预装软件清单

开发环境启动后会安装如下软件到虚拟机中：

| 软件/系统        | 默认版本             | 备注                                             |
| ---------------- | -------------------- | ------------------------------------------------ |
| Vagrant Box 镜像 | `bento/rockylinux-9` | 基础镜像，提供 Rocky Linux 9 操作系统            |
| OpenJDK          | 17                   |                                                  |
| Apache Maven     | 3.9.12               |                                                  |
| Git              | 2.47.3               | 版本控制                                         |
| CRI              | N/A                  | 容器运行时: docker 或者 podman                   |
| Compose          | N/A                  | 容器编排工具：docker compose 或者 podman compose |
| Node.js          | v18.20.4             | 前端工具                                         |
| Yarn             | 1.22.22              | 前端工具                                         |
| Lerna            | 9.0.3                | 前端工具                                         |

## 配置选项

devbox 中所安装的所有基础软件都可通过配置文件来控制是否要安装，配置文件路径为 `config.properties`，支持的选项及说明如下表所示。默认选项是全部禁用的，开发人员按需更改选项，如需启用，将选项值从 `false` 改为 `true` 即可。

> 提示：`true` 代表安装，`false` 代表卸载。

| 选项                         | 类型   | 含义                                            | 默认值      |
| ---------------------------- | ------ | ----------------------------------------------- | ----------- |
| logging.level                | 字符串 | 日志级别，可选值有`info`, `verbose` ,`debug`    | verbose |
| setup.host.enabled           | 布尔   | 是否配置主机名称                                | true   |
| setup.host.name              | 字符串 | 主机名称                                        | hzero.dev |
| installer.git.enabled        | 布尔   | 是否安装 `Git`                                  | true   |
| installer.openjdk.enabled    | 布尔   | 是否安装 `Open JDK`                             | true   |
| installer.epel.enabled       | 布尔   | 是否安装 `EPEL`                                 | true   |
| installer.maven.enabled      | 布尔   | 是否安装 `Apache Maven`                         | true   |
| installer.npm.enabled   | 布尔   | 是否安装 Node.js | true   |
| installer.container.enabled  | 布尔   | 是否安装容器运行时                              | true   |
| installer.containert.runtime | 字符串 | 容器运行时：podman 或者 docker                  | docker      |

以上选项既可以在一键启动命令 `vagrant up` 之前配置，也可以在其执行之后配置。在调整完之后，运行 `vagrant provision` 命令以生效配置。



## 一键启动

启动命令很简单，按照 Vagrant 官方建议，只需要执行 `vagrant up` 即可一键启动，命令如下：

```bash
$ vagrant up
```



## 置备器

当前的开发环境提供了一个常用的置备器（Provisioner）来按需执行特定的任务。开发环境通过 `vagrant up` 启动成功之后，就可以通过 `vagrant provision --provision-with <provisioner>` 来运行置备器。

### middlewares

该置备器用来以容器化的方式、通过  `Compose`  来启动基础服务，包括 `mysql` ，`redis` 和 `MinIO`，服务组件版本如下：

| 服务  | 版本                         |
| ----- | ---------------------------- |
| mysql | 5.7                          |
| redis | 4-alpine                     |
| minio | RELEASE.2019-10-12T01-39-57Z |

你也可以在 `provisioners/middlewares/config/docker-compose.yaml` 中查看详细的定义，包括默认的数据库用户名和密码等等。

#### 命令1：middlewares_up

该命令启动置备器：

```bash
$ vagrant provision --provision-with "middlewares_up"
```

#### 命令2：middlewares_ps

该命令用于在 `middlewares_up` 执行完之后，查看服务的启动和运行状态，运行命令如下：

```bash
$ vagrant provision --provision-with "middlewares_ps"
```

得到如下类似的检查结果：

```
Name               Command                  State                     Ports
-----------------------------------------------------------------------------------------
minio   /usr/bin/docker-entrypoint ...   Up (healthy)   0.0.0.0:9000->9000/tcp
mysql   docker-entrypoint.sh mysqld      Up             0.0.0.0:3306->3306/tcp, 33060/tcp
redis   docker-entrypoint.sh redis ...   Up             0.0.0.0:6379->6379/tcp
```

### 


## License

[Apache-2.0](LICENSE)

