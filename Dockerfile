FROM python:3.11-slim-bullseye

# Oprava archivních repozitářů pro starší Debian Bullseye
RUN echo "deb http://archive.debian.org/debian bullseye main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security bullseye-security main" >> /etc/apt/sources.list && \
    sed -i '/deb http:\/\/deb.debian.org\/debian bullseye-updates/d' /etc/apt/sources.list || true

WORKDIR /app

ADD . /app

RUN apt-get update && \
    apt-get install -y --allow-insecure-repositories tesseract-ocr libtesseract-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir pytesseract

EXPOSE 8080

ENTRYPOINT ["python","run.py"]
