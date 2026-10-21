# Getting started

This page takes Kingsbridge FC from zero to a subscribable fixtures calendar.

## Requirements

- Jekyll 4
- Ruby 3.1 or newer

## Installation

Add the gem to the `jekyll_plugins` group of your site's `Gemfile`:

```ruby
group :jekyll_plugins do
  gem "jekyll-ical-feed"
end
```

If the version you need is not on RubyGems.org yet, install it straight from
GitHub instead:

```ruby
gem "jekyll-ical-feed", git: "https://github.com/hollesse/jekyll-ical-feed", tag: "v0.1.0"
```

Then install it:

```sh
bundle install
```

Gems in the `jekyll_plugins` group are loaded automatically. If you prefer,
you can also list the plugin in `_config.yml`:

```yaml
plugins:
  - jekyll-ical-feed
```

## 1. Describe the matches

Put the fixtures into a data file. Each list entry becomes one calendar event.

```yaml
# _data/fixtures.yml
- id: 2026-league-01
  kickoff: "2026-08-15 15:00"
  home: Kingsbridge FC
  away: Harbour Town
  venue: Riverside Stadium

- id: 2026-league-02
  kickoff: "2026-08-22 17:30"
  home: Northgate Rovers
  away: Kingsbridge FC
  venue: Northgate Park
```

!!! tip "Quote your kickoff times"
    Write date-times in quotes. Unquoted values with seconds and no UTC offset
    (`2026-08-15 15:00:00`) are read by YAML as **UTC**, which would shift the
    match by an hour or two. See [Dates, times and time zones](dates.md).

## 2. Configure the feed

Add an `ical_feeds` entry to `_config.yml`. The `fields` section tells the
plugin which of your keys holds which piece of information:

```yaml
# _config.yml
url: "https://kingsbridge-fc.example"
title: "Kingsbridge FC"
timezone: Europe/London

ical_feeds:
  - path: fixtures.ics
    source: data:fixtures
    name: "Kingsbridge FC · Fixtures"
    fields:
      start: kickoff
      title: "{{ home }} vs {{ away }}"
      location: venue
      duration: "{{ duration | default: 105 }}"
      uid: id
```

- `path` is where the file ends up in `_site/`.
- `source: data:fixtures` reads `_data/fixtures.yml`.
- `title` is a Liquid template, so it can combine several fields.
- `duration` is in minutes. A football match with half-time takes about
  105 minutes; without this, timed events last 60 minutes.
- `uid` gives every match a stable ID, see [Stable event IDs](subscribing.md#stable-event-ids).

!!! note
    Set `url` in `_config.yml`. The plugin uses it to turn relative links into
    absolute ones and to build event IDs.

## 3. Build and check

```sh
bundle exec jekyll build
```

`_site/fixtures.ics` now contains one `VEVENT` per match:

```text
BEGIN:VEVENT
UID:4f3c…@kingsbridge-fc.example
DTSTAMP:20260801T120000Z
DTSTART:20260815T140000Z
DTEND:20260815T154500Z
SUMMARY:Kingsbridge FC vs Harbour Town
LOCATION:Riverside Stadium
END:VEVENT
```

Times are written in UTC: 15:00 in London in summer (BST) is 14:00 UTC.
Calendar apps show it in each viewer's local time.

## 4. Link it

Use the `webcal` filter so a click opens the subscription dialog of the
visitor's calendar app instead of downloading the file:

```liquid
<a href="{{ '/fixtures.ics' | absolute_url | webcal }}">Add all fixtures to your calendar</a>
```

That's it. Whenever you add a match or change a kickoff time and rebuild the
site, your fans' calendars follow.

Continue with the [full football club example](example.md) for multiple feeds,
match pages and ticket links.
