FROM python
COPY app.py . 
COPY requirements.txt . 
COPY wsgi.py . 
COPY db-init.sql . 
RUN python -m pip install --upgrade pip
RUN python -m pip install -r requirements.txt
ENV workers=1
EXPOSE 8001
ENTRYPOINT gunicorn --bind 0.0.0.0:8001 -w "$workers" wsgi:app
# ENTRYPOINT [ "gunicorn", "--bind", "0.0.0.0:8001", "-w", "$workers", "wsgi:app" ] 
