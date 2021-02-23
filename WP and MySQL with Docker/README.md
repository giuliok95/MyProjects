# One for All!

## Story

With your friends you're starting a *blog*! Wow, fancy!

You have read the docs and it seems you'll need a MySQL database and
at least one installation of WordPress where you can log in and start
writing shiny new posts.

You decide that each member should run its own WordPress node and
connect that to a single MySQL database server.

Since everyone in the team is an avid Docker fan and automation maniac
the whole thing needs to be *Dockerized* and automated as much as
possible. Easy, right?

## What are you going to learn?

- How to run WordPress with Docker
- How to run MySQL with Docker
- How to connect MySQL and WordPress via `docker-compose`
- How to use `wp-cli` with Docker to automate WordPress installations
- Learn how to use `.env` (*dotenv*) with `docker-compose`
- How to use `docker run` to run one-off containers
- Using `--volumes-from` and `--network container:` with `docker run`

## Tasks

1. Update `docker-compose.yml` and define a MySQL database service.
    - The service is called `db`
    - The service is based on the image official `mysql:5.7` image
    - The database server's ports are not exposed to the host
    - The following environment variables are set for the service:

```sh
MYSQL_ROOT_PASSWORD: ...
MYSQL_DATABASE: ...
MYSQL_USER: ...
MYSQL_PASSWORD: ...
```
    - A named volume called `db_data` is attached to the service at `/var/lib/mysql` (where MySQL stores database related files)

2. Define a WordPress node in `docker-compose.yml` for each team member (except the one responsible for the MySQL database) and configure them so that they connect to the MySQL service.
    - Each node is called as `wp1`, `wp2`, etc.
    - Each node is based on the official `wordpress:5.6` image
    - Each node is automatically restarted if it fails to start for some reason
    - Each node's port is exposed and can be accessed externally (from the Docker host and/or the VM host if running in virtualization)
    - The following environment variables are set (to allow WordPress nodes to connect to MySQL):

```sh
WORDPRESS_DB_HOST
WORDPRESS_DB_USER
WORDPRESS_DB_PASSWORD
WORDPRESS_DB_NAME
```
    - The `WORDPRESS_CONFIG_EXTRA` environment variable is set and contains WordPress configuration for the `WP_HOME` and `WP_SITEURL` settings using the following format:

```php
WORDPRESS_CONFIG_EXTRA: |-
  define('WP_HOME', '<URL>');
  define('WP_SITEURL', '<URL>');
```

`<URL>` should be replaced with something like `http://localhost:30080` or similar (the URL you'll use to access the site).<br>
`WP_HOME` and `WP_SITEURL` should be set to the same URL.<br>
**Watch out**, the `|-` thingy needs to be there for _YAML-reasons_ and whatever goes _under_ the `WORDPRESS_CONFIG_EXTRA` YAML node must be valid `PHP` code.
    - Each node has a named volume called `wp1_data`, `wp2_data`, etc. attached to it at `/var/www/html` (where MySQL stores its files)

3. Once you have the WordPress nodes up and running you must still finish installing WordPress itself.
It doesn't matter how many nodes you have, you'll need to install WordPress once (installation does some _voodoo_ in the MySQL database WordPress is connected to, hence this needs to be done one time only).
Installation can be finished via visiting the site in a browser, but you can do better. _Automate it!_
    - The `install.sh` script contains a single `docker run` command (with a heap of flags) which installs WordPress
    - The `wordpress:cli-2.4` image is used in `install.sh`
    - The `--volumes-from <container>` flag is used with `docker run` in `install.sh` to specify that the container to be created should use the same volumes as the referenced container (use `docker ps` to check the ID/name of an existing WordPress container)
    - The `--network container:<container>` flag is used with `docker run` in `install.sh` to specify that the container to be created should use the same volumes as the referenced container
    - The `wp core install` command is supplied to the `wordpress:cli-2.4` container to install a WordPress site with the following flags set

```sh
wp core install \
  --url=<URL> \
  --title=<title> \
  --admin_user=<user> \
  --admin_password=<password> \
  --admin_email=<email> \
  --skip-email
```

`<URL>` should be replaced with the URL of the WordPress node that's running inside the connected container.
Every other value in angled brackets (`<`, `>`) should be replaced with actual values.<br>
The `\` (backslashes) are used to write a multiline command in shell scripts.

4. Nothing remains left except writing a blog post. Remember, you can connect to a WordPress site to write a post via a link similar to this: <http://localhost:10080/wp-login.php> (instead of _localhost_ and _10080_ you might need to use something else depending on the exact setup at hand).
    - `docker compose up -d` is executed and the MySQL and all WordPress nodes are running
    - Visiting the URL of any WordPress site loads the exact same site
    - Wrote a blog post by connecting to one of the WordPress site's admin page (`../wp-login.php`), the blog post is published and visible on all sites

## General requirements

None

## Hints

- **Use official Docker images, there's no need to create your own `Dockerfile`s**
- MySQL's default port is 3306, WordPress use port 80
- Use `docker-compose up -d` to run services defined in `docker-compose.yml` in the background
- Run `docker-compose down -v` to bring down all running services and also destroyed named volumes defined in the `docker-compose.yml` file
- Specify the [`restart` policy](https://docs.docker.com/compose/compose-file/compose-file-v3/#restart) if a node's startup process depends on another node's state (e.g. WordPress can only successfully start if it can connect to MySQL)
- The `.env` (or *dotenv* as such files are usually referred to as) is read automatically by `docker-compose up`, check out the background materials about `.env` and `docker-compose` to see an example how to leverage this (e.g. you can set a common database username/password in `.env` and reuse that in `docker-compose.yaml`)
- The `wordpress:cli-2.4` image can be used run the WordPress CLI tool (called `wp`) against a WordPress installation, since your WordPress nodes are running in Docker containers and their data is stored in named volumes (e.g. `wp1_data`) you can start a `wordpress:cli-2.4` container with the `--volumes-from <wp1-container>` so that it could operate on this data (see an [example at the end of the official WordPress Docker image's page](https://hub.docker.com/_/wordpress))

## Background materials

- [Introduction to `docker-compose`](project/curriculum/materials/tutorials/introduction-to-docker-compose.md)
- [Official MySQL Docker image](https://hub.docker.com/_/mysql)
- [Official WordPress Docker image](https://hub.docker.com/_/wordpress)
- [`docker-compose.yml` reference](https://docs.docker.com/compose/compose-file/compose-file-v3/)
- [`docker-compose` restarting nodes](https://docs.docker.com/compose/compose-file/compose-file-v3/#restart)
- [`.env` in `docker-compose`](https://docs.docker.com/compose/environment-variables/#substitute-environment-variables-in-compose-files)
- [Environment variables in `docker-compose.yml`](https://docs.docker.com/compose/environment-variables/)
- [Links between services in `docker-compose.yml`](https://docs.docker.com/compose/compose-file/compose-file-v3/#links)
