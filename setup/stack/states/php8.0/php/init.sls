apt_https:
  pkg.installed:
    - name: software-properties-common

php_repo_list:
  cmd.run:
    - name: echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
    - unless: test -f /etc/apt/sources.list.d/php.list

php_repo_key:
  cmd.run:
    - name: wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
    - unless: test -f /etc/apt/trusted.gpg.d/php.gpg

php8.0:
  pkg.installed:
    - refresh: True
    - pkgs:
      - libapache2-mod-php8.0
      - php-json
      - php8.0-apcu
      - php8.0-bcmath
      - php8.0-cli
      - php8.0-curl
      - php8.0-gd
      - php8.0-imap
      - php8.0-mbstring
      - php8.0-mysql
      - php8.0-opcache
      - php8.0-readline
      - php8.0-soap
      - php8.0-xml
      - php8.0-xmlrpc
      - php8.0-xsl
      - php8.0-zip

{% for version in ['7.0','7.1','7.2','7.3','7.4','8.1','8.2'] %}
php{{ version }}:
  pkg.purged:
    - refresh: True
    - pkgs:
          - libapache2-mod-php{{ version }}
          - php{{ version }}-apcu
          - php{{ version }}-bcmath
          - php{{ version }}-cli
          - php{{ version }}-common
          - php{{ version }}-curl
          - php{{ version }}-gd
          - php{{ version }}-imap
          - php{{ version }}-json
          - php{{ version }}-mbstring
          - php{{ version }}-mysql
          - php{{ version }}-opcache
          - php{{ version }}-readline
          - php{{ version }}-soap
          - php{{ version }}-xml
          - php{{ version }}-xmlrpc
          - php{{ version }}-xsl
          - php{{ version }}-zip
          - php{{ version }}-imagick
{% endfor %}

ini_filesize_apache2:
  cmd.run:
    - name: sed -i "/upload_max_filesize*/c upload_max_filesize = 4096M" /etc/php/8.0/apache2/php.ini

ini_filesize_cli:
  cmd.run:
    - name: sed -i "/upload_max_filesize*/c upload_max_filesize = 4096M" /etc/php/8.0/cli/php.ini

ini_postmax_apache2:
  cmd.run:
    - name: sed -i "/post_max_size*/c post_max_size = 4096M" /etc/php/8.0/apache2/php.ini

ini_postmax_cli:
  cmd.run:
    - name: sed -i "/post_max_size*/c post_max_size = 4096M" /etc/php/8.0/cli/php.ini

ini_max_execution_time_apache2:
  cmd.run:
    - name: sed -i "/max_execution_time*/c max_execution_time = 3600" /etc/php/8.0/apache2/php.ini

ini_max_execution_time_cli:
  cmd.run:
    - name: sed -i "/max_execution_time*/c max_execution_time = 3600" /etc/php/8.0/cli/php.ini

a2_enable_php:
  module.run:
    - name: apache.a2enmod
    - mod: php8.0

update_alternatives_php:
  cmd.run:
    - name: update-alternatives --set php /usr/bin/php8.0 &>/dev/null

apache2_supervisor_signal:
  cmd.run:
    - name: supervisorctl restart apache2
