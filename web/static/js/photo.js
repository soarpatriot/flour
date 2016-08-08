var $ = require('jquery');
window.jQuery = require('jquery');

require("blueimp-gallery/js/blueimp-gallery.js")
require("blueimp-gallery/js/jquery.blueimp-gallery.js")
//require("materialize-css/js/carousel.js")
require( "materialize-css/dist/js/materialize.js")

$(function(){
  var gallery = $('#blueimp-gallery').data('gallery'); 
  var id = $("#post-id").val(); 
  var flowerUrl = "/posts/"+id+"/flower"; 
  $("#flower-link").click(function(){
    $('#flower-link').addClass('animated tada');
    $.get(flowerUrl,function(result){
      //Materialize.toast('I am a toast!', 4000); 
      $('#flower-count').addClass('animated bounce');
      $("#flower-count").text(result.count);
    }) 
  })
})
