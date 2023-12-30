# Linux Notes

## Ubuntu System

### 1. Allow Locked Remote Desktop

Download GNOME Shell Extension Manager:

```shell
sudo apt install gnome-shell-extension-manager
```

Open the newly installed app called **Extension Manager** in the GUI, search for and install the [Allow locked Remote Desktop](https://extensions.gnome.org/extension/4338/allow-locked-remote-desktop) GNOME Shell extension.

### 2. Enable SSH Password Authentication

Change hostname and password command:

```shell
sudo chmod 666 /etc/hostname && \
read -p "Enter the new hostname: " hostname && \
sudo echo $hostname >| /etc/hostname && \
read -p "Enter the username you want to change password: " username && \
sudo passwd $username && \
sudo reboot
```

Edit `sshd_config` file:

```shell
sudo vim /etc/ssh/sshd_config
```

Find the line containing `PasswordAuthentication` parameter and change its value to `yes`.

Restart SSH service:

```
sudo service ssh restart
```

### 3. Enable `sudo` Without A Password

Edit `/etc/sudoers` file:

```shell
sudo vim /etc/sudoers
```

Change below lines to look like this:

```shell
%admin  ALL=(ALL) NOPASSWD:ALL
%sudo   ALL=(ALL:ALL) NOPASSWD:ALL
```

### 4. Local Services On Ubuntu NUC

|        **Name**         | **Protocol** |                            **IP Address**                            | **Remote Port** |              **Local Port**               |
| :---------------------: | :----------: | :------------------------------------------------------------------: | :-------------: | :---------------------------------------: |
|  Remote Desktop (RDP)   |     TCP      |                          hk.ubuntu-svr.com                           |      3390       |                   3389                    |
|       Remote SSH        |     TCP      |                          hk.ubuntu-svr.com                           |       23        |                    22                     |
| Remote SSH (MacBookPro) |     TCP      |                          hk.ubuntu-svr.com                           |       24        |                    22                     |
|          Alist          |     HTTP     |     [alist-nuc.ubuntu-svr.com](https://alist-nuc.ubuntu-svr.com)     |       N/A       |   [5244](https://alist.ubuntu-nuc.com/)   |
|          Dash.          |     HTTP     |      [dash-nuc.ubuntu-svr.com](https://dash-nuc.ubuntu-svr.com)      |       N/A       |   [3001](https://dash.ubuntu-nuc.com/)    |
|         DDNS-GO         |     HTTP     |   [ddns-go-nuc.ubuntu-svr.com](https://ddns-go-nuc.ubuntu-svr.com)   |       N/A       |  [9876](https://ddns-go.ubuntu-nuc.com/)  |
|         Homarr          |     HTTP     |    [homarr-nuc.ubuntu-svr.com](https://homarr-nuc.ubuntu-svr.com)    |       N/A       |  [7575](https://homarr.ubuntu-nuc.com/)   |
|        IT Tools         |     HTTP     |  [it-tools-nuc.ubuntu-svr.com](https://it-tools-nuc.ubuntu-svr.com)  |       N/A       | [9090](https://it-tools.ubuntu-nuc.com/)  |
|    Plex Media Server    |     HTTP     |      [plex-nuc.ubuntu-svr.com](https://plex-nuc.ubuntu-svr.com)      |       N/A       |   [32400](https://plex.ubuntu-nuc.com/)   |
|  Jellyfin Media Server  |     HTTP     |  [jellyfin-nuc.ubuntu-svr.com](https://jellyfin-nuc.ubuntu-svr.com)  |       N/A       | [8096](https://jellyfin.ubuntu-nuc.com/)  |
|   Portainer Dashboard   |     HTTP     | [portainer-nuc.ubuntu-svr.com](https://portainer-nuc.ubuntu-svr.com) |       N/A       | [9000](https://portainer.ubuntu-nuc.com/) |

## Docker And Portainer CE

### 1. Uninstall All Conflicting Packages

```shell
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
```

### 2. Set Up Docker's `apt` Repository

```shell
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

### 3. Install the Docker Packages

```shell
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 4. Install Portainer CE with Docker on Linux

First, create the volume that Portainer Server will use to store its database:

```shell
docker volume create portainer_data
```

Then, download and install the Portainer Server container:

```shell
docker run -d -p 8000:8000 -p 9000:9000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
```

## Tailscale

### 1. One Line Command Download (Linux)

```shell
curl -fsSL https://tailscale.com/install.sh | sh
```

**Remember to open port `41641`.**

### 2. Tailnet name

```
collie-roach.ts.net
```

### 3. Provide Non-root Users With Access To Fetch Certificate (Caddy)

If Caddy is running as a non-root user, such as when it runs on Ubuntu as `caddy`, we need to modify `/etc/default/tailscaled` to grant the user access to fetch the certificate. In `/etc/default/tailscaled`, set the `TS_PERMIT_CERT_UID` environment variable to the name or ID of the non-root user:

```
TS_PERMIT_CERT_UID=caddy
```

For more information about Caddy, see [Get started with Caddy](https://caddyserver.com/docs/getting-started).\
If Caddy is installed as a container in Docker, we need to add this line under the `volumns` section of docker-compose.yml:

```docker
volumes:
    - /run/tailscale/tailscaled.sock:/run/tailscale/tailscaled.sock
```

Read more about this [here](https://forum.tailscale.com/t/auto-caddy-certificates-with-docker/3816/5).

### 4. Exit Nodes (Route All Traffic)

Refer to the document [here](https://tailscale.com/kb/1103/exit-nodes).\
Disable it by running:

```shell
sudo tailscale up --advertise-exit-node=false
```

## Caddy

### 1. Installation Command

```shell
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy
sudo apt install xcaddy
```

### 2. Build Caddy With DNS Provider Plugin

- [How to use DNS provider modules in Caddy 2](https://caddy.community/t/how-to-use-dns-provider-modules-in-caddy-2/8148)
  - `xcaddy build --with github.com/caddy-dns/cloudflare`
- [使用 Docker 部屬帶有 Cloudflare Plugin 的 Caddy v2](https://blog.ujoj.cc/post/caddy-cloudflare/)
- [HTTPS for Homelab using Caddy and ACME DNS](https://vakarthik.com/posts/2021/compiling-and-building-caddy/#https-for-homelab)
- API Token can be found [here](https://dash.cloudflare.com/profile/api-tokens).
- May need the command `sudo mv /path/to/caddy /usr/bin/caddy`

### 3. Default Config Location:

```
/etc/caddy/Caddyfile
```

## Setup Squid Proxy With Authentication

### 1. Install Required Tools

```shell
sudo apt update
sudo apt install squid
sudo apt install apache2-utils
```

### 2. Setup The Password

```shell
sudo touch /etc/squid/passwords
sudo chmod 777 /etc/squid/passwords
sudo htpasswd -c /etc/squid/passwords [USERNAME]
```

### 3. [Optional] Test The Password Config

```shell
/usr/lib/squid/basic_ncsa_auth /etc/squid/passwords
```

### 4. Config Squid Proxy

```shell
sudo mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
sudo vim /etc/squid/squid.conf
```

Search for `http_access deny all`, replace it with `http_access allow all`.\
Enter the following lines in the config file:

```
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwords
auth_param basic realm Squid proxy-caching web server
auth_param basic credentialsttl 24 hours
auth_param basic casesensitive off
acl authenticated proxy_auth REQUIRED
http_access allow authenticated
http_access deny all
```

Restart the squid service: `sudo service squid restart`.

## Forward TCP / UDP Port With Nginx

### 1. Basic Config Template

Default config location: `/etc/nginx/nginx.conf`

```nginx
user root root;
worker_processes auto;
pid /run/nginx.pid;
load_module /usr/lib/nginx/modules/ngx_stream_module.so;

events {
    worker_connections 1024;
    multi_accept on;
}

stream {
    server {
        listen 3390;
        proxy_pass ubuntu-nuc:3389;
    }
    server {
        listen 23;
        proxy_pass ubuntu-nuc:22;
    }
    server {
        listen 24;
        proxy_pass macbookpro:22;
    }
}
```

Add the following lines by executing `sudo systemctl edit nginx`:

```
[Service]
Restart=on-failure
RestartSec=5s
```

## RCLONE Mount

### 1. One Line Command Download (Linux)

```shell
sudo -v ; curl https://rclone.org/install.sh | sudo bash
```

### 2. `--allow-other` Settings

Allow access to other users (not supported on Windows). Need to modify `/etc/fuse.conf` (by uncommenting `user_allow_other`)

## SMB Server Settings

### 1. Installing Samba

To install Samba, we run:

```shell
sudo apt update
sudo apt install samba
```

### 2. Setting up Samba

The configuration file for Samba is located at `/etc/samba/smb.conf`. To add the new directory as a share, we edit the file by running:

```shell
sudo vim /etc/samba/smb.conf
```

At the bottom of the file, add the following lines:

```
[Shared Folder]
   comment = Comments on the shared folder
   path = /path/to/shared/folder
   browseable = yes
   writable = yes
   guest ok = yes
   read only = no
   public = no
   create mask = 0777
   directory mask = 0777
```

Now that we have our new share configured, save it and restart Samba for it to take effect:

```shell
sudo systemctl restart samba
```

### 3. Setting up User Accounts

Since Samba doesn’t use the system account password, we need to set up a Samba password for our user account:

```shell
sudo smbpasswd -a username
```

## Jellyfin Media Server (Docker)

### 1. 封面方块乱码解决方法

在 Docker 中打开 bash ，并执行以下代码：

```shell
sudo apt update
sudo apt install fonts-noto-cjk-extra
```

重启 Jellyfin container ，删除原封面图片并重新扫描所有媒体库

### 2. 字母方块乱码解决方法

在 Jellyfin 的挂载目录 `/config` 中，新建一个文件夹 `/fonts`。\
下载[中文](https://fonts.google.com/noto/specimen/Noto+Sans+SC)和[日文](https://fonts.google.com/noto/specimen/Noto+Sans+JP)字体，将其复制到 `/fonts` 文件夹里。\
最后在 `控制台-播放` 中设置 **_备用字体文件路径_** 并 **_启用备用字体_** 。
