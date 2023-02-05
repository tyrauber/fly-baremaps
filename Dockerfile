FROM arm64v8/alpine as base
RUN apk --update add git curl nano openjdk17-jre maven gcompat npm

FROM base AS build

# hivemind
RUN curl -L https://github.com/DarthSim/hivemind/releases/download/v1.1.0/hivemind-v1.1.0-linux-amd64.gz -o hivemind.gz\
  && gunzip hivemind.gz \
  && mv hivemind /usr/local/bin

RUN git clone https://github.com/apache/incubator-baremaps.git /app/baremaps
WORKDIR /app/baremaps
RUN ./mvnw clean install -DskipTests
RUN unzip /app/baremaps/baremaps-cli/target/baremaps.zip

FROM base AS dependencies

WORKDIR /app

COPY ./package.json .
RUN npm set progress=false \
  && npm config set depth 0 \
  && npm install --only=production \
  && cp -R node_modules ./prod_node_modules \
  && npm install \
  && rm package.json

FROM base as release

WORKDIR /app

COPY --from=build /app/baremaps/baremaps /app/baremaps
ENV PATH = $PATH:/app/baremaps/bin

COPY --from=build /usr/local/bin/hivemind /usr/local/bin/hivemind
RUN chmod +x /usr/local/bin/hivemind

COPY --from=dependencies /app/prod_node_modules /app/node_modules

EXPOSE 8080
ENV PORT=8080

#COPY /app /app
COPY ./package.json .
COPY ./server.js .
COPY ./Procfile .

CMD ["/usr/local/bin/hivemind"]