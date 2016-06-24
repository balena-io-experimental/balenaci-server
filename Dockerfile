FROM library/docker:1.10.3

WORKDIR /usr/src/app

ENTRYPOINT ["/usr/bin/bundle"]
CMD ["exec", "shotgun", "-p", "80", "-o", "0.0.0.0"]

RUN apk update \
	&& apk add \
		ruby \
		ruby-bundler \
		ruby-json

COPY src/Gemfile .
RUN bundle -j 4

EXPOSE 80

COPY src .

