FROM python:3.9-alpine3.13
LABEL maintainer="mmweru"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false

RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install --default-timeout=100 -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; \
        then /opt/venv/bin/pip install --default-timeout=100 -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/opt/venv/bin:$PATH"

USER django-user