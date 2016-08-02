var $ = require('jquery');
window.jQuery = require('jquery');

require( "blueimp-file-upload/js/vendor/jquery.ui.widget.js")
require( "blueimp-load-image/js/load-image.js")
require( "blueimp-load-image/js/load-image.all.min.js")
require( "blueimp-canvas-to-blob/js/canvas-to-blob.js")
//require( "blueimp-canvas-to-blob/js/canvas-to-blob.min.js")
require( "blueimp-file-upload/js/jquery.iframe-transport.js")
require( "blueimp-file-upload/js/jquery.fileupload.js")
require( "blueimp-file-upload/js/jquery.fileupload-process.js")
require( "blueimp-file-upload/js/jquery.fileupload-image.js")
require( "blueimp-file-upload/js/jquery.fileupload-validate.js")
require( "materialize-css/dist/js/materialize.js")
if(jQuery){
  //materialbox = jQuery.materialbox;
}
$(function(){
  $('#post-form').submit(function() {
        // DO STUFF
    var ids = $(".delete-photo").map(function(){
      return $(this).attr("data-id");
    }).get().join(",");
    $("#photo-ids").val(ids); 
    return true; // return false to cancel form action
  });
  //console.log("aa");
  $("body").delegate(".delete-photo","click",function(e){
    e.preventDefault();
    //console.log($(this))
    var id = $(this).attr("data-id");
    //console.log("bbbccc"+ id);
    $.ajax({
      url: "/photos/"+id,
      method: "DELETE",
      success: function(data){
        console.log(data);
      }
    });
    $(this).parent().empty();
  })
  // $('.materialboxed').materialbox();
  /**
  $('#fileupload').fileupload({
        url: '/photos',
        dataType: 'json',
        done: function (e, data) {
            console.log(data);
            $.each(data.result.files, function (index, file) {
                console.log(file);
                console.log(file.name);
                $('<p/>').text(file.name).appendTo(document.body);
            });
        },  
        progress: function (e, data) {
                if (e.isDefaultPrevented()) {
                    return false;
                }
                var progress = Math.floor(data.loaded / data.total * 100);
                console.log("progress:" + progress);
                if (data.context) {
                    data.context.each(function () {
                        $(this).find('.progress')
                            .attr('aria-valuenow', progress)
                            .children().first().css(
                                'width',
                                progress + '%'
                            );
                    });
                }
          }
   

  })**/
   var url = '/photos';
   $('#fileupload').fileupload({
        url: url,
        dataType: 'json',
        autoUpload: true,
        acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
        maxFileSize: 999000,
        // Enable image resizing, except for Android and Opera,
        // which actually support image resizing, but fail to
        // send Blob objects via XHR requests:
        disableImageResize: /Android(?!.*Chrome)|Opera/
            .test(window.navigator.userAgent),
        previewMaxWidth: 100,
        previewMaxHeight: 100,
        previewCrop: true
    }).on('fileuploadadd', function (e, data) {
        $("#progress").removeClass("hide")
        data.context = $('<div/>').appendTo('#files');
        $.each(data.files, function (index, file) {
            var node = $('<p/>')
                    .append($('<span/>').text(file.name));
            /**
            if (!index) {
                node
                    .append('<br>')
                    .append(uploadButton.clone(true).data(data));
            }**/
            node.appendTo(data.context);
        });
    }).on('fileuploadprocessalways', function (e, data) {
        var index = data.index,
            file = data.files[index],
            node = $(data.context.children()[index]);
        if (file.preview) {
            node
                .prepend('<br>')
                .prepend(file.preview);
        }
        if (file.error) {
            node
                .append('<br>')
                .append($('<span class="text-danger"/>').text(file.error));
        }
        if (index + 1 === data.files.length) {
            data.context.find('button')
                .text('Upload')
                .prop('disabled', !!data.files.error);
        }
    }).on('fileuploadprogressall', function (e, data) {
        var progress = parseInt(data.loaded / data.total * 100, 10);
        $('#progress .determinate').css(
            'width',
            progress + '%'
        );
        if(progress >= 100){
          $("#progress").addClass("hide")
        }
    }).on('fileuploaddone', function (e, data) {
        $.each(data.result.files, function (index, file) {
            console.log(file);
            if (file.url) {
                var link = $('<a>')
                    .attr('target', '_blank')
                    .prop('href', file.url);
                $(data.context.children()[index])
                    .wrap(link);
                var delLink = $('<a>').attr('class','delete-photo btn-flat')
                   .attr('data-url',file.url)
                   .attr('data-id', file.id)
                   .prop('href', file.url)
                   .text('删除');
                delLink.appendTo(data.context)
            } else if (file.error) {
                var error = $('<span class="text-danger"/>').text(file.error);
                $(data.context.children()[index])
                    .append('<br>')
                    .append(error);
            }
        });
    }).on('fileuploadfail', function (e, data) {
        $.each(data.files, function (index) {
            var error = $('<span class="text-danger"/>').text('文件上传失败！');
            $(data.context.children()[index])
                .append('<br>')
                .append(error);
        });
    }).prop('disabled', !$.support.fileInput)
        .parent().addClass($.support.fileInput ? undefined : 'disabled');
});
