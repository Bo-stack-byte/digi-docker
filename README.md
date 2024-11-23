# digi-docker
Dockerfile to pull together everyone's pieces to get a simulator running. Can deploy to google-cloud.

build:

     docker build . -t sim-app

If you have trouble about buildkit, delete the `--mount=type=cache,target=/root/.npm` strings and try again

run:

     docker run -it -p 3001:3001 sim-app

Then go to http://localhost:3001/
