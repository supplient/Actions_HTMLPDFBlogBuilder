FROM python
COPY ./*.py /
ENTRYPOINT ["python", "/make_index.py"]