{% set logstash = pillar.get('logstash', {}) -%}
{% set version = logstash.get('version', '1.4') -%}

logstash-pre-requirements:
  pkg.installed:
    - names:
      - base

get-logstash-key:
  cmd.run:
    - name: 'WGET=`which wget`; $WGET -qO - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -'

logstash_repo:
  file.managed:
    - name: /etc/apt/sources.list.d/logstash.list
    - contents: deb http://packages.elasticsearch.org/logstash/{{ version }}/debian stable main

logstash_install:
  pkg.installed:
    - name: logstash
    - require:
      - file: logstash_repo

reload-logstash:
  cmd.run:
    - name: 'SERVICE=`which service`; $SERVICE logstash restart'
