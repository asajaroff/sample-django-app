FROM python:3.11-slim-bullseye

ENV PYTHONUNBUFFERED 1  
ENV PYTHONDONTWRITEBYTECODE 1

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y libpq-dev build-essential

COPY requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt \  
    && rm -rf /tmp/requirements.txt \  
    && useradd -U app_user \  
    && install -d -m 0755 -o app_user -g app_user /app/static

USER app_user:app_user
WORKDIR /app

COPY --chown=app_user:app_user src /app

# RUN python /app/manage.py makemigrations
# RUN python /app/manage.py collectstatic

EXPOSE 8000

CMD ["python", "/app/manage.py", "runserver", "localhost:8000"]
