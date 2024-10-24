FROM node:21
EXPOSE 3001

WORKDIR /app
RUN pwd
RUN git clone https://github.com/Bo-stack-byte/card-creator /app/card-creator
RUN git clone https://github.com/danweber/tcg-rules-simulator /app/server
RUN git clone https://github.com/Bo-stack-byte/card-ui /app/ui
RUN curl -o /app/server/cards.json https://raw.githubusercontent.com/TakaOtaku/Digimon-Card-App/main/src/assets/cardlists/DigimonCards.json

COPY ./translate.txt /app/server/translate.txt
COPY ./index.ejs /app/server/views/index.ejs

WORKDIR /app/server
RUN  --mount=type=cache,target=/root/.npm  npm install
RUN  --mount=type=cache,target=/root/.npm  npm install -g typescript

WORKDIR /app/ui
RUN  --mount=type=cache,target=/root/.npm   npm install
RUN npm run build
RUN mv /app/ui/build /app/server/build

WORKDIR /app/card-creator
RUN npm install
RUN npm run build
RUN mv /app/card-creator/build /app/server/build-cc

WORKDIR /app/server/models
RUN tsc
CMD ["/bin/bash", "-c", "npm start > stdout.txt" ]


# build:
#     docker build . -t sim-app
# If you have trouble with buildkit, delete `--mount=type=cache,target=/root/.npm` and try again 
# run:
#     docker run -it -p 3001:3001 sim-app
# then go to http://localhost:3001/
