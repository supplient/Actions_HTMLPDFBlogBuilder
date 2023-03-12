FROM pandoc/latex
COPY ./*.sh /
ENTRYPOINT ["sh", "/work.sh"]
