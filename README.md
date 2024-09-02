# digi-docker
Dockerfile to pull together everyone's pieces

build:

     docker build . -t sim-app

run:

     docker run -it -p 3001:3001 sim-app

Then go to http://localhost:3001/
