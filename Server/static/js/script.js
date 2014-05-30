function validate(evt) {
  var theEvent = evt || window.event;
  var key = theEvent.keyCode || theEvent.which;
  key = String.fromCharCode( key );
  var regex = /[0-9]|\./;
  if( !regex.test(key) ) {
    theEvent.returnValue = false;
    $('.idinput').removeClass('animated shake');
    setTimeout(function(){
	    $('.idinput').addClass('animated shake');
    }, 1)
    if(theEvent.preventDefault) theEvent.preventDefault();
  }
}
$(document).ready(function(){
    $(".done").hide();
    $("button").click(function(){
      var colours = getColor();
    	$.post("/spray",{'id': parseInt($(".idinput input").val()),'spray': { red:colours.r, green: colours.g, blue: colours.b, special: 0, time: 10000, misc:"hello" } },function(data){
    		console.log(data);
    	});
    });
    $('#picker').colpick({
      flat:true,
      layout:'hex',
      submit:0
    });
    $("#switch").on('change',toggleSpray);
});

function toggleSpray(){
  $.post("/togglespray",{},function(data){
    console.log(data);
  });
}

function getColor(){ 
    return $.colpick.hsbToRgb($('#' + $('#picker').data('colpickId') ).data('colpick').color); 
}
var socket = io.connect();
socket.on('toggledspray', function (data) {
  var checkBox=$("#switch");
  checkBox.prop("checked", !checkBox.prop("checked"));
  console.log("dksal");
});

var asdf = getColor();
