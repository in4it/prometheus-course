FROM python:3-alpine

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN apk --update add --no-cache mariadb-dev gcc musl-dev && \
    pip install --no-cache-dir -r requirements.txt && \
    apk del gcc musl-dev

COPY . .

EXPOSE 5000
EXPOSE 8000

CMD [ "python", "./main.py" ]
