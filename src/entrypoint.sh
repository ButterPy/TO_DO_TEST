#!/bin/bash

wait_for () {
    for _ in `seq 0 100`; do
        (echo > /dev/tcp/$1/$2) >/dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            echo "$1:$2 accepts connections"
            break
        fi
        sleep 1
    done
}

wait_for "${POSTGRES_HOST}" "${POSTGRES_PORT}"
python manage.py collectstatic --noinput &&
python manage.py migrate &&
gunicorn --config gunicorn_conf.py config.wsgi:application
