# Description
#   A Hubot script that preview backlog issue
#
# Dependencies:
#   "q": "^1.0.1"
#
# Configuration:
#   HUBOT_BACKLOG_ISSUE_PREVIEW_SPACE_ID
#   HUBOT_BACKLOG_ISSUE_PREVIEW_API_KEY
#
# Commands:
#   PROJECT-nnn - preview backlog issue
#
# Author:
#   bouzuya <m@bouzuya.net>
#
{Promise} = require 'q'

module.exports = (robot) ->

  robot.hear /[A-Z0-9_]+-\d+/g, (res) ->
    spaceId = process.env.HUBOT_BACKLOG_ISSUE_PREVIEW_SPACE_ID
    apiKey = process.env.HUBOT_BACKLOG_ISSUE_PREVIEW_API_KEY
    baseUrl = 'https://' + spaceId + '.backlog.jp'

    get = (path, query={}) ->
      new Promise (resolve, reject) ->
        query.apiKey = apiKey
        res.http(baseUrl + path)
          .query query
          .get() (err, _, body) ->
            return reject(err) if err?
            resolve JSON.parse(body)

    getIssueMessage = (issueKey) ->
      issue = null
      get '/api/v2/issues/' + issueKey
        .then (i) ->
          issue = i
          get '/api/v2/issues/' + issueKey + '/comments'
        .then (comments) ->
          prurl = null
          comments.some (comment) ->
            pattern = /^(https?:\/\/github.com\/\S*)\s*$/m
            match = comment.content.match pattern
            prurl = match[0] if match?
            match
          """
            #{issue.summary}
              #{baseUrl}/view/#{issue.issueKey}
              #{prurl ? ''}
          """

    messages = []
    res.match.reduce((promise, issueKey) ->
      promise
        .then ->
          getIssueMessage issueKey
        .then (message) ->
          messages.push message
    , Promise.resolve()).then ->
      res.send 'backlog-issue-preview:\n' + messages.join('\n')
