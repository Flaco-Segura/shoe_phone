FROM elixir:alpine
    
RUN apk add --update --no-cache curl
RUN apk add --no-cache build-base git postgresql-client inotify-tools

ADD . /app

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install --force hex phx_new

WORKDIR /app

RUN chmod +x entrypoint.sh

CMD ["sh", "./entrypoint.sh"]
