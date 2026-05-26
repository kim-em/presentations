#!/usr/bin/env bash
# Serve the built _slides/ for this presentation on a fixed, unused
# high port. Kills any prior instance of this server first so we never
# fight for the port.
set -euo pipefail

PORT=47291
DIR="$(cd "$(dirname "$0")" && pwd)"
SLIDES_DIR="$DIR/_slides"
LOG="$DIR/.serve.log"

log() { printf '[serve] %s\n' "$*" >&2; }

stragglers="$(lsof -nP -iTCP:${PORT} -sTCP:LISTEN -t 2>/dev/null || true)"
if [[ -n "$stragglers" ]]; then
    log "Killing stragglers on :${PORT}: $(echo $stragglers | tr '\n' ' ')"
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

if [[ ! -d "$SLIDES_DIR" ]]; then
    log "ERROR: $SLIDES_DIR does not exist. Run 'lake exe generate-slides' first."
    exit 1
fi

cd "$SLIDES_DIR"
nohup python3 -m http.server "$PORT" --bind 127.0.0.1 >"$LOG" 2>&1 &
NEW_PID=$!
disown

for _ in $(seq 1 25); do
    if curl -sS --max-time 1 "http://127.0.0.1:${PORT}/" >/dev/null 2>&1; then
        log "Serving $SLIDES_DIR at http://localhost:${PORT}/ (pid $NEW_PID)"
        log "Log: $LOG"
        exit 0
    fi
    sleep 0.2
done

log "ERROR: server did not respond within 5s. Last 20 log lines:"
tail -n 20 "$LOG" >&2 || true
exit 1
