# hubot-backlog-issue

A Hubot script that display backlog issue

## Installation

    $ npm install git://github.com/bouzuya/hubot-backlog-issue.git

or

    $ # TAG is the package version you need.
    $ npm install 'git://github.com/bouzuya/hubot-backlog-issue.git#TAG'

## Sample Interaction

    bouzuya> HUBOT-123
    hubot> backlog-status: issue title
    https://space.backlog.jp/view/HUBOT-123
    https://github.com/hitoridokusho/hibot/pull/4

See [`src/scripts/backlog-issue.coffee`][script] for full documentation.

## License

MIT

## Development

### Run test

    $ npm test

### Run robot

    $ npm run robot


## Badges

[![Build Status][travis-status]][travis]

[script]: src/scripts/backlog-issue.coffee
[travis]: https://travis-ci.org/bouzuya/hubot-backlog-issue
[travis-status]: https://travis-ci.org/bouzuya/hubot-backlog-issue.svg?branch=master
