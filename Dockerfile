FROM python:3.8-alpine as builder
EXPOSE 80
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
COPY req.txt .
COPY main.py .
RUN pip install --upgrade pip && pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r req.txt
FROM python:3.8-alpine
WORKDIR /app
COPY --from=builder /app/wheels /wheels
COPY --from=builder /app/req.txt .
COPY --from=builder /app/main.py .
RUN pip install --no-cache /wheels/*
CMD ["uvicorn", "main:app", "--proxy-headers", "--host", "0.0.0.0", "--port", "8002"]
