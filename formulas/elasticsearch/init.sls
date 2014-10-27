{% set elasticsearch = pillar.get('elasticsearch', {}) -%}
{% set version = elasticsearch.get('version', '1.3') -%}
{% set conf_dir = elasticsearch.get('conf_dir', '/etc/elasticsearch') -%}
{% set conf_template = elasticsearch.get('conf_template', 'salt://elasticsearch/templates/elasticsearch.jinja') -%}

elasticsearch-pre-requirements:
  pkg.installed:
    - names:
      - base

get-elasticsearch-key:
  cmd.run:
    - name: 'WGET=`which wget`; $WGET -qO - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -'

elasticsearch_repo:
    file.managed:
    - name: /etc/apt/sources.list.d/elasticsearch.list
    - contents: deb http://packages.elasticsearch.org/elasticsearch/{{ version }}/debian stable main


elasticsearch_install:
  pkg.installed:
    - name: elasticsearch
    - require:
      - file: elasticsearch_repo

{{ conf_dir }}/elasticsearch.yml:
  file:
    - managed
    - template: jinja
    - user: root
    - mode: 0644
    - source: {{ conf_template }}

set-heapsize:
  file:
    - sed
    - name: /etc/default/elasticsearch
    - before: '#ES_HEAP_SIZE=2g'
    - after: ES_HEAP_SIZE={{ (grains['mem_total']/2)|round|int }}m
    - require:
      - pkg: elasticsearch

set-data-directory:
  file:
    - sed
    - name: /etc/default/elasticsearch
    - before: '#DATA_DIR=/var/lib/elasticsearch'
    - after: DATA_DIR=/var/lib/elasticsearch
    - require:
      - pkg: elasticsearch

reload-elasticsearch:
  cmd.run:
    - name: 'SERVICE=`which service`; $SERVICE elasticsearch restart'
