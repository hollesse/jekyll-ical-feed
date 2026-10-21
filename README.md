# jekyll-ical-feed

A Jekyll plugin that generates subscribable iCalendar (`.ics`) feeds from data
files, collections or posts — e.g. a talks page that people can subscribe to
in their calendar app.

## Installation

Add the gem to the `jekyll_plugins` group in your `Gemfile`:

```ruby
group :jekyll_plugins do
  gem "jekyll-ical-feed", git: "https://github.com/hollesse/jekyll-ical-feed", tag: "v0.1.0"
end
```

and run `bundle install`. Gems in the `jekyll_plugins` group are loaded
automatically; alternatively list `jekyll-ical-feed` under `plugins:` in
`_config.yml`.

## Configuration

Configure one or more feeds in `_config.yml`:

```yaml
ical_feeds:
  - path: talks.ics                 # output path (required)
    source: data:talks              # data:<file>[.<key>…] | collection:<label> | posts (required)
    name: "Talks"                   # calendar name shown in clients (default: site.title)
    timezone: Europe/Berlin         # X-WR-TIMEZONE hint (default: site.timezone)
    refresh: PT12H                  # refresh hint for clients, ISO 8601 duration
    where: { status: upcoming }     # optional: only items whose fields equal these values
    transparent: true               # optional: events don't block time (show as "free")
    all_day: auto                   # auto: dates and midnight times are all-day; or true/false
    fields:                         # where each event property comes from; defaults shown
      start: date                   # Date → all-day event, Time/datetime → timed event
      end: end                      # optional; else start + duration (timed) or + 1 day
      duration: duration            # minutes, only used for timed events
      title: title
      location: location
      description: description
      url: url                      # absolute or site-relative URL
      uid: url                      # stable key so clients update instead of duplicating
      links: {}                     # { "Slides": slides } → appended to the description
```

A field mapping can also be a Liquid template over the item's fields, e.g.

```yaml
title: "{{ where }}: {{ what }}"
location: "{{ where }}{% if city and city != empty %}, {{ city }}{% endif %}"
```

An empty result counts as a missing value.

For collections and posts the fields are the front matter, plus `url` and
`content`.

### Sources

| `source`             | Items                                                    |
| -------------------- | -------------------------------------------------------- |
| `data:talks`         | the list in `_data/talks.yml`                            |
| `data:events.2026`   | the list under key `2026` in `_data/events.yml`          |
| `collection:talks`   | the documents of the `talks` collection                  |
| `posts`              | the site's posts                                         |

Items without a start value are skipped; events are sorted by start.

## Linking a feed

Use the `webcal` filter to link a feed for one-click subscription:

```liquid
<a href="{{ '/talks.ics' | absolute_url | webcal }}">Subscribe</a>
```

## Development

```sh
bundle install
bundle exec rake test
```

## License

MIT, see [LICENSE](LICENSE).
