function createPersonalSubscription () {
  App['personal'] = App.cable.subscriptions.create ({
      channel: 'UnityPersonalChannel',
    },

    {
      received: function(data) {
        data['details'] = {subscription: 'personal'};
        var string = JSON.stringify(data);
        sendMessage("NetworkManager", "newMessage", string);
      },

      doAction: function(action) {
        perform(action);
      }
    }
  );
}

function requestAction (subscription, action) {
  var subscriptionString = Pointer_stringify(subscription);
  var actionString = Pointer_stringify(action);
  App[subscriptionString].doAction(actionString);
}