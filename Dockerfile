FROM tiangolo/uvicorn-gunicorn-fastapi:python3.10
ENV PORT 8080
ENV APP_MODULE app.api:app
ENV LOG_LEVEL debug
ENV WEB_CONCURRENCY 2

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/opt/poetry python3
ENV PATH="/opt/poetry/bin:$PATH"
RUN poetry config virtualenvs.create false

# Copy poetry.lock* in case it doesn't exist in the repo
COPY ./pyproject.toml ./poetry.lock* .


# Allow installing dev dependencies to run tests
ARG INSTALL_DEV=false
RUN bash -c "if [ $INSTALL_DEV == 'true' ] ; then poetry install --no-root ; else poetry install --no-root --no-dev ; fi"

# COPY ./requirements.txt ./requirements.txt
# RUN pip install -r requirements.txt

RUN spacy download en_core_web_trf

WORKDIR /app
# COPY ./app /app/app
COPY ./app /app/app
# ENV PYTHONPATH=/app

EXPOSE 80

# CMD ["/start.sh"]
CMD ["uvicorn", "app.api:app", "--host", "0.0.0.0", "--port", "8080"]
