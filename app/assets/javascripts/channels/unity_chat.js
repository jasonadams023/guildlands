function createChatSubscription (id) {
  App['room-' + id] = App.cable.subscriptions.create ({
      channel: 'ChatMessagesChannel',
      roomId: id,
    },

    {
      received: function(data) {
        data['details'] = {subscription: 'room-' + id};
        var string = JSON.stringify(data);
        sendMessage("NetworkManager", "newMessage", string);
      },
    }
  );
},

function chatSend (subscription, content) {
  var subscriptionString = Pointer_stringify(subscription);
  var contentString = Pointer_stringify(content);
  App[subscriptionString].send({content: contentString});
}