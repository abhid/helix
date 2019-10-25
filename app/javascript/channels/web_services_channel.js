import consumer from "./consumer"

// $(document).on('turbolinks:load', function() {
  consumer.subscriptions.create({channel: "WebServicesChannel"}, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log("ctx", this);
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      data = $(data).addClass("ajax_row");
      // console.dir(data);
      $("table#livelog tbody").prepend(data);
      timeago().render(document.querySelectorAll('.timeago'));
      $("table#livelog tr").slice(500).remove()
    }
  });
// });
