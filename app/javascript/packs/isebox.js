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
});
