FROM node:21
EXPOSE 3001

ARG REACT_APP_GOOGLE_CLIENT_ID
ENV REACT_APP_GOOGLE_CLIENT_ID=$REACT_APP_GOOGLE_CLIENT_ID
ENV REACT_APP_TEST=abc

WORKDIR /app
RUN pwd
RUN ls /tmp
# changes least often:
RUN git clone https://github.com/danweber/tcg-rules-simulator /app/server
# changes somewhat often:
RUN git clone https://github.com/Bo-stack-byte/card-ui /app/ui
RUN git clone https://github.com/Bo-stack-byte/card-creator /app/card-creator
# usually changes daily:
RUN curl -o /app/server/cards.json https://raw.githubusercontent.com/TakaOtaku/Digimon-Card-App/main/src/assets/cardlists/DigimonCards.json

COPY ./translate.txt /app/server/
COPY ./tokens.json /app/server/
COPY ./index.ejs /app/server/views/

RUN cp /app/card-creator/server/db.js /app/card-creator/server/extra.js /app/server/
RUN mkdir -p /app/server/plugins
RUN mkdir -p /app/server/plugins/creator/

#RUN cp /app/card-creator/server/package.json /app/server/plugins/creator/package.json
COPY ./ccc.json /app/server/plugins/creator/package.json

WORKDIR /app/server
# no longer install
RUN  --mount=type=cache,target=/root/.npm  npm run setup
RUN ls /app/server/plugins/creator/
RUN  --mount=type=cache,target=/root/.npm  npm install -g typescript

WORKDIR /app/ui
RUN  --mount=type=cache,target=/root/.npm   npm install
RUN npm run build
RUN mv /app/ui/build /app/server/build

WORKDIR /app/card-creator
RUN npm install
RUN npm run build
RUN mv /app/card-creator/build /app/server/build-cc

WORKDIR /app/ui/public
RUN cp favicon.ico icon.png /app/server/build
RUN cp favicon.ico /app/server/public
RUN ls -al /app/server/public/
RUN ls -al /app/server/build/

WORKDIR /app/server/models
RUN tsc
RUN ls -alR .
RUN cp -p dist/*.js .
CMD ["/bin/bash", "-c", "npm start > stdout.txt" ]


# build:
#     docker build . -t sim-app
# If you have trouble with buildkit, delete `--mount=type=cache,target=/root/.npm` and try again 
# run:
#     docker run -it -p 3001:3001 sim-app
# then go to http://localhost:3001/
