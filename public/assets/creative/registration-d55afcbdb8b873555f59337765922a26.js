$(document).ready(function() {

	var handler = StripeCheckout.configure({
		key: $("input[name='stripe_key']").val(),
	  image: 'https://stripe.com/img/documentation/checkout/marketplace.png',
		locale: 'auto',
	  token: function(token) {
	  	// Use the token to create the charge with a server-side script.
	    // You can access the token ID with `token.id`
	    $("input[name='payment_token']").val(token.id);
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

