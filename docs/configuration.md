# Configuration reference

Feeds are configured as a list under `ical_feeds` in `_config.yml`. Each entry
produces one `.ics` file.

```yaml
ical_feeds:
  - path: fixtures.ics              # output path (required)
    source: data:fixtures           # data:<file>[.<key>…] | collection:<label> | posts (required)
    name: "Kingsbridge FC"          # calendar name shown in clients (default: site.title)
    timezone: Europe/London         # X-WR-TIMEZONE hint (default: site.timezone)
    refresh: PT6H                   # refresh hint for clients, ISO 8601 duration
    where: { home: Kingsbridge FC } # only items whose fields equal these values
    transparent: true               # events don't block time (shown as "free")
    all_day: auto                   # auto | true | false
    fields:                         # where each event property comes from; defaults shown
      start: date
      end: end
      duration: duration
      title: title
      location: location
      description: description
      url: url
      uid: url
      links: {}
```

## Feed options

| Option        | Required | Default          | Description |
| ------------- | -------- | ---------------- | ----------- |
| `path`        | yes      |                  | Output path relative to the site root, e.g. `calendar/fixtures.ics`. |
| `source`      | yes      |                  | Where the events come from, see [Sources](sources.md). |
| `name`        | no       | `site.title`     | Calendar name shown in calendar apps (`X-WR-CALNAME`). |
| `timezone`    | no       | `site.timezone`  | Time zone hint for calendar apps (`X-WR-TIMEZONE`). Does not affect how times are read, see [Time zones](dates.md#time-zones). |
| `refresh`     | no       |                  | Suggested reload interval as an ISO 8601 duration, e.g. `PT6H` or `P1D`. |
| `where`       | no       |                  | Keep only items whose fields equal all of these values (compared as strings). |
| `transparent` | no       | `false`          | Mark events as free time (`TRANSP:TRANSPARENT`). |
| `all_day`     | no       | `auto`           | `auto`: dates and midnight times are all-day. `true`: all events are all-day. `false`: all events are timed. See [All-day and timed events](dates.md). |
| `fields`      | no       | see below        | Field mapping, see [Field mapping](fields.md). |

## Fields

Each field is a key of the item, or a Liquid template if it contains `{{` or
`{%`.

| Field         | Default       | iCalendar property | Notes |
| ------------- | ------------- | ------------------ | ----- |
| `start`       | `date`        | `DTSTART`          | Required; items without a start are skipped. |
| `end`         | `end`         | `DTEND`            | Optional. Exclusive for all-day events. |
| `duration`    | `duration`    |                    | Minutes; timed events only. Default length is 60 minutes. |
| `title`       | `title`       | `SUMMARY`          | |
| `location`    | `location`    | `LOCATION`         | |
| `description` | `description` | `DESCRIPTION`      | `links` are appended. |
| `url`         | `url`         | `URL`              | Absolute or site-relative. |
| `uid`         | `url`         | `UID`              | Hashed; falls back to start and title. |
| `links`       | `{}`          | `DESCRIPTION`      | Map of label → key; values are keys only, not templates. |

## Liquid filter

| Filter   | Example | Result |
| -------- | ------- | ------ |
| `webcal` | `{{ 'https://kingsbridge-fc.example/fixtures.ics' \| webcal }}` | `webcal://kingsbridge-fc.example/fixtures.ics` |

## Site settings used

| Setting    | Used for |
| ---------- | -------- |
| `url`      | Absolute URLs, the host part of event IDs and the `PRODID`. |
| `baseurl`  | Prefixed to site-relative URLs. |
| `title`    | Default calendar name. |
| `timezone` | Time zone for date-times without an offset; default `timezone` hint. |

## Output

The generated files are regular Jekyll pages: no layout is applied, and they
are excluded from `jekyll-sitemap` (`sitemap: false`).
