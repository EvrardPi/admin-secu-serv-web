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
sudo certbot renew --dry-run
sudo crontab -e
30 2 * * * /usr/bin/certbot renew --quiet --renew-hook "systemctl reload nginx"
sudo crontab -l
sudo /usr/bin/certbot renew --dry-run

Pour Quentin Hermiteau:
Les credentials des services sont différents sur le serveur pour des raisons de sécurité étant donné que le dépôt est public.
Si nécessaire, elles peuvent t'être fournies, ainsi que l'IP du serveur.