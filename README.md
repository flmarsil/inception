# inception

The project consists in setting up a mini-infrastructure of different services following specific rules.

- The different services are :

  - A web server (Nginx) accessible via https.
  - A wordpress server + phpfpm
  - A mariadb server
  - An adminer server + phpfpm
  - A redis cache server

`Requirements to launch the project : Docker and docker-compose`

### Build and launch the project

1. Download / Clone the repo

```bash
git clone git@github.com:flmarsil/inception.git
```

2. Add `127.0.0.1 flmarsil.42.fr` in the `/etc/hosts` file of the host machine (see `.env` file to modify the environment variable)

3. `cd` to the root folder, and run `make install`. This will build all the images and launch the containers.
