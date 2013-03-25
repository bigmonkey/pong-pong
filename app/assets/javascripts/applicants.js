
$(document).ready(function () {
 $("#pLoanAmt").html("$300"); 
 $("#requested_amount").val(300);
// ************** slider of payloan application ****************//
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
// ***************** end sliders for prepaid card calculator blog version ************//



/*** calls validation script kept in browsers.js ****/

  $("#triageForm").validate();
});


