# Field mapping

Your data does not need a particular schema. The `fields` option tells the
plugin where each event property comes from. You only list the fields that
differ from the defaults.

| Field         | Default       | Used for                                                 |
| ------------- | ------------- | -------------------------------------------------------- |
| `start`       | `date`        | start of the event (`DTSTART`), required                 |
| `end`         | `end`         | end of the event (`DTEND`)                               |
| `duration`    | `duration`    | length in minutes, if there is no end                    |
| `title`       | `title`       | event title (`SUMMARY`)                                  |
| `location`    | `location`    | `LOCATION`                                               |
| `description` | `description` | `DESCRIPTION`                                            |
| `url`         | `url`         | link to the event (`URL`)                                |
| `uid`         | `url`         | stable ID, see [Stable event IDs](subscribing.md#stable-event-ids) |
| `links`       | none          | extra links, appended to the description                 |

## Keys

The simplest mapping is the name of a key in your item:

```yaml
fields:
  start: kickoff
  location: venue
  description: preview
```

## Liquid templates

A mapping that contains `{{` or `{%` is a Liquid template, rendered with the
item's fields as variables. Jekyll's filters (`slugify`, `date`,
`absolute_url`, …) are available.

```yaml
fields:
  title: "{{ home }} vs {{ away }}"
  location: "{{ venue }}, {{ city }}"
  url: "/matches/{{ id }}/"
```

Use tags for optional parts:

```yaml
fields:
  # "Riverside Stadium, Kingsbridge", or just "Riverside Stadium" without a city
  location: "{{ venue }}{% if city and city != empty %}, {{ city }}{% endif %}"

  # "Cup: Kingsbridge FC vs Harbour Town" for cup games only
  title: "{% if competition == 'Cup' %}Cup: {% endif %}{{ home }} vs {{ away }}"
```

Use the `default` filter for fallbacks, including fixed values:

```yaml
fields:
  # 105 minutes unless a match says otherwise (e.g. 135 for a cup game with extra time)
  duration: "{{ duration | default: 105 }}"
```

An empty result (after trimming whitespace) counts as a missing value: the
property is left out, and for `start` the item is skipped.

!!! warning "Quote templates in YAML"
    A value starting with `{` or `{%` must be quoted in `_config.yml`, or YAML
    will try to read it as a mapping.

## Links

`links` maps labels to keys. Every key that has a value adds a line to the
end of the description. Relative URLs are made absolute.

```yaml
fields:
  description: preview
  links:
    Tickets: tickets
    Live stream: stream
    Match report: report
```

```yaml
# _data/fixtures.yml
- id: 2026-league-01
  kickoff: "2026-08-15 15:00"
  home: Kingsbridge FC
  away: Harbour Town
  preview: Season opener under the floodlights.
  tickets: https://tickets.kingsbridge-fc.example/2026-league-01
  report: /news/2026/08/15/harbour-town-report/
```

The event description then reads:

```text
Season opener under the floodlights.

Tickets: https://tickets.kingsbridge-fc.example/2026-league-01

Match report: https://kingsbridge-fc.example/news/2026/08/15/harbour-town-report/
```

The values of `links` are plain keys; templates are not supported there.

## URLs

`url` (and every link) can be absolute (`https://…`) or relative to the site
(`/matches/2026-league-01/`). Relative URLs are prefixed with `url` and
`baseurl` from `_config.yml`.
