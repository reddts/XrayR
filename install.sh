#!/usr/bin/env bash

set -Eeuo pipefail

readonly REPOSITORY="reddts/XrayR"
readonly INSTALL_DIR="/usr/local/XrayR"
readonly CONFIG_DIR="/etc/XrayR"
readonly SERVICE_FILE="/etc/systemd/system/XrayR.service"
readonly SERVICE_URL="https://raw.githubusercontent.com/reddts/XrayR/master/XrayR.service"
readonly MANAGER_URL="https://raw.githubusercontent.com/reddts/XrayR/master/XrayR.sh"

fail() {
    printf '错误：%s\n' "$*" >&2
    exit 1
}

usage() {
    cat <<'EOF'
用法：sudo bash install.sh [版本号]

不指定版本时安装 reddts/XrayR 的最新正式 Release。
指定版本时可写 v0.9.6 或 0.9.6。
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi
[[ $# -le 1 ]] || { usage >&2; exit 2; }
[[ "$(id -u)" -eq 0 ]] || fail "请使用 root 运行，例如：sudo bash install.sh"
[[ "$(uname -s)" == "Linux" ]] || fail "此安装脚本只支持 Linux。"
command -v systemctl >/dev/null 2>&1 || fail "未找到 systemctl；当前系统需要 systemd。"

if [[ -r /etc/os-release ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
else
    fail "无法识别 Linux 发行版。"
fi

install_base() {
    if command -v apt-get >/dev/null 2>&1; then
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl unzip cron socat
    elif command -v dnf >/dev/null 2>&1; then
        dnf install -y ca-certificates curl unzip cronie socat
    elif command -v yum >/dev/null 2>&1; then
        yum install -y ca-certificates curl unzip cronie socat
    else
        fail "未找到 apt-get、dnf 或 yum；请先安装 curl、unzip 和 ca-certificates。"
    fi
}

install_base

machine="$(uname -m)"
case "$machine" in
    x86_64|amd64) asset_arch="linux-64" ;;
    i386|i486|i586|i686) asset_arch="linux-32" ;;
    aarch64|arm64) asset_arch="linux-arm64-v8a" ;;
    armv7l|armv7*) asset_arch="linux-arm32-v7a" ;;
    armv6l|armv6*) asset_arch="linux-arm32-v6" ;;
    armv5tel|armv5*) asset_arch="linux-arm32-v5" ;;
    s390x) asset_arch="linux-s390x" ;;
    riscv64) asset_arch="linux-riscv64" ;;
    ppc64le) asset_arch="linux-ppc64le" ;;
    mips64) asset_arch="linux-mips64" ;;
    mips64el) asset_arch="linux-mips64le" ;;
    mips) asset_arch="linux-mips32" ;;
    mipsel) asset_arch="linux-mips32le" ;;
    *) fail "暂不支持架构 $machine；请从 Release 页面选择合适的构建。" ;;
esac

version="${1:-}"
if [[ -z "$version" ]]; then
    release_json="$(curl --fail --silent --show-error --location --retry 3 \
        "https://api.github.com/repos/${REPOSITORY}/releases/latest")" \
        || fail "无法读取 ${REPOSITORY} 的最新 Release。"
    version="$(printf '%s\n' "$release_json" | sed -n \
        's/^[[:space:]]*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)"
    [[ -n "$version" ]] || fail "仓库还没有正式 Release；请先发布包含 Linux ZIP 包的版本。"
elif [[ "$version" != v* ]]; then
    version="v${version}"
fi
[[ "$version" =~ ^v?[A-Za-z0-9][A-Za-z0-9._+-]*$ ]] || fail "版本号格式不正确：$version"

archive_name="XrayR-${asset_arch}.zip"
base_url="https://github.com/${REPOSITORY}/releases/download/${version}/${archive_name}"
work_dir="$(mktemp -d)" || fail "无法创建临时目录。"
trap 'rm -rf "$work_dir"' EXIT

printf '准备安装 XrayR %s（%s）\n' "$version" "$asset_arch"
curl --fail --silent --show-error --location --retry 3 "$base_url" \
    --output "$work_dir/$archive_name" || fail "下载发布包失败：$base_url"
curl --fail --silent --show-error --location --retry 3 "${base_url}.dgst" \
    --output "$work_dir/${archive_name}.dgst" \
    || fail "下载 SHA-256 校验文件失败：${base_url}.dgst"

expected_hash="$(awk '/^SHA2-256[[:space:]]*=/ { print $NF; exit }' \
    "$work_dir/${archive_name}.dgst")"
[[ "$expected_hash" =~ ^[[:xdigit:]]{64}$ ]] || fail "校验文件中没有有效的 SHA-256 值。"
actual_hash="$(sha256sum "$work_dir/$archive_name" | awk '{ print $1 }')"
[[ "$(printf '%s' "$expected_hash" | tr '[:upper:]' '[:lower:]')" == "$actual_hash" ]] \
    || fail "发布包 SHA-256 校验失败。"

unzip -tq "$work_dir/$archive_name" >/dev/null || fail "发布 ZIP 文件损坏。"
unzip -Z1 "$work_dir/$archive_name" >"$work_dir/archive.list" \
    || fail "无法读取 ZIP 文件目录。"
while IFS= read -r entry; do
    case "/$entry/" in
        *"/../"*) fail "ZIP 文件包含不安全路径：$entry" ;;
    esac
    [[ "$entry" != /* ]] || fail "ZIP 文件包含绝对路径：$entry"
done <"$work_dir/archive.list"

mkdir -p "$work_dir/package"
unzip -q "$work_dir/$archive_name" -d "$work_dir/package" \
    || fail "解压发布包失败。"
[[ -f "$work_dir/package/XrayR" ]] || fail "发布包中缺少 XrayR 可执行文件。"

# Fetch the service and manager from this maintained branch before changing files.
curl --fail --silent --show-error --location --retry 3 "$SERVICE_URL" \
    --output "$work_dir/XrayR.service" || fail "下载 XrayR.service 失败。"
curl --fail --silent --show-error --location --retry 3 "$MANAGER_URL" \
    --output "$work_dir/XrayR.sh" || fail "下载 XrayR.sh 失败。"
grep -q '^ExecStart=/usr/local/XrayR/XrayR --config /etc/XrayR/config.yml$' \
    "$work_dir/XrayR.service" || fail "下载到的 XrayR.service 内容不符合预期。"
grep -q '^#!/bin/bash' "$work_dir/XrayR.sh" || fail "下载到的 XrayR.sh 内容不符合预期。"

config_existed=0
[[ -f "$CONFIG_DIR/config.yml" ]] && config_existed=1
was_active=0
systemctl is-active --quiet XrayR.service && was_active=1 || true

install -d -m 0755 "$INSTALL_DIR" "$CONFIG_DIR"
install -m 0755 "$work_dir/package/XrayR" "$INSTALL_DIR/XrayR.new"
mv -f "$INSTALL_DIR/XrayR.new" "$INSTALL_DIR/XrayR"

for file in geoip.dat geosite.dat; do
    if [[ -f "$work_dir/package/$file" ]]; then
        install -m 0644 "$work_dir/package/$file" "$CONFIG_DIR/$file.new"
        mv -f "$CONFIG_DIR/$file.new" "$CONFIG_DIR/$file"
    fi
done

for file in config.yml dns.json route.json custom_inbound.json custom_outbound.json rulelist; do
    if [[ -f "$work_dir/package/$file" && ! -e "$CONFIG_DIR/$file" ]]; then
        mode=0644
        [[ "$file" != "config.yml" ]] || mode=0600
        install -m "$mode" "$work_dir/package/$file" "$CONFIG_DIR/$file"
    fi
done

install -m 0644 "$work_dir/XrayR.service" "$SERVICE_FILE"
install -m 0755 "$work_dir/XrayR.sh" /usr/bin/XrayR.new
mv -f /usr/bin/XrayR.new /usr/bin/XrayR
ln -sfn /usr/bin/XrayR /usr/bin/xrayr

systemctl daemon-reload
systemctl enable XrayR.service
if [[ "$config_existed" -eq 1 ]]; then
    if [[ "$was_active" -eq 1 ]]; then
        systemctl restart XrayR.service
    else
        systemctl start XrayR.service
    fi
    printf 'XrayR %s 安装完成，服务已启动。\n' "$version"
else
    printf 'XrayR %s 已安装。请先编辑 %s/config.yml，再运行 XrayR start。\n' "$version" "$CONFIG_DIR"
fi
printf '管理命令：XrayR start|stop|restart|status|log|update|config|uninstall\n'
