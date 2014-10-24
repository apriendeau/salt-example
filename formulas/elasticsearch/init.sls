{% set elasticsearch = pillar.get('elasticsearch', {}) -%}
{% set version = elasticsearch.get('version', '1.3') -%}
pre-requirements:
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


elasticsearch_soft:
  pkg.installed:
    - name: elasticsearch
    - require:
      - file: elasticsearch_repo

# update-apt:
#   module.run:
#     - name: pkg.refresh_db
#
# install_elasticsearch:
#   module.run:
#     - name: pkg.install
#     - opts: ["elasticsearch"]
