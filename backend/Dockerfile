#base image for the python application
FROM python:3.10

WORKDIR /app

COPY requirements.txt ./

RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install -r requirements.txt

COPY . .

ENV FLASK_APP main.py

EXPOSE 5000

CMD ["flask", "run"]