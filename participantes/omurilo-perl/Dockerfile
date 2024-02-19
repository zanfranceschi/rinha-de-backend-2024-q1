FROM perl:5.36

WORKDIR /usr/src/myapp

RUN apt-get install libssl-dev zlib1g-dev

COPY cpanfile* /usr/src/myapp

RUN cpan -i App::cpanminus
RUN cpanm --cpanfile cpanfile --installdeps --notest --quiet .

COPY . /usr/src/myapp

ENTRYPOINT ["perl", "-I", "local/lib/perl5", "./src/slick-sqlite.pl"]
