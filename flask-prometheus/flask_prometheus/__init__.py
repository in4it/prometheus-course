# modified version of https://github.com/sbarratt/flask-prometheus

import time

import _mysql
import os

from prometheus_client import Counter, Histogram
from prometheus_client import start_http_server
from flask import request

FLASK_REQUEST_LATENCY = Histogram('flask_request_latency_seconds', 'Flask Request Latency',
				['method', 'endpoint'])
FLASK_REQUEST_COUNT = Counter('flask_request_count', 'Flask Request Count',
				['method', 'endpoint', 'http_status'])

MYSQL_REQUEST_LATENCY = Histogram('mysql_query_latency_seconds', 'MYSQL Query Latency',
				['query'])
MYSQL_REQUEST_COUNT = Counter('mysql_query_count', 'Flask Request Count',
				['query'])



def before_request():
    request.start_time = time.time()


def after_request(response):
    request_latency = time.time() - request.start_time
    FLASK_REQUEST_LATENCY.labels(request.method, request.path).observe(request_latency)
    FLASK_REQUEST_COUNT.labels(request.method, request.path, response.status_code).inc()

    return response

def monitor(app, port=8000, addr=''):
    app.before_request(before_request)
    app.after_request(after_request)
    start_http_server(port, addr)


def mysql_fetchall(db, sql):
    # get start time
    start_time = time.time()
    # execute query
    cursor = db.cursor()
    cursor.execute(sql)
    data=cursor.fetchall()
    # log finish time
    query_latency = time.time() - start_time
    MYSQL_REQUEST_LATENCY.labels(sql[:50]).observe(query_latency)
    MYSQL_REQUEST_COUNT.labels(sql[:50]).inc()
    # return data
    return data
