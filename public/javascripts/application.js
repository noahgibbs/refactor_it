// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function rfi_ajax_vote(url, data, onsuccess) {
  $.ajax({
    url: url,
    cache: false,
    data: data,
    dataType: "text",
    success: function(data, textStatus, xhr) {
      //eval(data);
      if(onsuccess) { onsuccess(); }
    },
    error: function(xhr, textStatus, errorThrown) {
      alert("You got an error when voting.  Is the server down?");
    },
    type: 'POST',
    timeout: 30000
  });
}

$(function() {
  $('.snippet_vote_button').click(function() {
    var snippet_id = parseInt(this.id.substr(12));
    var vote_type = $('.snippet_vote_selector_' + snippet_id +
                      ' option:selected').text();
    var url = '/snippets/vote';

    on_vote = function() {
      $('#snippet_vote_area_' + snippet_id).hide();
      $('#snippet_unvote_area_' + snippet_id).show();
      $('#snippet_vote_type_' + snippet_id).text(vote_type);
    };
    rfi_ajax_vote(url, { id: snippet_id, type: vote_type }, on_vote);
  });

  $('.snippet_unvote_button').click(function() {
    var snippet_id = parseInt(this.id.substr(14));
    var url = '/snippets/vote';

    on_vote = function() {
      $('#snippet_unvote_area_' + snippet_id).hide();
      $('#snippet_vote_area_' + snippet_id).show();
      $('#snippet_vote_type_' + snippet_id).text("");
    };
    rfi_ajax_vote(url, { id: snippet_id, type: "Unvote" }, on_vote);
  });

  $('.refactor_vote_button').click(function() {
    var refactor_id = parseInt(this.id.substr(12));
    var vote_type = $('.refactor_vote_selector_' + refactor_id +
                      ' option:selected').text();
    var url = '/refactors/vote';

    on_vote = function() {
      $('#refactor_vote_area_' + refactor_id).hide();
      $('#refactor_unvote_area_' + refactor_id).show();
      $('#refactor_vote_type_' + refactor_id).text(vote_type);
    };
    rfi_ajax_vote(url, { id: refactor_id, type: vote_type }, on_vote);
  });

  $('.refactor_unvote_button').click(function() {
    var refactor_id = parseInt(this.id.substr(14));
    var url = '/refactors/vote';

    on_vote = function() {
      $('#refactor_unvote_area_' + refactor_id).hide();
      $('#refactor_vote_area_' + refactor_id).show();
      $('#refactor_vote_type_' + refactor_id).text("");
    };
    rfi_ajax_vote(url, { id: refactor_id, type: "Unvote" }, on_vote);
  });
});
