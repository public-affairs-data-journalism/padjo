// code for highlighting course info
// Put on hold for now: TODO
// $(function(){
//   $(".course-schedule .lecture").each(function(){
//     console.log($(this).find(".title").text());
//   });
// })


// this should be in its own file. whatev
$(function(){
  $("video").each(function(){
    var src = $(this).children("source[type='video/mp4']").attr('src');
    $(this).after("<a href=\""+ src  + "\">Download (right-click) this video</a>");
  });
});
