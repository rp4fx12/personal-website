FROM debian:jessie

RUN apt-get -qq update \
	&& DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends python-pygments git ca-certificates asciidoc \
	&& rm -rf /var/lib/apt/lists/*

# Download and install hugo
ENV HUGO_VERSION 0.29
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.deb

ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} /tmp/hugo.deb
RUN dpkg -i /tmp/hugo.deb \
	&& rm /tmp/hugo.deb


# Expose default hugo port
EXPOSE ${HUGO_PORT}

# Automatically build site
RUN mkdir /app
ADD site/ /app
WORKDIR /app
CMD hugo server -b ${HUGO_BASE_URL} -p ${HUGO_PORT} --bind=0.0.0.0
