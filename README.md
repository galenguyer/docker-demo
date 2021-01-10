# docker-demo
A demo Flask+Redis app to demonstrate writing Dockerfiles and docker-compose

## Bare-Metal Setup

### Virtual Environments and Package Management
A virtual environment is useful to keep packages on your system clean. Use the following 
commands to generate and activate a virtual environment for this app:
- `python3 -m venv env`
- `source env/bin/activate`

Now that you are in your virtual evironment, you can install the packages specified by your 
requirements.txt file. These packages will be installed to the virtual environment, not your 
global system.
- ` pip install -r requirements.txt`

### Running Your App
First, start up Redis:
- `docker run --name redis --detach --interactive --tty --rm --publish 6379:6379 --network br0 redis`

This can also be written as `docker run -n redis -dit --rm -p 6379:6379 --network br0 redis`

You can run your app with the following command: 
- `gunicorn demo:APP --bind=localhost:5000`

Awesome! You now have a working thingy. Now we're gonna make it work better

## Running in Docker

First, build with `docker build -t docker-demo .`. Then run with the command `docker run --name docker-demo --detach --interactive --tty --rm --publish 80:8080 --network br0 --env REDIS_HOST="redis" docker-demo`

This can also be written as `docker run --name docker-demo -dit --rm -p 80:8080 --network br0 -e REDIS_HOST="redis" docker-demo`

You can now `curl localhost` and get your counter!


## Notes

### Redis as Docker
Docker is extremely useful for running something like a database without installing it on your system. To run a temporary Redis instance that binds to `localhost:6379`, use the following command: `docker run --name redis --detach --interactive --tty --rm --publish 6379:6379 redis`

This can also be written as `docker run --rm --name -dit redis -p 6379:6379 redis`

### References:
- [Install Docker](https://docs.docker.com/engine/install/)
- [Install docker-compose](https://docs.docker.com/compose/install/)
- [docker run](https://docs.docker.com/engine/reference/run/)
- [Dockerfile](https://docs.docker.com/engine/reference/builder/)
- [docker-compose](https://docs.docker.com/compose/compose-file/compose-file-v3/)
