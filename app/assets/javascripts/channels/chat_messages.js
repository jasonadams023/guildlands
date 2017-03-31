App.messages = App.cable.subscriptions.create('ChatMessagesChannel', {  
  received: function(data) {
    $("#chat-messages").removeClass('hidden')
    return $('#chat-messages').append(this.renderMessage(data));
  },

  renderMessage: function(data) {
    return "<p> <b>" + data.username + ": </b>" + data.content + "</p>";
  }
});