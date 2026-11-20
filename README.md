# DataCat on Railway

[DataCat](https://github.com/replit/datacat) (Apache-2.0) — a self-hosted, Datadog-style observability platform from Replit: metrics, logs, APM traces, dashboards and monitors with OTLP intake. Deploy it on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/PLACEHOLDER)

## What this template runs

- **datacat**: `ghcr.io/onepush-dev/datacat:f08fb63`, upstream `replit/datacat` built from source at commit `f08fb63` (code unmodified, no releases exist yet). Listens on 8080 behind Railway's HTTPS proxy (`DATACAT_TRUST_PROXY=1`), 15-day telemetry retention.
- **postgres**: `postgres:16-alpine` with a volume. App data and telemetry (default `DATACAT_STORAGE=postgres`) live here. ClickHouse is optional upstream and not included.

## Variables

| Service | Variable | Value | Notes |
|---|---|---|---|
| datacat | `DATABASE_URL` | reference to postgres | Connection string built from the bundled Postgres. |
| datacat | `PUBLIC_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Canonical external origin (invite links, installer). |
| datacat | `SESSION_SECRET` | generated secret | Signs session cookies. |
| datacat | `DATACAT_SETUP_TOKEN` | generated secret | Required on the first-run setup page. |
| postgres | `POSTGRES_PASSWORD` | generated secret | Postgres superuser password. |

## How to use

1. Deploy, open the domain and create the admin account + organization; paste `DATACAT_SETUP_TOKEN` from the datacat variables.
2. Create an API key under Organization Settings and point OTLP / the DataCat agent at your domain.

Not affiliated with Replit or DataCat.
