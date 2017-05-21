function createPersonalSubscription () {
  App['personal'] = App.cable.subscriptions.create ({
      channel: 'UnityPersonalChannel',
    },

    {
      received: function(data) {
        alert(action);
        data['details'] = {subscription: 'personal'};
        var string = JSON.stringify(data);
        SendMessage("NetworkManager", "newMessage", string);
      },

      doAction: function(action) {
        this.perform(action);
      }
    }
  );
}

function requestAction (subscription, action) {
  App[subscription].doAction(action);
}