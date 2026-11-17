# XrayR

![](https://img.shields.io/github/stars/reddts/XrayR)
![](https://img.shields.io/github/forks/reddts/XrayR)
![](https://github.com/reddts/XrayR/actions/workflows/release.yml/badge.svg)
![](https://github.com/reddts/XrayR/actions/workflows/docker.yml/badge.svg)
[![Github All Releases](https://img.shields.io/github/downloads/reddts/XrayR/total.svg)]()

[Iranian(farsi) README](https://github.com/reddts/XrayR/blob/master/README_Fa.md), [Vietnamese(vi) README](https://github.com/reddts/XrayR/blob/master/README-vi.md), [English(en) README](https://github.com/reddts/XrayR/blob/master/README-en.md)

A Xray backend framework that can easily support many panels.

A back -end framework based on XRAY supports V2ay, Trojan, Shadowsocks protocols, which are easy to expand and support multi -panel docker.


If you like this project, you can click STAR+WATCH in the upper right corner to continue to pay attention to the progress of this project.

## Guide for use

Guide: [Documentation notice and brief Docker deployment](https://github.com/reddts/XrayR/wiki/Documentation-Notice)


## Disclaimer

This project is just my personal learning and development and maintenance. I do not guarantee any availability and is not responsible for any consequences caused by the use of this software.

## Features

* Permanent open source and free.
* Support V2Ray, Trojan, Shadowsocks multiple protocols.
* Support new features such as Vless and XTLS.
* Support single instance docking multi -panel and multi -node, no need to start repeatedly.
* Support restriction online IP
* Support node port level and user level speed limit.
* The configuration is simple and clear.
* Modify the automatic restart instance.
* Easy to compile and upgrade, you can quickly update the core version and support the new features of XRAY-CORE.

## Function

| Function        | v2ray | trojan | shadowsocks |
|-----------|-------|--------|-------------|
| Get node information    | √     | √      | √           |
| Get user information    | √     | √      | √           |
| User traffic statistics    | √     | √      | √           |
| Server information report   | √     | √      | √           |
| Automatically apply for a TLS certificate | √     | √      | √           |
| Automatic renewal TLS certificate | √     | √      | √           |
| Number of online people    | √     | √      | √           |
| Online user restrictions    | √     | √      | √           |
| Audit rules      | √     | √      | √           |
| Node port speed limit    | √     | √      | √           |
| According to user speed limit    | √     | √      | √           |
| Custom DNS    | √     | √      | √           |

## Support for panels

| Panel                                                     | v2ray | trojan | shadowsocks             |
|--------------------------------------------------------|-------|--------|-------------------------|
| sspanel-uim                                            | √     | √      | √ (Single-ended multi-user and V2Ray-Plugin) |
| v2board                                                | √     | √      | √                       |
| [PMPanel](https://github.com/ByteInternetHK/PMPanel)   | √     | √      | √                       |
| [ProxyPanel](https://github.com/ProxyPanel/ProxyPanel) | √     | √      | √                       |
| [WHMCS (V2RaySocks)](https://v2raysocks.doxtex.com/)   | √     | √      | √                       |
| [BunPanel](https://github.com/pennyMorant/bunpanel-release)   | √     | √      | √                       |

## Software Installation

### 1-Click installation

```
curl -fsSLo install.sh https://raw.githubusercontent.com/reddts/XrayR/master/install.sh && sudo bash install.sh
```

Before using the installer, publish a GitHub Release with the Linux ZIP and its matching `.dgst` checksum.

### Docker

[Docker deployment notes and legacy documentation notice](https://github.com/reddts/XrayR/wiki/Documentation-Notice)

### Manual installation

[Legacy documentation notice](https://github.com/reddts/XrayR/wiki/Documentation-Notice)

## Configuration file and detailed use tutorial

[Documentation notice](https://github.com/reddts/XrayR/wiki/Documentation-Notice)

## Thanks

* [Project X](https://github.com/XTLS/)
* [V2Fly](https://github.com/v2fly)
* [VNet-V2ray](https://github.com/ProxyPanel/VNet-V2ray)
* [Air-Universe](https://github.com/crossfw/Air-Universe)

## Licence

[Mozilla Public License Version 2.0](https://github.com/reddts/XrayR/blob/master/LICENSE)

