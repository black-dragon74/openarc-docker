# openarc-docker

A Docker image for [OpenARC](http://www.trusteddomain.org/openarc/), providing ARC (Authenticated Received Chain) message signing and verification. Built on CentOS Stream 8.

## Configuration

Copy `example.env` to `.env` and adjust the values:

| Variable | Default | Description |
|----------|---------|-------------|
| `DOMAIN` | *(required)* | The domain that sends email |
| `KEYFILE` | `DKIM.key` | Name of the bind-mounted key file |
| `SELECTOR` | `dkim` | DKIM DNS selector (without `._domainkey`) |
| `SIG_ALG` | `rsa-sha256` | Signature algorithm for ARC signing |

## Usage

1. Place your DKIM private key in the project directory (e.g. `DKIM.key`).

2. Create your `.env` file:

   ```sh
   cp example.env .env
   # edit .env with your values
   ```

3. Run the container:

   ```sh
   docker build -t openarc .
   docker run -d \
     --env-file .env \
     -v $(pwd)/DKIM.key:/app/DKIM.key:ro \
     -p 8894:8894 \
     openarc
   ```

OpenARC listens on port **8894** and runs in sign+verify (`sv`) mode. Connect your MTA's milter configuration to this port.
