var $ = require('jquery');
window.jQuery = require('jquery');

$(function(){
  
  var pageUrl = encodeURIComponent(window.location.href); 
  alert(pageUrl)
  var signUrl = "/sign?url="+pageUrl;
  
  $.get(signUrl,function(data){
    console.log(data);
    wx.config({
      debug: true,
      appId: data.appid,
      timestamp: data.timestamp,
      nonceStr: data.noncestr,
      signature: data.signature,
      jsApiList: [
        // 所有要调用的 API 都要加到这个列表中
        'onMenuShareTimeline',
        'onMenuShareAppMessage',
        'onMenuShareQQ'
      ]
    });

    wx.onMenuShareAppMessage({
      title: 'hah', // 分享标题
      desc: 'woshi', // 分享描述
      link: window.location, // 分享链接
      imgUrl: '', // 分享图标
      type: '', // 分享类型,music、video或link，不填默认为link
      dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
      success: function () { 
          // 用户确认分享后执行的回调函数
        alert("ffff");
      },
      cancel: function () { 
          // 用户取消分享后执行的回调函数
      }
    });

  })
})

