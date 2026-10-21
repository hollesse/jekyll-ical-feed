# jekyll-ical-feed

**jekyll-ical-feed** is a [Jekyll](https://jekyllrb.com/) plugin that turns
your site's data into calendar feeds that people can subscribe to. It writes
standard iCalendar (`.ics`) files that Apple Calendar, Google Calendar,
Outlook, Thunderbird and most other calendar apps can read.

Every time the site is rebuilt, the feed is regenerated. Calendar apps that
subscribed to it pick up new, moved and cancelled events on their own.

Throughout this documentation we build the website of **Kingsbridge FC**, a
(fictional) football club that wants its fans to have every fixture in their
calendar:

```yaml
# _data/fixtures.yml
- id: 2026-league-01
  kickoff: "2026-08-15 15:00"
  home: Kingsbridge FC
  away: Harbour Town
  venue: Riverside Stadium
```

```yaml
# _config.yml
ical_feeds:
  - path: fixtures.ics
    source: data:fixtures
    name: "Kingsbridge FC · Fixtures"
    fields:
      start: kickoff
      title: "{{ home }} vs {{ away }}"
      location: venue
      uid: id
```

```liquid
<a href="{{ '/fixtures.ics' | absolute_url | webcal }}">Add all fixtures to your calendar</a>
```

## Features

- Feeds from [data files, collections or posts](sources.md)
- Any number of feeds per site, e.g. *all fixtures*, *home games only*, *cup games*
- [Field mapping](fields.md) with plain keys or Liquid templates, so your data
  does not have to follow a fixed schema
- [All-day and timed events](dates.md), with an end time, a duration or a default length
- [Stable event IDs](subscribing.md#stable-event-ids) so calendar apps update
  events instead of duplicating them
- A `webcal` Liquid filter for one-click subscription links
- RFC 5545 compliant output: escaping, line folding, CRLF line endings

## Next steps

- [Getting started](getting-started.md): install the plugin and publish your first feed
- [Example: a football club](example.md): a complete site setup with several feeds
- [Configuration reference](configuration.md): every option at a glance
