FROM elixir:1.15.0

RUN mkdir /app
COPY ./ /app

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix do deps.get, deps.compile
RUN mix do compile

ENV MIX_ENV=prod

EXPOSE 4000

CMD ["sh", "entrypoint.sh"]
