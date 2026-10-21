# Dates, times and time zones

## All-day and timed events

What the start value looks like decides the kind of event:

| Start value                     | Event                                |
| ------------------------------- | ------------------------------------ |
| `"2026-09-05"`                  | all-day event                        |
| `"2026-08-15 15:00"`            | timed event in the site's time zone  |
| `"2026-08-15T15:00:00+01:00"`   | timed event at that UTC offset       |

This fits football well: when the fixture list comes out, often only the
weekend of a match is known. Enter just the date and the match shows up as an
all-day event. Once the kickoff time is announced, add it. With a
[stable `uid`](subscribing.md#stable-event-ids), calendars turn the all-day
event into a timed one instead of adding a second entry.

```yaml
# Kickoff time not announced yet
- id: 2026-league-07
  kickoff: "2026-10-03"
  home: AFC Richmond
  away: Tottenham Hotspur

# Later: moved to Sunday for TV
- id: 2026-league-07
  kickoff: "2026-10-04 13:30"
  home: AFC Richmond
  away: Tottenham Hotspur
```

## End and duration

The end of an event is determined in this order:

1. the `end` field, if the item has one;
2. for timed events: start plus `duration` minutes;
3. for timed events without a duration: start plus 60 minutes;
4. for all-day events: the next day.

```yaml
fields:
  duration: "{{ duration | default: 105 }}"
```

```yaml
# A cup tie that might go to extra time and penalties
- id: 2026-cup-r2
  kickoff: "2026-09-23 19:45"
  duration: 150
  home: AFC Richmond
  away: West Ham United
```

An all-day event that spans several days, like the Richmond Kids Cup weekend,
needs an `end`. As in iCalendar, the end of an all-day event is *exclusive*:
the day after the last day.

```yaml
- id: 2026-u12-tournament
  kickoff: "2026-07-11"
  end: "2026-07-13"        # Saturday and Sunday
  title: Richmond Kids Cup (U12)
```

## The `all_day` option

`all_day` changes how start and end are interpreted:

- `auto` (default): plain dates and times at exactly midnight are all-day,
  everything else is timed.
- `true`: every event is all-day; the time is ignored.
- `false`: every event is timed; plain dates start at midnight.

Midnight counts as all-day in `auto` mode because Jekyll reads `date: 2026-09-05`
in front matter as a time at 00:00. If you have a real event at midnight, use
`all_day: false` for that feed.

## Time zones

!!! warning "Quote date-times, or include the offset"
    YAML has its own date-time type. An unquoted value **with seconds and
    without an offset**, like `2026-08-15 15:00:00`, is read as **UTC**. For a
    match in London in summer, that puts it an hour late in everyone's calendar.

    Safe ways to write a kickoff time:

    ```yaml
    kickoff: "2026-08-15 15:00"            # quoted: site time zone
    kickoff: "2026-08-15 15:00:00"         # quoted: site time zone
    kickoff: 2026-08-15 15:00              # no seconds: not a YAML timestamp, site time zone
    kickoff: 2026-08-15T15:00:00+01:00     # explicit offset
    ```

Times without an offset are interpreted in the site's time zone, which Jekyll
takes from `timezone` in `_config.yml`. Without it, the time zone of the
machine that builds the site is used, which on CI servers is usually UTC. So
set it:

```yaml
# _config.yml
timezone: Europe/London
```

The plugin writes all timed events in UTC (`DTSTART:20260815T140000Z`). Calendar
apps convert this to each viewer's local time, so a fan in another country
sees the kickoff in their own time.

The feed's `timezone` option (default: the site's `timezone`) is only written
as an `X-WR-TIMEZONE` hint for calendar apps. It does not change how times are
read.
