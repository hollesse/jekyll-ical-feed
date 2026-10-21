# jekyll-ical-feed

A Jekyll plugin that generates subscribable iCalendar (`.ics`) feeds from data
files, collections or posts — e.g. a fixtures calendar for AFC Richmond
that fans can subscribe to.

**Documentation: <https://jekyll-ical-feed.readthedocs.io/>**

## Quick start

```ruby
# Gemfile
group :jekyll_plugins do
  gem "jekyll-ical-feed"
end
```

```yaml
# _config.yml
url: "https://afc-richmond.example"
timezone: Europe/London

ical_feeds:
  - path: fixtures.ics
    source: data:fixtures
    name: "AFC Richmond · Fixtures"
    fields:
      start: kickoff
      title: "{{ home }} vs {{ away }}"
      location: venue
      duration: "{{ duration | default: 105 }}"
      uid: id
```

```yaml
# _data/fixtures.yml
- id: 2026-league-01
  kickoff: "2026-08-15 15:00"
  home: AFC Richmond
  away: Crystal Palace
  venue: Nelson Road
```

```liquid
<a href="{{ '/fixtures.ics' | absolute_url | webcal }}">Add all fixtures to your calendar</a>
```

Until the gem is published on RubyGems.org, install it from GitHub:

```ruby
gem "jekyll-ical-feed", git: "https://github.com/hollesse/jekyll-ical-feed", tag: "v0.1.0"
```

## Development

```sh
bundle install
bundle exec rake test
```

See [Development](https://jekyll-ical-feed.readthedocs.io/en/latest/development/)
for building the docs and releasing.

## License

MIT, see [LICENSE](LICENSE).
