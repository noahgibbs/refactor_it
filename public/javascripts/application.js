// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
  $('.snippet_vote_button').click(function() {
    var snippet_id = parseInt(this.id.substr(12));
    var vote_type = $('.snippet_vote_selector_' + snippet_id +
                      ' option:selected').text();
    var url = '/snippets/vote';

    $.ajax({
      url: url,
      cache: false,
      data: { type: vote_type, id: snippet_id },
      dataType: "text",
      success: function(data, textStatus, xhr) {
        alert("Success!");
      },
      error: function(xhr, textStatus, errorThrown) {
        alert("Error: " + textStatus + " thrown: " + errorThrown);
      },
      type: 'POST',
      timeout: 30000
    });
  });
});
