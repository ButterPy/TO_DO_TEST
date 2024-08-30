FROM python:3.12-slim

ARG DJANGO_ENVIRONMENT

ENV PYTHONUNBUFFERED=1 \
    COLUMNS=200 \
    TZ=Asia/Aqtau \
    # Poetry
    POETRY_VERSION=1.2.2 \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_CACHE_DIR='/var/cache/pypoetry' \
    POETRY_HOME='/usr/local'

RUN apt-get update && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    bash \
    build-essential \
    libpq-dev \
    gettext \
    cmake \
    ffmpeg \
    libsm6 \
    libxext6 \
    curl \
    # Installing `poetry` package manager:
    # https://github.com/python-poetry/poetry
    && curl -sSL 'https://install.python-poetry.org' | python - \
    && poetry --version \
    # Cleaning cache:
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
    # Set timezone:
    && ln -fs /usr/share/zoneinfo/Asia/Almaty /etc/localtime \
    && echo "Asia/Almaty" > /etc/timezone

COPY poetry.lock pyproject.toml /src/

WORKDIR /src

# Project initialization:
RUN poetry run pip install -U pip \
    && poetry install

COPY /src/entrypoint.sh /docker-entrypoint.sh

RUN chmod +x '/docker-entrypoint.sh'

COPY ./src /src

# ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
CMD ["/docker-entrypoint.sh"]
