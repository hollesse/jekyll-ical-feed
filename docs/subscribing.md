# Subscribing and updates

## Subscription links

A plain link to `fixtures.ics` makes most browsers download the file, and the
events are imported once. A `webcal://` link instead opens the visitor's
calendar app and offers to *subscribe*, so future changes arrive by
themselves.

The `webcal` filter replaces `http://` or `https://` with `webcal://`:

```liquid
<a href="{{ '/fixtures.ics' | absolute_url | webcal }}">Subscribe to all fixtures</a>
```

```html
<a href="webcal://afc-richmond.example/fixtures.ics">Subscribe to all fixtures</a>
```

For Google Calendar, which has no `webcal` handler on the web, offer the
`https` URL to copy, or a link to its *add by URL* page:

```liquid
{% assign feed = '/fixtures.ics' | absolute_url %}
<a href="https://calendar.google.com/calendar/r?cid={{ feed | webcal | url_encode }}">Add to Google Calendar</a>
```

## Stable event IDs

Every event has a `UID`. Calendar apps use it to recognise an event they
already know. If the UID stays the same, a changed kickoff time or venue
**updates** the existing entry. If the UID changes, fans end up with the old
and the new entry.

The UID is built from the `uid` field (default: `url`). If that is empty, the
plugin falls back to start and title. That fallback changes whenever the
kickoff time changes, so for fixtures give every match an ID of its own:

```yaml
- id: 2026-league-01
  kickoff: "2026-08-15 15:00"
  # …
```

```yaml
fields:
  uid: id
```

A template works too, as long as its parts never change:

```yaml
fields:
  uid: "{{ season }}-{{ competition }}-{{ home }}-{{ away }}"
```

The value is hashed, and the site's host name is appended, e.g.
`4f3c…@afc-richmond.example`.

## Refresh interval

Calendar apps decide on their own how often they reload a subscription,
anywhere from minutes to a day. `refresh` asks them to reload at a given
interval, as an ISO 8601 duration:

```yaml
refresh: PT6H    # every 6 hours
```

It is written as `REFRESH-INTERVAL` and `X-PUBLISHED-TTL`. Not every app
honours it.

## Free or busy

Fixtures are something fans *might* watch, not appointments. With
`transparent: true`, events are marked as *free*, so they don't block the
time in the subscriber's calendar and don't cause meeting conflicts:

```yaml
transparent: true
```

## Postponed and cancelled matches

Removing a match from the data removes it from the feed, and subscribed
calendars drop it on the next refresh. Be a goldfish.

To keep a postponed match visible, mark it in the title:

```yaml
fields:
  title: "{% if status == 'postponed' %}POSTPONED: {% endif %}{{ home }} vs {{ away }}"
```
