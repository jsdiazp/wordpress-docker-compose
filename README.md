# WordPress Docker Compose

Simplify your WordPress development using Docker and Docker Compose.

With this repository, you can benefit from the features of the following tools to enhance your WordPress site’s performance and security:

- [MariaDB](https://hub.docker.com/_/mariadb/)
- [Nginx](https://hub.docker.com/_/nginx/) with [Certbot](https://certbot.eff.org/)
- [PHP-FPM](https://www.php.net/manual/en/install.fpm.php)
- [Redis](https://hub.docker.com/_/redis/)

Content:

- [Requirements](#requirements)
- [Pre-installation](#pre-installation)
- [Installation](#installation)
- [Post-installation](#post-installation)
  - [Request SSL certificate](#request-ssl-certificate)
  - [Enable Wordfence](#enable-wordfence)
  - [Enter MYSQL CLI](#enter-mysql-cli)

## Requirements

1. Make sure you have the latest version of Docker Engine; to do so, you can follow the instructions in the link below:

[Install Docker Engine](https://docs.docker.com/engine/install/)

2. Check that ports `80` and `443` are exposed and available for use.

## Pre-installation

Clone this GitHub repository to your local machine:
```shell
git clone https://github.com/jsdiazp/wordpress-docker-compose.git
```

Navigate to the repository folder:
```shell
cd wordpress-docker-compose
```

Edit `wordpress-*.conf` file from the `nginx/conf.d` folder replacing the `server_name` attribute with your website domain and aliases.

## Installation

Run the docker compose command to start the containers:
```shell
docker compose up -d
```

## Post-installation

### Request SSL certificate

To enable HTTPS and get an SSL certificate for your site, run the following command and follow the instructions displayed:
 ```shell
docker compose exec nginx -ti certbot
```

**Note:** Make sure that the `DNS A record` for the domain and subdomains specified in the nginx `server_name` attribute point to the `public IP` of the server on which you have installed this container orchestration.

### Enable Wordfence

Install the [Wordfence Security](https://wordpress.org/plugins/wordfence/) plugin on your WordPress site.

Enable the Wordfence firewall by uncommenting the following line in the `wordpress-*.ini` file from the `wordpress/php` folder. 
```nginx
# auto_prepend_file = '/var/www/html/wordfence-waf.php'
```

### Enter MYSQL CLI

```shell
docker compose exec db -ti mysql -u root -p aE&6^igLThHc
```