FROM node:10.16.3-alpine as build-stage
ENV HOME=/home/app
COPY package.json yarn.lock tsconfig.json $HOME/
WORKDIR $HOME
RUN yarn && yarn cache clean
COPY src $HOME/src
RUN yarn build

# ----

FROM node:10.16.3-alpine
ENV HOME=/home/app
COPY package.json yarn.lock $HOME/

WORKDIR $HOME
RUN yarn --production && yarn cache clean

# Bundle app source
COPY --from=build-stage /home/app/dist $HOME/src/node/
COPY config/ $HOME/config/
COPY src/db/ $HOME/src/db/

CMD [ "yarn", "production" ]