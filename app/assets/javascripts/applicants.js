// ************** slider of payloan application ****************//
$(document).ready(function () {

    $("#pSliderLoanAmt").slider({
        value: 300,
        min: 100,
        max: 500,
        step: 100,
        slide: function (event, ui){
        //  console.log('ui value is ', ui.value);
    		//console.log('ui value equals 500 is ', (ui.value==500));
	      if (ui.value==500) {
	        $("#pLoanAmt").html("$500-$1000");  
	      }  
	      else {
	        $("#pLoanAmt").html("$" + ui.value);  
	      }

      	$("#requested_amount").val(ui.value);    


        },
    });

});
// ***************** end sliders for prepaid card calculator blog version ************//


