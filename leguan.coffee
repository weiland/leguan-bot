class Base
  log: (mes...) -> console.log(mes.join(', '))
  err: (mes...) -> console.error('Error: ', mes.join(', '))

class Leguan extends Base
  config       : require './config'
  twitter      : false
  stream       : false
  isValid      : false # aka isInvalid (no twitter obj)
  isActive     : true # aka isNotStreaming (twitter stream)
  currentTweet : false

  constructor: ->
    if process.mainModule.filename.indexOf('leguan.coffee') > 0
      console.error('dont run the leguan.coffee. run the app.coffee instead!')
      process.kill()
    @twitter = new (require('twit'))(@config.twitter)
    @config = @config.rest # dunno whether this is a good idea
    @isValid = true if @twitter

    @log 'Hello Leguan'

  streaming: ->
    if @isActive and !@stream
      @log('Leguan starts streaming \o/')
      @stream = @twitter.stream 'statuses/filter',
        track: @config.trackingWords
      @isActive = false
      @

  findTweets: =>
    return unless @isActive or @isValid
    @log('looking for tweets');
    @stream.on 'tweet', (tweet) =>
      @log("found a tweet: '#{tweet.text}' by #{tweet.user.screen_name}")
      @currentTweet = tweet
      @retweet() if @isValidTweet()

  postTweet: (text) ->
    if (text.length > 140)
      return new Error('The text is too long for the Leguan.')

    @twitter.post 'statuses/update',
      status: text
    ,(err, data, response) =>
      return @err('Error while posting a tweet: ', err) if err
      @log('Tweet successfully posted: ', data)

  retweet: ->
    tweetID = @currentTweet?.id_str # needs to be a string
    #console.log(tweetID.toString())
    @twitter.post 'statuses/retweet/:id',
      id: tweetID
      language: 'de'
    , (err, data, response) =>
      return console.error('Error while retweeting: ', err) if err and err.length
      @log 'retweeted '

  isValidTweet: ->
    false if @currentTweet?.user.id == 552954416 # prevent own retweets
    true

  isError: (res) ->
    true if res instanceof Error
    false

module.exports = new Leguan
