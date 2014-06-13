config  = require './config'
twitter = new (require('twit'))(config.twitter)

tweetID =
tweetID = {id: "477419496547028992"}
console.log('rewtweet tweet ' + tweetID)
twitter.post 'statuses/retweet/:id', tweetID, (err, data, response) =>
  console.log(err, data)
