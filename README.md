# WordPress Docker Compose

Simplify your WordPress development using Docker and Docker Compose.

With this repository, you can benefit from the features of the following tools to enhance your WordPress site’s performance and security:

- [Nginx](https://hub.docker.com/_/nginx/) with [Certbot](https://certbot.eff.org/)
- [Redis](https://hub.docker.com/_/redis/)
- [MariaDB](https://hub.docker.com/_/mariadb/)

Content:

- [Requirements](#requirements)
- [Pre-installation](#pre-installation)
- [Installation](#installation)
- [Post-installation](#post-installation)
  - [Request SSL certificate](#request-ssl-certificate)
  - [Enable Wordfence](#enable-wordfence)

## Requirements

Make sure you have the latest versions of Docker and Docker Compose; to do so, you can follow the instructions in the links below:

- [Install Docker](https://docs.docker.com/get-docker/)
- [Install Docker Compose](https://docs.docker.com/compose/install/)



## Pre-installation

Clone this GitHub repository to your local machine:
```
git pull https://github.com/jsdiazp/wordpress-docker-compose.git
```

Navigate to the repository folder:
```
cd wordpress-docker-compose
```

Edit `wordpress-*.conf` file and replace the `server_name` attribute with your website domain and aliases.

## Installation
Run the docker compose command to star the containers:
```
docker compose up -d
```

## Post-installation

### Request SSL certificate

 To enable HTTPS and get an SSL certificate for your site, run the following command and follow the instructions:
 ```
docker compose exec nginx -ti certbot
```

### Enable Wordfence

Install the [Wordfence Security](https://wordpress.org/plugins/wordfence/) plugin on your WordPress site.

Enable the Wordfence firewall by uncommenting the following line in the `wordpress-*.ini` file from the `/wordpress/php` folder. 
```
# auto_prepend_file = '/var/www/html/wordfence-waf.php'
```
