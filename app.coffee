log = (mes) -> console.log(mes)
err = (mes) -> console.error('Error: ', mes)

leguan = require './leguan'

# leguan.postTweet ':)'
leguan.streaming().findTweets()
