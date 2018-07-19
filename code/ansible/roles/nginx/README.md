##### Supported platforms:

- Ubuntu 16.04 LTS (Xenial)

### What problem does it solve and why is it useful?

Here's what you get with this role:

- Configure 1 or more sites-enabled (virtual hosts)
- Forced HTTPS with A+ certificate ratings (bearing your certificate authority)
- Self signed certs are generated to work out of the box for non-production environments
- First class support for Let's Encrypt SSL certificates for production environments
- Tune a bunch of `nginx.conf` settings for performance
- Allow you to optionally declare custom nginx and vhost directives easily

## Role variables

Below is a list of default values along with a description of what they do.

```yaml
---

nginx_install_service: True

# Which user/group should nginx belong to?
nginx_user: 'www-data'

# Various nginx config values set up to be efficient and secure
nginx_worker_processes: 'auto'
nginx_worker_rlimit_nofile: 4096
nginx_events_worker_connections: 1024
nginx_http_server_tokens: 'off'
nginx_http_add_headers:
  - 'X-Frame-Options SAMEORIGIN'
  - 'X-Content-Type-Options nosniff'
  - 'X-XSS-Protection "1; mode=block"'
nginx_http_server_names_hash_bucket_size: 64
nginx_http_server_names_hash_max_size: 512
nginx_http_sendfile: 'on'
nginx_http_tcp_nopush: 'on'
nginx_http_keepalive_timeout: 60
nginx_http_client_max_body_size: '1m'
nginx_http_types_hash_max_size: 2048
nginx_http_gzip: 'on'
nginx_http_gzip_types: 'text/plain text/css application/javascript application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript image/svg+xml image/svg'
nginx_http_gzip_disable: 'msie6'

nginx_http_directives: []

# How many bits should we use to generate a dhparam?
# Technically 2048 is 'good enough' but 4096 combined with a few other
# things will get you to a perfect 100 A+ SSL rating, do not go below 2048.
#
nginx_ssl_dhparam_bits: 2048

# Setting this comes in handy if you use Let's Encrypt and want to register a
# single certificate that has multiple domains attached to it.
nginx_ssl_override_filename: ''

# Should self signed certificates get generated? Some form of certificate needs
# to be available for this role to work, so it's enabled by default. You would
# set it to false once you have your real certificates in place.
nginx_ssl_generate_self_signed_certs: True



# If you're using Let's Encrypt, you can configure nginx to accept challenges to
# validate your domain(s). An HTTP based challenge is already set up for you.
#
# If you're using this role along with my LE role you don't need to touch this.
#
nginx_letsencrypt_root: '/usr/share/nginx/challenges'

# This is the value you'll set in your inventory to override any of the defaults
# from nginx_default_sites. A complete example is shown later on in this README.
nginx_sites: {}
```

## Example playbook

For the sake of this example let's assume you have a group called **app** and
you have a typical `site.yml` file.

To use this role edit your `site.yml` file to look something like this:

```yaml
---

- name: Configure app server(s)
  hosts: app
  become: True

  roles:
    - { role: nginx, tags: nginx }
```

Let's say you want to accomplish the following goals:

- Set up your main site to work on non-www and www
- Have all www requests get redirected to non-www
- Set up the main host as the default server
