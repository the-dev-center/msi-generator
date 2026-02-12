FROM dlang2/ldc-ubuntu:latest AS builder

RUN apt-get update && apt-get install -y zlib1g-dev

WORKDIR /src
COPY . .

# Build using prod configuration (string UUIDs)
RUN dub build --build=release --config=prod

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y zlib1g && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /src/msi-generator /usr/local/bin/msi-generator

ENTRYPOINT ["msi-generator"]
