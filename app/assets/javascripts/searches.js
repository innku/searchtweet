$(document).ready(function(){
  $('form#new_search').bind('ajax:success', function(e, data,status, xhr){
    $('#searches').append(search_template(data));
    fetch(data.id);
  });
});

function search_template(search){
  string = "<div id='search-"+ search.id +"' class='search'>";
  string += "<h2>"+ search.query +"</h2>";
  string += "<div class='tweets'><div class='loading'>"
  string += "<img src='/assets/loader.gif' /></div></div>";
  string += "</div>";
  return string;
}

function fetch(fragment_id) {
  $.ajax({
    url: "/searches/" + fragment_id,
    success: function(data, status, req) {
      if(req.status == 204) {
        setTimeout(function() { fetch(fragment_id) }, 500);
        return;
      }
      $('#search-' + fragment_id + " .tweets").html(data);
    },
    error: function(request, status) {
      console.log(status);
    }
  });
}