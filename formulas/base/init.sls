base-pre-requirements:
  pkg.installed:
    - names:
      - build-essential
      - wget
      - curl
      - vim
      - java

update-apt:
  module.run:
    - name: pkg.refresh_db
    - user: root
