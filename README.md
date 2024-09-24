# PHP 8.1 FPM Docker Image

This Docker image is based on PHP 8.1.29 FPM with Debian Bookworm, tailored for web application development and deployment.

## Features

- PHP 8.1.29 with FPM
- Debian Bookworm base
- Non-root user setup (UID 1000)
- MySQL 8 client
- Node.js
- Composer 2.7.7
- Various PHP extensions and tools

### Included PHP Extensions

- bcmath
- bz2
- calendar
- exif
- gd (with freetype, jpeg, and webp support)
- gettext
- gmp
- intl
- mbstring
- mysqli
- opcache
- pcntl
- pdo
- pdo_mysql
- soap
- sockets
- sodium
- sysvmsg, sysvsem, sysvshm
- xsl
- zip
- imagick
- redis
- ssh2
- swoole
- xdebug
- mcrypt

### Additional Tools

- Git
- Cron
- Vim
- Datadog PHP tracer (with AppSec and profiling enabled)

## Usage

To use this image, pull it from your Docker registry and run it with your PHP application:

```bash
docker pull ghcr.io/frbayart/docker-php8.1-fpm:8.1.29
docker run -v /path/to/your/app:/var/www/html -p 9000:9000 ghcr.io/frbayart/docker-php8.1-fpm:8.1.29
```

## Customization

The image includes a custom `php.ini` file located at `$PHP_INI_DIR`. You can modify this file to adjust PHP settings as needed.

## Development

To build this image locally:

```bash
docker build -t php:8.1.29-fpm-bookworm .
```

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

## Author

Francois Bayart <francois@famipow.com>

## Contributing

Open an issue or a PR with short description.

## Support

This project is not maintained by a company, so there is no support. You are on your self-support.
