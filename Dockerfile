FROM python:3.8

COPY . /

RUN pip install --upgrade pip

RUN pip install --no-cache-dir -r requirements.txt

CMD ["uvicorn", "app:app", "--reload", "--port", "8080", "--host", "0.0.0.0"]