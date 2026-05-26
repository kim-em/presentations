#!/usr/bin/env bash
# Build _slides/, rsync them to tqft.net, and serve them on localhost.
# Public URL: https://tqft.net/talks/20260526-Oxford/
set -euo pipefail

REMOTE_HOST="tqft.net"
REMOTE_PATH="tqft.net/talks/20260526-Oxford"
PUBLIC_URL="https://tqft.net/talks/20260526-Oxford/"
PORT=47291

DIR="$(cd "$(dirname "$0")" && pwd)"
SLIDES_DIR="$DIR/_slides"
LOG="$DIR/.serve.log"

log() { printf '[sync] %s\n' "$*" >&2; }

cd "$DIR"

if [[ "${1:-}" != "--no-build" ]]; then
    log "building slides..."
    lake exe generate-slides
fi

if [[ ! -d "$SLIDES_DIR" ]]; then
    log "ERROR: $SLIDES_DIR does not exist"
    exit 1
fi

log "ensuring remote directory exists..."
ssh "$REMOTE_HOST" "mkdir -p ~/$REMOTE_PATH"

log "rsyncing _slides/ -> $REMOTE_HOST:~/$REMOTE_PATH/"
rsync -avz --delete "$SLIDES_DIR/" "$REMOTE_HOST:$REMOTE_PATH/"

log "remote: $PUBLIC_URL"

stragglers="$(lsof -nP -iTCP:${PORT} -sTCP:LISTEN -t 2>/dev/null || true)"
if [[ -n "$stragglers" ]]; then
    log "killing stragglers on :${PORT}: $(echo $stragglers | tr '\n' ' ')"
    # shellcheck disable=SC2086
    kill $stragglers 2>/dev/null || true
    sleep 0.3
    stragglers="$(lsof -nP -iTCP:${PORT} -sTCP:LISTEN -t 2>/dev/null || true)"
    if [[ -n "$stragglers" ]]; then
        # shellcheck disable=SC2086
        kill -9 $stragglers 2>/dev/null || true
        sleep 0.3
    fi
fi

cd "$SLIDES_DIR"
nohup python3 -m http.server "$PORT" --bind 127.0.0.1 >"$LOG" 2>&1 &
NEW_PID=$!
disown

for _ in $(seq 1 25); do
    if curl -sS --max-time 1 "http://127.0.0.1:${PORT}/" >/dev/null 2>&1; then
        log "local: http://localhost:${PORT}/ (pid $NEW_PID, log $LOG)"
        exit 0
    fi
    sleep 0.2
done

log "ERROR: local server did not respond within 5s. Last 20 log lines:"
tail -n 20 "$LOG" >&2 || true
exit 1
