Ensure apache2 packages are installed:
  pkg.installed:
    - names:
        - apache2

Ensure php packages are installed:
  pkg.installed:
    - names:
        - libapache2-mod-php7.0
        - php7.0
        - php7.0-common
        - php7.0-cli
        - php7.0-curl
        - php7.0-mysql
        - php7.0-gmp
        - php7.0-tidy
        - php7.0-mbstring
        - php7.0-gd
        - php7.0-intl
        - php7.0-mcrypt
        - php7.0-xsl
        - php7.0-sqlite3
        - php-openid
        - php-apcu
        - php-memcached

Ensure ports is configured:
  file.managed:
    - name: /etc/apache2/ports.conf
    - source: salt://blog/apache/ports.conf
    - listen_in:
        - service: apache2

Ensure default site is absent:
  file.absent:
    - name: /etc/apache2/sites-enabled/000-default.conf
    - listen_in:
        - service: apache2

{% for mod in ['rewrite', 'expires', 'mpm_prefork'] %}
Ensure {{ mod }} module is enabled:
  apache_module.enabled:
    - name: {{ mod }}
    - listen_in:
        - service: apache2
{% endfor %}

Ensure mpm_event module is disabled:
  apache_module.disabled:
    - name: mpm_event
    - listen_in:
        - service: apache2

{% for site in ['ryandlane', 'alexborges'] %}
Ensure {{ site }} site is available:
  file.managed:
    - name: /etc/apache2/sites-available/{{ site }}.conf
    - source: salt://blog/apache/{{ site }}.conf
    - listen_in:
        - service: apache2

Ensure {{ site }} site is enabled:
  apache_site.enabled:
    - name: {{ site }}
    - listen_in:
        - service: apache2
{% endfor %}

Ensure apache2 is running:
  service.running:
    - name: apache2
    - enable: true
