FROM python:latest

RUN mkdir /app

COPY app.py Pipfile Pipfile.lock /app/

WORKDIR /app
RUN pip install --upgrade pip pipenv
RUN pipenv install --system
ENV FLASK_APP=app.py

EXPOSE 80

CMD ["flask", "run", "-h", "0.0.0.0", "-p", "80"]
