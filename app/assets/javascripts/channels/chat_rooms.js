function setupRoom (id) {
  createSubscription(id);
  $("#room-" + id + " #send").on('click', function() {
    chatSend(id);
  });
}

function createSubscription (id) {
  App['room-' + id] = App.cable.subscriptions.create ({
      channel: 'ChatMessagesChannel',
      roomId: id,
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

function chatSend (id) {
  var content = $("#room-" + id + " #chat-send-content").val();
  App['room-' + id].send({content: content});
}

function goToRoom(id) {
  if ($("#active-room #room-" + id)[0] == null) {
    chatControls("edit", id);
  } else {
    $(".chat-room").addClass("hidden");
    $("#active-room #room-" + id).removeClass("hidden");
    $('#chat-nav a[href="#active-room"]').tab('show');
  }
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

function addRoom (html, type) {
  $("#chat-rooms").append(html);
  var chatName = $("#room-" + roomId + " #room-name")[0].innerHTML;
  var insert = '<a onclick="goToRoom(' + roomId + ')">' + chatName + '</a><hr>';
  var list;

  if (type == "create") {
    list = $(".rooms-list");
  } else if (type == "join") {
    list = $("#subscribed-rooms .rooms-list");
  }

  list.append(insert);
  goToRoom(roomId);
}
