From ubuntu:20.04
RUN apt-get update
COPY stock-server /usr/bin/stock-server
CMD ["/usr/bin/stock-server"]
