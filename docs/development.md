# Development

## Running the tests

```sh
bundle install
bundle exec rake test
```

Each test builds a throwaway Jekyll site in a temporary directory and checks
the generated `.ics` file.

## Building the documentation

The documentation is built with [MkDocs](https://www.mkdocs.org/) and the
[Material](https://squidfunk.github.io/mkdocs-material/) theme and hosted on
[Read the Docs](https://jekyll-ical-feed.readthedocs.io/).

```sh
python3 -m venv .venv
.venv/bin/pip install -r docs/requirements.txt
.venv/bin/mkdocs serve
```

Then open <http://127.0.0.1:8000/>.

## Releasing

1. Bump `JekyllIcalFeed::VERSION` in `lib/jekyll-ical-feed/version.rb` and
   merge the change into `main`.
2. Tag the release and push the tag:

    ```sh
    git tag v0.2.0
    git push origin v0.2.0
    ```

3. The *Release* workflow builds the gem and pushes it to
   [RubyGems.org](https://rubygems.org/gems/jekyll-ical-feed) using trusted
   publishing.
