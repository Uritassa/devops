FROM python:3.12-alpine3.20
RUN addgroup -S appgrp && adduser -S appusr -G appgrp -h /app
WORKDIR /app
COPY requirements.txt app.py helpers.py logger.py ./
RUN apk upgrade && apk add --no-cache  --virtual .build-deps gcc musl-dev python3-dev libffi-dev && \
  pip3 install  --no-cache-dir -r requirements.txt && \
  apk del .build-deps python3-dev libffi-dev
USER appusr
CMD ["python3", "-m", "app"]
