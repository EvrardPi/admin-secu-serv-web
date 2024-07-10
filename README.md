# Add Docker's official GPG key + config:
On the server:
    sudo apt-get install ca-certificates curl docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo groupadd docker
    sudo usermod -aG docker $USER

# Commands to remove the password when connecting to the server for ssh only
On your computer:
    ssh-keygen ...
On the server:
    sudo nano /home/pierre/.ssh/authorized_keys
        put your key 
    sudo nano /etc/ssh/sshd_config
        modify:
        Port -> 2703
        PermitRootLogin -> no
        PasswordAuthentication -> no

# Commands to generate certbot
On the server:
    sudo certbot certonly --standalone -d limhu.fr
    sudo certbot certonly --standalone -d front.limhu.scrypteur.com
    sudo certbot certonly --standalone -d back.limhu.scrypteur.com
    sudo certbot certonly --standalone -d admr.limhu.scrypteur.com

# Build my custom nginx img
On the server in the nginx folder:
    docker build -t custom-nginx .

# Test the samba service
On your computer:
    smbclient -U "DOMAIN\user" //<IP>/share

# Domain names
https://limhu.fr/
https://front.limhu.scrypteur.com/
https://back.limhu.scrypteur.com/
https://adminer.limhu.scrypteur.com/

# Docker hub images
evrardpi/limhu-frontend:1.0.0
evrardpi/limhu-backend:1.0.0

# Certbot auto-renewal
On the server:
    sudo crontab -e
        put:
            0 3 * * 1 /home/pierre/nginx/renew_certificates.sh
    to test it:
        /home/pierre/nginx/renew_certificates.sh
    and see logs:
        cat /home/pierre/certbot_renew.log

# Fail2ban
On the server:
    sudo apt-get install fail2ban

    sudo nano /etc/ssh/sshd_config
        put:
            # Logging
            SyslogFacility AUTH
            LogLevel VERBOSE

    sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
    sudo nano /etc/fail2ban/jail.local
        put:
            [sshd]
            enabled  = true
            port     = ssh
            backend = systemd
            maxretry = 3
            findtime = 10m
            bantime  = 10m

    sudo fail2ban-client -t
    sudo systemctl restart fail2ban
    sudo systemctl status fail2ban
    sudo fail2ban-client status
    sudo fail2ban-client status sshd
    sudo cat -n /var/log/fail2ban.log
    sudo journalctl -u fail2ban.service
    sudo fail2ban-client set [jailname] banip/unbanip [IP]


Pour Quentin Hermiteau:
Les credentials des services sont différents sur le serveur pour des raisons de sécurité étant donné que le dépôt est public.
Si nécessaire, elles peuvent t'être fournies, ainsi que l'IP du serveur.