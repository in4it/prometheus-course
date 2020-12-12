FROM python:3-alpine

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN apk --update add --no-cache mariadb-dev gcc musl-dev && \
    pip install --no-cache-dir -r requirements.txt && \
    apk del gcc musl-dev

RUN apk --update add bash && \
    wget -q -O /wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
    chmod +x /wait-for-it.sh

COPY . .

EXPOSE 5000
EXPOSE 8000

CMD [ "python", "./main.py" ]
