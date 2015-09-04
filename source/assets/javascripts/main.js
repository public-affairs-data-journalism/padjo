$(document).ready(function(){
  var myElement = document.querySelector("#header-headroom");
  // construct an instance of Headroom, passing the element
  var headroom  = new Headroom(myElement);
  // initialise
  headroom.init();

})
