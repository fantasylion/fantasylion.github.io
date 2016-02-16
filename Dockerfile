From ruby:2.3.0

RUN gem sources --add https://ruby.taobao.org/ --remove https://rubygems.org/ && \
  gem install jekyll:3.0.2 jekyll-sitemap jekyll-paginate jekyll-gist && \
  mkdir /srv/jekyll

VOLUME /srv/jekyll
EXPOSE 4000

WORKDIR /srv/jekyll

ENTRYPOINT ["jekyll"]
CMD ["serve", "-H", "0.0.0.0", "-P", "4000"]

