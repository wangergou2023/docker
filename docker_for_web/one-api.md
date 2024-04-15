## 指令

~~~sh
docker run --name one-api -d --restart always --network="host" -e THEME=berry -e SQL_DSN="root:123456@tcp(localhost:3306)/oneapi" -e TZ=Asia/Shanghai -v /home/ubuntu/data/one-api:/data justsong/one-api
~~~

这个命令是用于通过Docker运行名为`one-api`的容器的。它详细地配置了容器的运行方式，包括：

- `--name one-api`：设置容器的名称为`one-api`。
- `-d`：以后台模式运行容器。
- `--restart always`：设置容器始终重启，确保容器在退出时或Docker重启时自动重启。
- `-p 3000:3000`：将容器的3000端口映射到宿主机的3000端口。
- `-e THEME=berry`：设置环境变量`THEME`为`berry`。
- `-e SQL_DSN="root:123456@tcp(localhost:3306)/oneapi"`：设置环境变量`SQL_DSN`，即数据库连接字符串，用于连接MySQL数据库。
- `-e TZ=Asia/Shanghai`：设置环境变量`TZ`，指定时区为`Asia/Shanghai`。
- `-v /home/ubuntu/data/one-api:/data`：将宿主机的`/home/ubuntu/data/one-api`目录挂载到容器的`/data`目录，用于数据持久化。
- `justsong/one-api`：指定要运行的Docker镜像名称。
- 如果你的应用运行在Docker容器中并需要访问宿主机上的MySQL数据库，你可以在部署命令中添加`--network="host"`选项。这样做可以让容器使用宿主机的网络堆栈，从而使得容器内的应用能够通过`localhost`或`127.0.0.1`访问宿主机上运行的服务，包括MySQL数据库。这是在Docker容器需要与宿主机上的服务进行通信时的一个常用解决方案。

这个命令通过以上参数配置，实现了`one-api`服务的部署，包括端口映射、环境变量设置和数据持久化等。





~~~sh
root@srv488172:~/temp# snap install --classic certbot
certbot 2.9.0 from Certbot Project (certbot-eff✓) installed
root@srv488172:~/temp# ls
install.sh
root@srv488172:~/temp# ls /snap/bin/certbot
/snap/bin/certbot
root@srv488172:~/temp# ln -s /snap/bin/certbot /usr/bin/certbot
root@srv488172:~/temp# certbot --nginx
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Error while running nginx -c /etc/nginx/nginx.conf -t.

nginx: [emerg] open() "/etc/nginx/nginx.conf" failed (2: No such file or directory)
nginx: configuration file /etc/nginx/nginx.conf test failed

The nginx plugin is not working; there may be problems with your existing configuration.
The error was: MisconfigurationError('Error while running nginx -c /etc/nginx/nginx.conf -t.\n\nnginx: [emerg] open() "/etc/nginx/nginx.conf" failed (2: No such file or directory)\nnginx: configuration file /etc/nginx/nginx.conf test failed\n')
root@srv488172:~/temp# find / -name nginx.conf
/snap/certbot/3643/lib/python3.8/site-packages/certbot_nginx/_internal/tests/testdata/etc_nginx/nginx.conf
/snap/certbot/3643/lib/python3.8/site-packages/certbot_nginx/_internal/tests/testdata/etc_nginx/ubuntu_nginx_1_4_6/default_vhost/nginx/nginx.conf
/www/backup/file_history/www/server/nginx/conf/nginx.conf
/www/server/nginx/src/conf/nginx.conf
/www/server/nginx/conf/nginx.conf
root@srv488172:~/temp# certbot --nginx --nginx-server-root /www/server/nginx/conf/
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Enter email address (used for urgent renewal and security notices)
 (Enter 'c' to cancel): wangergou_2023@qq.com

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please read the Terms of Service at
https://letsencrypt.org/documents/LE-SA-v1.3-September-21-2022.pdf. You must
agree in order to register with the ACME server. Do you agree?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: yes

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Would you be willing, once your first certificate is successfully issued, to
share your email address with the Electronic Frontier Foundation, a founding
partner of the Let's Encrypt project and the non-profit organization that
develops Certbot? We'd like to send you email about our work encrypting the web,
EFF news, campaigns, and ways to support digital freedom.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: yes
Account registered.

Which names would you like to activate HTTPS for?
We recommend selecting either all domains, or all domains in a VirtualHost/server block.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
1: llxspace.website
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Select the appropriate numbers separated by commas and/or spaces, or leave input
blank to select all options shown (Enter 'c' to cancel): 1
Requesting a certificate for llxspace.website

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/llxspace.website/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/llxspace.website/privkey.pem
This certificate expires on 2024-06-03.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.

Deploying certificate
Successfully deployed certificate for llxspace.website to /www/server/panel/vhost/nginx/llxspace.website.conf
Congratulations! You have successfully enabled HTTPS on https://llxspace.website

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
root@srv488172:~/temp# 

~~~

