FROM python:3.8-alpine
LABEL maintainer="Galen Guyer <galen@galenguyer.com>"

RUN apk add tzdata && \
    cp /usr/share/zoneinfo/America/New_York /etc/localtime && \
    echo "America/New_York" > /etc/timezone && \
    apk del tzdata

WORKDIR /app
COPY requirements.txt /app
RUN pip install -r requirements.txt
COPY . /app

ENTRYPOINT ["gunicorn", "demo:APP"]
CMD ["--bind=0.0.0.0:8080"]
