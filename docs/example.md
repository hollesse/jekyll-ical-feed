# Example: AFC Richmond

This page puts everything together for the website of **AFC Richmond**. Since
Ted Lasso arrived from Kansas, the club has more fans than ever, and Higgins
wants to offer them:

- one calendar with **all first-team fixtures**,
- one with **home games only**, for season ticket holders,
- one for the **women's team**,
- links to tickets, the live stream and the match report in every event.

## Site configuration

```yaml
# _config.yml
title: "AFC Richmond"
url: "https://afc-richmond.example"
timezone: Europe/London

plugins:
  - jekyll-ical-feed
```

## The fixture list

The first team's fixtures live in one data file per season. A match has a
stable `id`, a `kickoff`, the two teams and a few optional fields.

```yaml
# _data/fixtures/2026.yml
- id: 2026-league-01
  competition: League
  kickoff: "2026-08-15 15:00"
  home: AFC Richmond
  away: Crystal Palace
  venue: Nelson Road
  city: Richmond
  preview: Season opener at Nelson Road. Believe.
  tickets: https://tickets.afc-richmond.example/2026-league-01
  report: /news/2026/08/15/crystal-palace-report/

- id: 2026-league-02
  competition: League
  kickoff: "2026-08-22 17:30"
  home: Manchester City
  away: AFC Richmond
  venue: Etihad Stadium
  city: Manchester
  preview: Jamie Tartt returns to the Etihad. Expect fireworks.
  stream: https://tv.afc-richmond.example/live

- id: 2026-cup-r1
  competition: Cup
  kickoff: "2026-08-26 19:45"
  duration: 150            # extra time and penalties are possible
  preview: Rupert's West Ham at Nelson Road. Barbecue sauce.
  home: AFC Richmond
  away: West Ham United
  venue: Nelson Road
  city: Richmond

- id: 2026-league-03
  competition: League
  kickoff: "2026-08-29"    # kickoff time not announced yet → all-day event
  home: AFC Richmond
  away: Tottenham Hotspur
  venue: Nelson Road
  city: Richmond

- id: 2026-league-04
  competition: League
  kickoff: "2026-09-05 15:00"
  status: postponed
  home: Everton
  away: AFC Richmond
  venue: Goodison Park
  city: Liverpool
```

## The feeds

Both first-team feeds share the same field mapping. A YAML anchor (`&fixture`)
avoids repeating it.

```yaml
# _config.yml
ical_feeds:
  - path: calendar/fixtures.ics
    source: data:fixtures.2026
    name: "AFC Richmond · All fixtures"
    refresh: PT6H
    transparent: true
    fields: &fixture
      start: kickoff
      duration: "{{ duration | default: 105 }}"
      title: >-
        {% if status == 'postponed' %}POSTPONED: {% endif %}{% if competition == 'Cup' %}Cup: {% endif %}{{ home }} vs {{ away }}
      location: "{{ venue }}{% if city and city != empty %}, {{ city }}{% endif %}"
      description: preview
      url: "/fixtures/#{{ id }}"
      uid: id
      links:
        Tickets: tickets
        Live stream: stream
        Match report: report

  - path: calendar/home.ics
    source: data:fixtures.2026
    name: "AFC Richmond · Home games"
    refresh: PT6H
    transparent: true
    where: { home: AFC Richmond }
    fields: *fixture
```

What this does:

- **`start`, `duration`**: kickoff plus 105 minutes, or the match's own
  `duration` (150 for the cup tie). The match against Tottenham Hotspur has no time
  yet and appears as an all-day event on 29 August.
- **`title`**: `AFC Richmond vs Crystal Palace`, `Cup: AFC Richmond vs
  West Ham United` and `POSTPONED: Everton vs AFC Richmond`.
- **`location`**: `Nelson Road, Richmond`.
- **`url`**: every event links to the match on the fixtures page.
- **`uid: id`**: when the Tottenham Hotspur kickoff is announced, subscribers' all-day
  entry turns into a timed one instead of being duplicated.
- **`links`**: only the links a match actually has are added. The Crystal Palace
  event gets tickets and the match report; the away game at the Etihad gets the
  live stream.
- **`where`**: the home feed keeps only matches where `home` is
  `AFC Richmond`.
- **`transparent`**: matches don't show the subscriber as busy.

!!! tip "Long templates"
    YAML's folded style (`>-`) lets you write a long template on its own line
    without quoting it.

The resulting event for the season opener:

```text
BEGIN:VEVENT
UID:…@afc-richmond.example
DTSTAMP:20260801T120000Z
DTSTART:20260815T140000Z
DTEND:20260815T154500Z
SUMMARY:AFC Richmond vs Crystal Palace
LOCATION:Nelson Road\, Richmond
DESCRIPTION:Season opener at Nelson Road. Believe.\n\nTickets: https://tick
 ets.afc-richmond.example/2026-league-01\n\nMatch report: https://afc-richm
 ond.example/news/2026/08/15/crystal-palace-report/
URL:https://afc-richmond.example/fixtures/#2026-league-01
TRANSP:TRANSPARENT
END:VEVENT
```

(Commas are escaped and long lines are folded as the iCalendar format
requires; calendar apps display the text normally.)

## The women's team as a collection

The women's team has a page for every match, with a preview before and a
report after the game. Here the matches are a collection, and the page itself
is the event's link.

```yaml
# _config.yml
collections:
  women:
    output: true
    permalink: /women/matches/:name/
```

```markdown
---
# _women/2026-09-06-crystal-palace.md
title: AFC Richmond Women vs Crystal Palace Women
kickoff: "2026-09-06 14:00"
venue: Nelson Road
summary: Football is life!
---
Full preview and line-ups. Biscuits with the boss at 10 am …
```

```yaml
# _config.yml, added to ical_feeds
  - path: calendar/women.ics
    source: collection:women
    name: "AFC Richmond Women · Fixtures"
    transparent: true
    fields:
      start: kickoff
      duration: "{{ duration | default: 105 }}"
      location: venue
      description: summary
      # title, url and uid use the defaults: the page title and the page URL
```

## The subscription page

```liquid
<!-- fixtures.html -->
<h2>Never miss a match</h2>
<ul>
  <li><a href="{{ '/calendar/fixtures.ics' | absolute_url | webcal }}">All first-team fixtures</a></li>
  <li><a href="{{ '/calendar/home.ics' | absolute_url | webcal }}">Home games only</a></li>
  <li><a href="{{ '/calendar/women.ics' | absolute_url | webcal }}">Women's team</a></li>
</ul>

{% for match in site.data.fixtures['2026'] %}
  <article id="{{ match.id }}">
    <h3>{{ match.home }} vs {{ match.away }}</h3>
    <p>{{ match.kickoff }} · {{ match.venue }}</p>
  </article>
{% endfor %}
```

The `id` attribute of each article is the target of the event's `url`
(`/fixtures/#2026-league-01`), so a click in the calendar jumps straight to
the match.

## A new season

When the 2027 fixtures are published, add `_data/fixtures/2027.yml` and change
`source` to `data:fixtures.2027`. Because the IDs contain the season, events
from different seasons never collide.
