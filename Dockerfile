FROM python:3.11-slim


WORKDIR /app


# system deps (if needed)
RUN apt-get update && apt-get install -y --no-install-recommends \
build-essential \
&& rm -rf /var/lib/apt/lists/*


COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt


COPY . .


EXPOSE 5000


# use gunicorn for production-like server
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app", "--workers", "3"]