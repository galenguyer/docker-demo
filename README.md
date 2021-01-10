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
You can run your app with the following command: 
- `gunicorn demo:APP --bind=localhost:5000`

To configure it, do some other stuff I'll add in a bit