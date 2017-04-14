function setupRoom (id, name) {
  createSubscription(id);
  $("#room-" + id + " #send").on('click', function() {
    chatSend(id, name);
  });
}

function createSubscription (id) {
  App['room-' + id] = App.cable.subscriptions.create ({
      channel: 'ChatMessagesChannel',
      roomId: id
    },

    {
      received: function(data) {
        $("#room-" + id + " #chat-messages").append(this.renderMessage(data));
      },

      renderMessage: function(data) {
        return "<p><b>" + data.username + ": </b>" + data.content + "</p>";
      }
    }
  );
}

function chatSend (id, name) {
  var content = $("#room-" + id + " #chat-send-content").val();
  App['room-' + id].send({username: name, content: content});
}


function goToRoom(id) {
  if ($("#active-room #room-" + id) == null) {
    $.get("/chat_rooms/" + id + "/edit", function(data) {
      $("#chat-rooms").append(data);
    });
  }

  $(".chat-room").addClass("hidden");
  $("#active-room #room-" + id).removeClass("hidden");
  $('#chat-nav a[href="#active-room"]').tab('show');
}

function chatControls(action, id) {
  if (action == 'create') {
    $.get("/chat_rooms/new", function(data) {
      $("#chat-control").empty();
      $("#chat-control").append(data);
    })
  } else if (action == "edit") {
    $.get("/chat_rooms/" + id + "/edit", function(data) {
      $("#chat-control").empty();
      $("#chat-control").append(data);
    })
  }

  $('#chat-nav a[href="#chat-control"').tab('show');
}