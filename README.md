# XrayR

[![](https://img.shields.io/badge/TgChat-@XrayR讨论-blue.svg)](https://t.me/XrayR_project)
[![](https://img.shields.io/badge/Channel-@XrayR通知-blue.svg)](https://t.me/XrayR_channel)
![](https://img.shields.io/github/stars/reddts/XrayR)
![](https://img.shields.io/github/forks/reddts/XrayR)
![](https://github.com/reddts/XrayR/actions/workflows/release.yml/badge.svg)
![](https://github.com/reddts/XrayR/actions/workflows/docker.yml/badge.svg)
[![Github All Releases](https://img.shields.io/github/downloads/reddts/XrayR/total.svg)]()


[English](https://github.com/reddts/XrayR/blob/master/README-en.md)|[Iranian](https://github.com/reddts/XrayR/blob/master/README_Fa.md)|[Vietnamese](https://github.com/reddts/XrayR/blob/master/README-vi.md)

A Xray backend framework that can easily support many panels.

一个基于Xray的后端框架，支持V2ay,Trojan,Shadowsocks协议，极易扩展，支持多面板对接。

如果您喜欢本项目，可以右上角点个star+watch，持续关注本项目的进展。

使用说明：[旧版文档说明与 Docker 简要部署](https://github.com/reddts/XrayR/wiki/Documentation-Notice)


## 免责声明

本项目只是本人个人学习开发并维护，本人不保证任何可用性，也不对使用本软件造成的任何后果负责。

## 特点

* 永久开源且免费。
* 支持V2ray，Trojan， Shadowsocks多种协议。
* 支持Vless和XTLS等新特性。
* 支持单实例对接多面板、多节点，无需重复启动。
* 支持限制在线IP
* 支持节点端口级别、用户级别限速。
* 配置简单明了。
* 修改配置自动重启实例。
* 方便编译和升级，可以快速更新核心版本， 支持Xray-core新特性。

## 功能介绍

| 功能        | v2ray | trojan | shadowsocks |
|-----------|-------|--------|-------------|
| 获取节点信息    | √     | √      | √           |
| 获取用户信息    | √     | √      | √           |
| 用户流量统计    | √     | √      | √           |
| 服务器信息上报   | √     | √      | √           |
| 自动申请tls证书 | √     | √      | √           |
| 自动续签tls证书 | √     | √      | √           |
| 在线人数统计    | √     | √      | √           |
| 在线用户限制    | √     | √      | √           |
| 审计规则      | √     | √      | √           |
| 节点端口限速    | √     | √      | √           |
| 按照用户限速    | √     | √      | √           |
| 自定义DNS    | √     | √      | √           |

## 支持前端

| 前端                                                     | v2ray | trojan | shadowsocks             |
|--------------------------------------------------------|-------|--------|-------------------------|
| sspanel-uim                                            | √     | √      | √ (单端口多用户和V2ray-Plugin) |
| v2board                                                | √     | √      | √                       |
| [PMPanel](https://github.com/ByteInternetHK/PMPanel)   | √     | √      | √                       |
| [ProxyPanel](https://github.com/ProxyPanel/ProxyPanel) | √     | √      | √                       |
| [WHMCS (V2RaySocks)](https://v2raysocks.doxtex.com/)   | √     | √      | √                       |
| [GoV2Panel](https://github.com/pingProMax/gov2panel)   | √     | √      | √                       |
| [BunPanel](https://github.com/pennyMorant/bunpanel-release)   | √     | √      | √                       |

## 软件安装

### 一键安装

```
curl -fsSLo install.sh https://raw.githubusercontent.com/reddts/XrayR/master/install.sh && sudo bash install.sh
```

首次使用前需先在 reddts/XrayR 创建正式 Release，并包含 Linux ZIP 包及对应的 `.dgst` 校验文件。

### 管理脚本中的 BBR 功能

`XrayR.sh` 管理菜单的第 11 项会调用第三方 Linux-NetSpeed 脚本配置 BBR 等 TCP 加速功能。该功能只在手动选择菜单项后运行，不会随 XrayR 安装或启动自动执行，也不是 XrayR 的通讯功能。

该脚本从 `chiakge/Linux-NetSpeed` 仓库的可变 `master` 分支下载并立即执行，且 `XrayR.sh` 要求以 root 权限运行。脚本选项可能修改系统网络参数、安装或移除内核，并可能要求重启；请仅在了解这些影响并确实需要 TCP 加速时使用。

### 使用Docker部署软件

[Docker部署说明（含旧版文档提示）](https://github.com/reddts/XrayR/wiki/Documentation-Notice)

### 手动安装

[手动安装教程](https://xrayr-project.github.io/XrayR-doc/xrayr-xia-zai-he-an-zhuang/install/manual)

## 配置文件及详细使用教程

[详细使用教程](https://xrayr-project.github.io/XrayR-doc/)

## Thanks

* [Project X](https://github.com/XTLS/)
* [V2Fly](https://github.com/v2fly)
* [VNet-V2ray](https://github.com/ProxyPanel/VNet-V2ray)
* [Air-Universe](https://github.com/crossfw/Air-Universe)

## Licence

[Mozilla Public License Version 2.0](https://github.com/reddts/XrayR/blob/master/LICENSE)
