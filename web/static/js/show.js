var $ = require('jquery');
window.jQuery = require('jquery');

require( "blueimp-file-upload/js/vendor/jquery.ui.widget.js")
require( "blueimp-file-upload/js/jquery.iframe-transport.js")
require( "blueimp-file-upload/js/jquery.fileupload.js")
require( "materialize-css/dist/js/materialize.js")
if(jQuery){
  //materialbox = jQuery.materialbox;
}
$(function(){
  console.log("aa");
  // $('.materialboxed').materialbox();
  $('#fileupload').fileupload({
        url: '/photos',
        dataType: 'json',
        done: function (e, data) {
            $.each(data.result.files, function (index, file) {
                $('<p/>').text(file.name).appendTo(document.body);
            });
        }  
  })
})
