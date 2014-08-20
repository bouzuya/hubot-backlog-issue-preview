{Robot, TextMessage} = require 'hubot'
assert = require 'power-assert'
path = require 'path'
sinon = require 'sinon'

describe 'backlog-issue-preview', ->
  beforeEach (done) ->
    @sinon = sinon.sandbox.create()
    @robot = new Robot(path.resolve(__dirname, '..'), 'shell', false, 'hubot')
    @robot.adapter.on 'connected', =>
      @robot.load path.resolve(__dirname, '../../src/scripts')
      done()
    @robot.run()

  afterEach (done) ->
    @robot.brain.on 'close', =>
      @sinon.restore()
      done()
    @robot.shutdown()

  describe 'listeners[0].regex', ->
    beforeEach ->
      @callback = @sinon.spy()
      @robot.listeners[0].callback = @callback

    describe 'receive "HUBOT-123"', ->
      beforeEach ->
        sender = { id: 'bouzuya', room: 'hitoridokusho' }
        message = 'HUBOT-123'
        @robot.adapter.receive new TextMessage(sender, message)

      it 'calls *issue* with "HUBOT-123"', ->
        assert @callback.callCount is 1
        assert @callback.firstCall.args[0].match.length is 1
        assert @callback.firstCall.args[0].match[0] is 'HUBOT-123'

    describe 'receive "??? HUBOT-123 ???"', ->
      beforeEach ->
        sender = { id: 'bouzuya', room: 'hitoridokusho' }
        message = '??? HUBOT-123 ???'
        @robot.adapter.receive new TextMessage(sender, message)

      it 'calls *issue* with "HUBOT-123"', ->
        assert @callback.callCount is 1
        assert @callback.firstCall.args[0].match.length is 1
        assert @callback.firstCall.args[0].match[0] is 'HUBOT-123'

    describe 'receive "??? hubot-123 ???"', ->
      beforeEach ->
        sender = { id: 'bouzuya', room: 'hitoridokusho' }
        message = '??? hubot-123 ???'
        @robot.adapter.receive new TextMessage(sender, message)

      it 'does not call', ->
        assert @callback.callCount is 0

    describe 'receive "??? HUBOT- ???"', ->
      beforeEach ->
        sender = { id: 'bouzuya', room: 'hitoridokusho' }
        message = '??? HUBOT- ???'
        @robot.adapter.receive new TextMessage(sender, message)

      it 'does not call', ->
        assert @callback.callCount is 0

    describe 'receive "??? HUBOT_123-456 ???"', ->
      beforeEach ->
        sender = { id: 'bouzuya', room: 'hitoridokusho' }
        message = '??? HUBOT_123-456 ???'
        @robot.adapter.receive new TextMessage(sender, message)

      it 'calls *issue* with "HUBOT_123-456"', ->
        assert @callback.callCount is 1
        assert @callback.firstCall.args[0].match.length is 1
        assert @callback.firstCall.args[0].match[0] is 'HUBOT_123-456'

    describe 'receive "??? HUBOT-123 ??? HUBOT-124"', ->
      beforeEach ->
        sender = { id: 'bouzuya', room: 'hitoridokusho' }
        message = '??? HUBOT-123 ??? HUBOT-124'
        @robot.adapter.receive new TextMessage(sender, message)

      it 'calls *issue* with "HUBOT-123" and "HUBOT-124"', ->
        assert @callback.callCount is 1
        assert @callback.firstCall.args[0].match.length is 2
        assert @callback.firstCall.args[0].match[0] is 'HUBOT-123'
        assert @callback.firstCall.args[0].match[1] is 'HUBOT-124'

    describe 'receive "??? HUBOT-123 \\n HUBOT-124"', ->
      beforeEach ->
        sender = { id: 'bouzuya', room: 'hitoridokusho' }
        message = '??? HUBOT-123 \n HUBOT-124'
        @robot.adapter.receive new TextMessage(sender, message)

      it 'calls *issue* with "HUBOT-123" and "HUBOT-124"', ->
        assert @callback.callCount is 1
        assert @callback.firstCall.args[0].match.length is 2
        assert @callback.firstCall.args[0].match[0] is 'HUBOT-123'
        assert @callback.firstCall.args[0].match[1] is 'HUBOT-124'

  describe 'listeners[0].callback', ->
    beforeEach ->
      @issue = @robot.listeners[0].callback

    describe 'receive "HUBOT-123 ... HUBOT-456"', ->
      beforeEach (done) ->
        @spaceId = process.env.HUBOT_BACKLOG_ISSUE_PREVIEW_SPACE_ID
        @apiKey = process.env.HUBOT_BACKLOG_ISSUE_PREVIEW_API_KEY
        process.env.HUBOT_BACKLOG_ISSUE_PREVIEW_SPACE_ID = 'space'
        process.env.HUBOT_BACKLOG_ISSUE_PREVIEW_API_KEY = 'xxx'
        @send = @sinon.spy()
        @http = @sinon.stub()
        getIssue123 = JSON.stringify
          issueKey: 'HUBOT-123'
          summary: 'SUMMARY'
        getComments123 = JSON.stringify [
          { content: 'aiueo' }
          { content: 'https://github.com/hitoridokusho/hibot/pull/4' }
        ]
        getIssue456 = JSON.stringify
          issueKey: 'HUBOT-456'
          summary: 'SUMMARY456'
        getComments456 = JSON.stringify [
          { content: 'https://github.com/hitoridokusho/hibot/pull/5' }
          { content: 'aiueo' }
        ]
        @http
          .withArgs('https://space.backlog.jp/api/v2/issues/HUBOT-123')
          .returns(query: (-> get: (-> ((cb) -> cb(null, {}, getIssue123)))))
        @http
          .withArgs('https://space.backlog.jp/api/v2/issues/HUBOT-123/comments')
          .returns(query: (-> get: (-> ((cb) -> cb(null, {}, getComments123)))))
        @http
          .withArgs('https://space.backlog.jp/api/v2/issues/HUBOT-456')
          .returns(query: (-> get: (-> ((cb) -> cb(null, {}, getIssue456)))))
        @http
          .withArgs('https://space.backlog.jp/api/v2/issues/HUBOT-456/comments')
          .returns(query: (-> get: (-> ((cb) -> cb(null, {}, getComments456)))))
        @issue
          match: ['HUBOT-123', 'HUBOT-456']
          send: @send
          http: @http
        setTimeout ->
          done()
        , 10

      afterEach ->
        process.env.HUBOT_BACKLOG_ISSUE_PREVIEW_SPACE_ID = @spaceId if @spaceId?
        process.env.HUBOT_BACKLOG_ISSUE_PREVIEW_API_KEY = @apiKey if @apiKey?

      it 'send "backlog-issue-preview:\\n SUMMARY\\nURL\\nPR URL\\n..."', ->
        assert @send.callCount is 1
        assert @send.firstCall.args[0] is '''
        backlog-issue-preview:
        SUMMARY
          https://space.backlog.jp/view/HUBOT-123
          https://github.com/hitoridokusho/hibot/pull/4
        SUMMARY456
          https://space.backlog.jp/view/HUBOT-456
          https://github.com/hitoridokusho/hibot/pull/5
        '''
