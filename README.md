# hubot-backlog-issue-preview

A Hubot script that preview backlog issue

![](http://img.f.hatena.ne.jp/images/fotolife/b/bouzuya/20140820/20140820224746.gif)

## Installation

    $ npm install git://github.com/bouzuya/hubot-backlog-issue-preview.git

or

    $ # TAG is the package version you need.
    $ npm install 'git://github.com/bouzuya/hubot-backlog-issue-preview.git#TAG'

## Example

    bouzuya> HUBOT-123 HUBOT-124
    hubot> backlog-issue-preview:
    title of issue 123
      https://space.backlog.jp/view/HUBOT-123
      https://github.com/hitoridokusho/hibot/pull/4
    title of issue 124
      https://space.backlog.jp/view/HUBOT-124
      https://github.com/hitoridokusho/hibot/pull/5

## Configuration

See [`src/scripts/backlog-issue-preview.coffee`][script] for full documentation.

## Development

### Run test

    $ npm test

### Run robot

    $ npm run robot

## License

[MIT](LICENSE)

## Author

[bouzuya][user] &lt;[m@bouzuya.net][mail]&gt; ([http://bouzuya.net][url])

## Badges

[![Build Status][travis-badge]][travis]
[![Dependencies status][david-dm-badge]][david-dm]

[script]: src/scripts/backlog-issue-preview.coffee
[travis]: https://travis-ci.org/bouzuya/hubot-backlog-issue-preview
[travis-badge]: https://travis-ci.org/bouzuya/hubot-backlog-issue-preview.svg?branch=master
[david-dm]: https://david-dm.org/bouzuya/hubot-backlog-issue-preview
[david-dm-badge]: https://david-dm.org/bouzuya/hubot-backlog-issue-preview.png
[user]: https://github.com/bouzuya
[mail]: mailto:m@bouzuya.net
[url]: http://bouzuya.net
