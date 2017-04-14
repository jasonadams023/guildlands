function setupRoom (id, name) {
  createSubscription(id);
  $("#room-" + id + " #send").click(chatSend(id, name));
  swapHidden(id);
}

function createSubscription (id) {
  App['room-' + id] = App.cable.subscriptions.create ({
      channel: 'ChatMessagesChannel',
      roomId: id
    },

    {
      received: function(data) {
        return this.$("#" + id + " #chat-messages").append(this.renderMessage(data));
      },

      renderMessage: function(data) {
        return "<p> <b>" + data.username + ": </b>" + data.content + "</p>";
      }
    }
  );
}

function chatSend (id, name) {
  var content = $("#room-" + id + " #chat-send-content").val();
  App['room-' + id].send({username: name, content: content});
}

function swapHidden (id) {
  $("#room-" + id + " #subscribe").addClass("hidden");
  $("#room-" + id + "message-form").removeClass("hidden");
}