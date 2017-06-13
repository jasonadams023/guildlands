function createPersonalSubscription () {
  App['personal'] = App.cable.subscriptions.create ({
      channel: 'UnityPersonalChannel'
    },

    {
      received: function(data) {
        data.data = JSON.stringify(data.data);
        string = JSON.stringify(data);

        SendMessage("NetworkManager", "newMessage", string);
      }
    }
  );
}

function requestAction (subscription, action) {
  App[subscription].perform(action);
}

function requestActionWithData (action, data) {
  data = {data: data};
  App['personal'].perform(action, data);
}

// function requestDataWithId (action, id) {
//   data = {id: id};
//   App['personal'].perform(action, data);
// }

// function sendDataAsString(action, string) {
//   data = {string: string};
//   App['personal'].perform(action, data);
// }