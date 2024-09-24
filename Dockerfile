FROM php:8.1.29-fpm-bookworm

LABEL org.opencontainers.image.authors="Francois Bayart <francois@famipow.com>"

ARG APP_ID=1000
ARG COMPOSER_VERSION=2.7.7

# Create a non-root user
RUN groupadd -g "$APP_ID" app \
  && useradd -g "$APP_ID" -u "$APP_ID" -d /var/www -s /bin/bash app

# Create necessary directories and set permissions
RUN mkdir -p /etc/nginx/html /var/www/html /sock \
  && chown -R app:app /etc/nginx /var/www /usr/local/etc/php/conf.d /sock

# Install required packages
RUN apt-get update && apt-get install -y \
    cron \
    git \
    gnupg \
    gzip \
    libbz2-dev \
    libfreetype6-dev \
    libgmp-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libonig-dev \
    libpng-dev \
    libsodium-dev \
    libssh2-1-dev \
    libwebp-dev \
    libxslt1-dev \
    libzip-dev \
    lsof \
    nodejs \
    procps \
    strace \
    vim \
    zip \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

# Add MySQL APT repository and install MySQL 8 client
RUN curl -sS https://repo.mysql.com/RPM-GPG-KEY-mysql-2023 | gpg --dearmor | tee /usr/share/keyrings/mysql-archive-keyring.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/mysql-archive-keyring.gpg] https://repo.mysql.com/apt/debian/ bookworm mysql-8.0" | tee /etc/apt/sources.list.d/mysql.list && \
    apt-get update && apt-get install -y mysql-client

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions via PECL
RUN pecl channel-update pecl.php.net && pecl install \
    imagick-3.7.0 \
    redis-6.0.2 \
    ssh2-1.3.1 \
    swoole-5.1.1 \
    xdebug-3.2.2 \
    mcrypt \
  && pecl clear-cache \
  && rm -rf /tmp/pear

# Configure and install PHP extensions
RUN docker-php-ext-configure \
    gd --with-freetype --with-jpeg --with-webp \
  && docker-php-ext-install \
    bcmath \
    bz2 \
    calendar \
    exif \
    gd \
    gettext \
    gmp \
    intl \
    mbstring \
    mysqli \
    opcache \
    pcntl \
    pdo \
    pdo_mysql \
    soap \
    sockets \
    sodium \
    sysvmsg \
    sysvsem \
    sysvshm \
    xsl \
    zip \
  && docker-php-ext-enable \
    imagick \
    redis \
    ssh2 \
    gmp \
    mcrypt \
    xdebug

# Install Composer
RUN curl -sS https://getcomposer.org/installer | \
  php -- --version=$COMPOSER_VERSION --install-dir=/usr/local/bin --filename=composer

# Install Datadog PHP tracer
RUN curl -L https://github.com/DataDog/dd-trace-php/releases/latest/download/datadog-setup.php -o /tmp/datadog-setup.php
RUN php /tmp/datadog-setup.php --php-bin=all --enable-appsec --enable-profiling

# Copy custom PHP configuration
COPY files/php.ini $PHP_INI_DIR
  
WORKDIR /var/www/html

USER app
