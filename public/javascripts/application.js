// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$('.vote_button form.button-to').submit({
  var url = this.attr('action');
  var name = this.attr('name');
  var vote_div = this.closest(".vote_button");
  var selector = vote_div.find("select");

  $.ajax({
    url: url,
    data: { type: selector.attr("value") }, /* query string */
    dataType: "script",
    success: function(data, textStatus, xhr) {
      alert("Successfully got back script w/ data (" + data + ") from vote!");
    },
    error: function(xhr, textStatus, errorThrown) {
      alert("Error submitting vote: " + textStatus + " / " + errorThrown);
    },
    type: 'post',
    timeout: 10000  /* Milliseconds */
  });
  return false;
});
