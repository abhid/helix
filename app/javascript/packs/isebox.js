$(document).on('turbolinks:load', function() {
  // Autocomplete
  $('#autocomplete').autocomplete({
    serviceUrl: '/search',
    paramName: 'q',
    deferRequestBy: 100,
    maxHeight: 700,
    groupBy: 'category',
    showNoSuggestionNotice: true,
    noSuggestionNotice: "No Results found",
    onSelect: function (suggestion) {
        Turbolinks.visit("/endpoints/"+suggestion.data["mac"]);
    },
    transformResult: function(response) {
      output = {suggestions: []}
      response = JSON.parse(response);
      _.each(response["sessions"].slice(0, 6), function(result) {
        output["suggestions"].push({data: {category: 'MAC Address', mac: result["mac"]}, value: result["mac"]});
      });
      _.each(response["sessions"].slice(0, 6), function(result) {
        if (result["ip_address"]) {
          output["suggestions"].push({data: {category: 'IP Address', mac: result["mac"]}, value: result["ip_address"]});
        }
      });
      _.each(response["sessions"].slice(0, 6), function(result) {
        if (result["username"] != result["mac"]) {
          output["suggestions"].push({data: {category: 'Username', mac: result["mac"]}, value: result["username"]});
        }
      });
      return output;
    }
  });

  // Timeago init
  timeago().render(document.querySelectorAll('.timeago'));

  // Clipboard.js init
  new ClipboardJS('.clipboard');

  // In-place editor
  // $(".editable").editable("update");
  $(".editable").each(function(idx, el) {
    $(el).editable($(el).data("update"), {
      id   : null,
      name : $(el).data("param"),
      method: 'PUT',
      intercept: function(json) {
        json = JSON.parse(json);
        return json[$(el).data("param")];
      }
    });
  });

  // Livelog play/pause button
  $(".logpause").on('click', function() {
    $(this).find("i").toggleClass("fa-play").toggleClass("fa-pause")
  })
});
