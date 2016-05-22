$(document).ready(function() {

	
	$("#new_account, #edit_account").submit(function(e){
		// e.preventDefault();
		console.log('hi');
		Stripe.setPublishableKey($("input[name='stripe_key']").val())
		console.log('hat');
    Stripe.card.createToken({
      number: $('#cardNumber').val(),
      cvc: $('#CVC').val(),
      exp_month: $('#expMonth').val(),
      exp_year: $('#expYear').val(),
    }, stripeResponseHandler);
	});

	function stripeResponseHandler(status, response) {
    document.getElementById("payments_token").value = response.id;
    console.log('heeey');
    console.log(document.getElementById("payments_token").value)
    // Uncomment the following line to see the full response object
    //$("#stripeResponse").html("<pre>Status: " + status + "\n - response: " + JSON.stringify(response, undefined, 2) + "</pre>");
	}



});



