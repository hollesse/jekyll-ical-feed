# Sources

The `source` option decides where the events of a feed come from.

| `source`               | Events come from                                         |
| ---------------------- | -------------------------------------------------------- |
| `data:fixtures`        | the list in `_data/fixtures.yml`                         |
| `data:seasons.2026`    | the list under the key `2026` in `_data/seasons.yml`     |
| `collection:matches`   | the documents of the `matches` collection                |
| `posts`                | the site's posts                                         |

Items without a start value are skipped. The remaining events are sorted by
their start.

## Data files

`data:<file>` reads a file from `_data/` (YAML, JSON, CSV or TSV, as
supported by Jekyll). The file must contain a list:

```yaml
# _data/fixtures.yml
- id: 2026-league-01
  kickoff: "2026-08-15 15:00"
  home: AFC Richmond
  away: Crystal Palace
```

```yaml
source: data:fixtures
```

### Nested data

Add keys separated by dots to reach a list inside the file. This is handy if
you keep several seasons in one file:

```yaml
# _data/seasons.yml
"2025":
  - id: 2025-league-01
    kickoff: "2025-08-16 15:00"
    # …
"2026":
  - id: 2026-league-01
    kickoff: "2026-08-15 15:00"
    # …
```

```yaml
source: data:seasons.2026
```

Data files in subfolders work the same way: `_data/teams/women.yml` is
`data:teams.women`.

## Collections

`collection:<label>` uses the documents of a collection. The fields are the
document's front matter, plus:

- `url`: the document's URL (made absolute in the feed)
- `content`: the document's body

This works well if every match has its own page, e.g. with a preview and later
a match report:

```yaml
# _config.yml
collections:
  matches:
    output: true
    permalink: /matches/:name/
```

```markdown
---
# _matches/2026-league-01-crystal-palace.md
title: AFC Richmond vs Crystal Palace
kickoff: "2026-08-15 15:00"
venue: Nelson Road
---
Our first home game of the season. Coach Lasso says: "Be a goldfish." …
```

```yaml
ical_feeds:
  - path: matches.ics
    source: collection:matches
    fields:
      start: kickoff
      location: venue
      # title and url fall back to the defaults `title` and `url`
```

Each event links to its match page, and because the URL never changes, it also
serves as the event ID.

!!! note
    The default start field is `date`. Jekyll treats `date` in front matter
    specially and reads it as a time at midnight, so with the default
    `all_day: auto` such events become all-day events. Use your own key, like
    `kickoff`, for timed events.

## Posts

`posts` uses the site's posts, with the same fields as a collection. By default
the event starts at the post's `date`, so posts with dates in the future work
as a simple event list (remember that Jekyll only publishes future posts with
`future: true`).

More often you map the start to a front matter field of your own:

```yaml
ical_feeds:
  - path: events.ics
    source: posts
    where: { type: event }
    fields:
      start: event_date
```

```markdown
---
# _posts/2026-08-01-farewell-to-mae.md
title: Mae's wake at the Crown & Anchor
type: event
event_date: "2026-08-22 17:00"
location: The Crown & Anchor, Richmond
---
For as long as anyone can remember, Mae pulled the pints and kept the
Greyhounds honest. We say goodbye where she would have wanted it: in her pub.
Baz, Jeremy and Paul, the Crown & Anchor's new landlords, are hosting and
promise to honour her one request. Bring your scarf, raise a glass, and share
your favourite Mae story.
```

## Filtering with `where`

`where` keeps only the items whose fields equal the given values. All
conditions must match. Values are compared as strings.

```yaml
# Only home games
where: { home: AFC Richmond }

# Only cup games at home
where: { competition: Cup, home: AFC Richmond }
```

`where` looks at the item's own keys, not at the mapped fields.

## Errors

If a source does not exist (unknown file, collection or source type), the
plugin logs a warning and writes an empty calendar, so the build does not
fail. A feed entry without `path` or `source` is skipped with a warning.
