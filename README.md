# G-C-D-N

软路由（OpenWrt 等）上的 Cloudflare 优选 IP 自动化脚本：测速选出最快 IP，写入 Cloudflare 域名解析，并可通过 Telegram / PushPlus 推送结果。

## 来源声明

本项目基于甬哥（ygkkk）的 [rwkgyg/cdnopw](https://gitlab.com/rwkgyg/cdnopw) 整理而来。

- 原脚本 `cdnopw.sh`、`cdnac.sh` 经多层 base64 混淆，此处还原为明文，功能未改动。
- 唯一改动：脚本下载 `cdnip.sh`、`cdnac.sh` 的地址指向本仓库。
- 原作者的其他项目：github.com/yonggekkk 。如作者要求下架，将及时处理。

## 文件

| 文件 | 说明 |
|---|---|
| `cdnopw.sh` | 安装与配置菜单入口 |
| `cdnip.sh` | 核心：测速、更新解析、推送 |
| `cdnac.sh` | 反代 IP 库下载与地区识别 |

## 使用

在软路由 SSH 中以 root 运行：

```bash
cd /root && curl -sSL https://raw.githubusercontent.com/Allenvip1/G-C-D-N/main/cdnopw.sh -o cdnopw.sh && bash cdnopw.sh
```

按菜单提示配置，最后在路由器「计划任务」中添加 cron 定时执行 `/root/cfipopw/cdnip.sh`。

## 注意

- `cfst` 测速程序与 `ip.txt` / `ipv6.txt` 已改为从 [XIU2/CloudflareSpeedTest](https://github.com/XIU2/CloudflareSpeedTest/releases) 官方发布包（当前固定 v2.3.5）下载。需要路由器能访问 GitHub。升级版本时修改 `cdnopw.sh` 中 `cfstget` 函数的 `cfstver`。
- 反代 IP 模式仍使用原作者的 `cf.yg-kkk.gq` 与 `zip.baipiao.eu.org` 的 IP 库。
- 需要填写 Cloudflare 邮箱与 Global API Key，会明文保存在路由器 `/root/cfipopw/cdnip.sh` 中，请勿提交到仓库。
- 「多个 IP 解析到一个域名」模式会先删除该子域名下已有的 A/AAAA 记录，请先用测试域名验证。
