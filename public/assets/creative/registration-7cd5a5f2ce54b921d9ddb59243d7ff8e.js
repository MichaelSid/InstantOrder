$(document).ready(function() {

	// var form;

	// $("#new_account, #edit_account").submit(function(e){
	// 	if ($('#cardNumber').val() == '') { return true;}
	// 	console.log($(this))
	// 	form = $(this);
	// 	form.find('.submit-account').prop('disabled', true);
	// 	console.log('hi');
	// 	Stripe.setPublishableKey($("input[name='stripe_key']").val())
 //    Stripe.card.createToken({
 //      number: $('#cardNumber').val(),
 //      cvc: $('#CVC').val(),
 //      exp_month: $('#expMonth').val(),
 //      exp_year: $('#expYear').val(),
 //    }, stripeResponseHandler);
 //    return false;
	// });

	// function stripeResponseHandler(status, response) {
		
	// 	if (response.error) { // Problem!
 //    // Show the errors on the form:
	//     form.find('.payment-errors').text(response.error.message);
	//     form.find('.submit-account').prop('disabled', false); // Re-enable submission

 //  	} else { // Token was created!
	// 		var token = response.id
	// 		console.log(token)
	// 		form.append($('<input type="hidden" name="payment_token">').val(token));
	// 		form.get(0).submit();
	// 	}
	// }

	var handler = StripeCheckout.configure({
		key: $("input[name='stripe_key']").val(),
	  image: 'https://stripe.com/img/documentation/checkout/marketplace.png',
		locale: 'auto',
	  token: function(token) {
	  	// Use the token to create the charge with a server-side script.
	    // You can access the token ID with `token.id`
	    $("input[name='payment_token']").val(token.id);
	    $("#signup-submit").prop("disabled",false);
	  }
	});
	$('#paymentButton').on('click', function(e) {
		// Open Checkout with further options
		handler.open({
			name: 'Instela',
			'panel-label': 'Add',
		});
		e.preventDefault();
	});
	// Close Checkout on page navigation
	$(window).on('popstate', function() {
		handler.close();
	});
});
