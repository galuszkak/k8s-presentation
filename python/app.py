import os
import json
import logging
from flask import Flask, jsonify, request, abort, Response
from flask.views import MethodView
from redis import from_url

if not os.environ.get('REDIS_URL'):
    raise EnvironmentError("Lack of REDIS_URL")

redis_url = os.environ.get('REDIS_URL') 
client = from_url(redis_url)

app = Flask(__name__)
app.url_map.strict_slashes = False

logger = logging.getLogger(__name__)

class HealthCheckView(MethodView):
    def get(self):
        return jsonify({"status": "OK"})


class JobSearchView(MethodView):
    def post(self):
        data = request.get_json()
        logger.info("Sending task job for search %s", data)
        client.publish("jobs", json.dumps(data))
        return jsonify(data)


class ResultView(MethodView):
    def get(self, result_id):
        
        results = client.get(result_id)
        if results:
            return jsonify(json.loads(results.decode('utf-8')))
        else:
            abort(404)

    def delete(self, result_id):
        result = client.delete(result_id)
        if not result:
            abort(404)
        return Response(status=204)


app.add_url_rule('/healthcheck', view_func=HealthCheckView.as_view(name="healthcheck"))
app.add_url_rule('/job', view_func=JobSearchView.as_view(name="job"))
app.add_url_rule('/result/<result_id>', view_func=ResultView.as_view(name="result"))
