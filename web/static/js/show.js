var $ = require('jquery');
window.jQuery = require('jquery');
//require( "materialize-css/dist/js/materialize.js")
var materialbox;
if(jQuery){
  materialbox = jQuery.materialbox;
}
$(function(){
  console.log("aa");
  $('.materialboxed').materialbox();
})
