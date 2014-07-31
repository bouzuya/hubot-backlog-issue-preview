# Description
#   A Hubot script that display backlog issue
#
# Dependencies:
#   "q": "^1.0.1"
#
# Configuration:
#   HUBOT_BACKLOG_ISSUE_SPACE_ID
#   HUBOT_BACKLOG_ISSUE_API_KEY
#
# Commands:
#   PROJECT-nnn - display backlog issue
#
# Author:
#   bouzuya <m@bouzuya.net>
#
{Promise} = require 'q'

module.exports = (robot) ->

  robot.hear /[A-Z0-9_]+-\d+/, (res) ->
    spaceId = process.env.HUBOT_BACKLOG_ISSUE_SPACE_ID
    apiKey = process.env.HUBOT_BACKLOG_ISSUE_API_KEY
    baseUrl = 'https://' + spaceId + '.backlog.jp'

    issueKey = res.match[0].toUpperCase()

    get = (path, query={}) ->
      new Promise (resolve, reject) ->
        query.apiKey = apiKey
        res.http(baseUrl + path)
          .query query
          .get() (err, res, body) ->
            return reject(err) if err?
            resolve JSON.parse(body)

    get '/api/v2/issues/' + issueKey
      .then (issue) ->
        get '/api/v2/issues/' + issueKey + '/comments'
          .then (comments) ->
            prurl = null
            comments.some (comment) ->
              pattern = /^(https?:\/\/github.com\/\S*)\s*$/m
              match = comment.content.match pattern
              prurl = match[0] if match?
              match
            res.send """
              backlog-status: #{issue.summary}
              #{baseUrl}/view/#{issue.issueKey}
              #{prurl ? ''}
            """
