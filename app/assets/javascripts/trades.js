var get_product_info = function() {
	var id = $('#product_id :selected').val();
	//console.log(id);

	$.ajax({
		url : '/products/product_api',
		type : 'GET',
		data : {
			id : id
		},
		error : function(xhr) {
			alert('Ajax request 發生錯誤');
		},
		success : function(data) {
			if (data.length > 0) {
				$('#price_input').show();
				$('#current_price').val(data[0]["price"]);
				$('#product').val(data[0]["name"]);
			}
		}
	});
}
var init_trade_shopping_cart = function() {
	$('#trades-form').on('ajax:before', function(event, data, status) {
		show_spinner();
	});
	$('#trades-form').on('ajax:after', function(event, data, status) {
		hide_spinner();
	});
	$('#trades-form').on('ajax:success', function(event, data, status) {
		$('#trades-shopping-cart').replaceWith(data);
		set_default();
	});
	$('#trades-form').on('ajax:error', function(event, xhr, status, error) {
		hide_spinner();
		$('#trades-results').replaceWith(' ');
		$('#trades-errors').replaceWith(error);
		//$('#product-lookup-errors').replaceWith(error);
	})
}

var init_shopping_cart_list = function() {
	$('#shopping-cart-form').on('ajax:before', function(event, data, status) {
		show_spinner();
	});
	$('#shopping-cart-form').on('ajax:after', function(event, data, status) {
		hide_spinner();
	});
	$('#shopping-cart-form').on('ajax:success', function(event, data, status) {
		$('#trades-shopping-cart').replaceWith(data);
		console.log("!!!!")
		set_default();
	});
	$('#shopping-cart-form').on('ajax:error', function(event, xhr, status, error) {
		hide_spinner();
		$('#trades-results').replaceWith(' ');
		$('#trades-errors').replaceWith(error);
		//$('#product-lookup-errors').replaceWith(error);
	})
}

var set_default = function() {
	init_trade_shopping_cart();
	init_shopping_cart_list();
	$('#product_input').hide();
	$('#price_input').hide();
	$('#trade_submit').attr("disabled", true);
}

var product;

$(document).on('change', '#product_type', {}, function(e) {
	
	var type = $('#product_type :selected').text();
	//console.log(type)
	var options = $(products).filter("optgroup[label='" + type + "']").html();
	//console.log(options)
	//console.log(type.indexOf("Please select"))

	$('#product_input').show();

	if (options != "" && type.indexOf("Please select") < 0) {
		$('#product_id').html(options);
		$('#product_id').show();
		$('#message').hide();
		$('#trade_submit').attr("disabled", false);
		get_product_info();
	} else if (type.indexOf("Please select") < 0) {
		// 類別無商品
		$('#product_id').empty();
		$('#product_id').hide();
		$('#message').show();
		$('#price_input').hide();
		$('#trade_submit').attr("disabled", true);
	} else {
		// 類別還沒選
		$('#product_id').empty();
		$('#product_input').hide();
		$('#price_input').hide();
		$('#trade_submit').attr("disabled", true);
	}
})
$(document).on('change', '#product_id', {}, function(e){
	get_product_info();
})

$(window).on('load', function(){
	set_default();
    products = $('#product_id').html();
    //console.log(products)
});
