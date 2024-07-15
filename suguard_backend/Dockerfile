FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY ./app /app/app

COPY bulk_insert_cafes.py /app/bulk_insert_cafes.py
COPY cafes.json /app/cafes.json
COPY bulk_insert_drinks.py /app/bulk_insert_drinks.py
COPY drinks.json /app/drinks.json

CMD ["sh", "-c", "python /app/bulk_insert_cafes.py && python /app/bulk_insert_drinks.py && uvicorn app.main:app --host 0.0.0.0 --port 8000"]