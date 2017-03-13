var get_product_info = function() {
	var id = $('#product_id :selected').val();
	console.log(id);
	
	$.ajax({
	    url: '/products/product_api',
	    type: 'GET',
	    data: {
	      id: id
	    },
	    error: function(xhr) {
	      alert('Ajax request 發生錯誤');
	    },
	    success: function(data) {
	    	if (data.length > 0){
	    		$('#price_input').show();
	    		$('#trade_current_price').val(data[0]["price"]);
	    		$('#trade_product').val(data[0]["name"]);
	    	} 
	    }
	  });
}

$(document).ready(function() {
	$('#product_input').hide();
	$('#price_input').hide();
    $('#trade_submit').attr("disabled", true);
    var products = $('#product_id').html();
    //console.log(products)
    
    $('#product_type').change(function() {
    	var type = $('#product_type :selected').text();
    	//console.log(type)
    	var options = $(products).filter("optgroup[label='" + type + "']").html();
    	//console.log(options)
    	//console.log(type.indexOf("Please select"))
    	
    	$('#product_input').show();
    	
        if (options != "" && type.indexOf("請先選擇") < 0) {
        	$('#product_id').html(options);
            $('#product_id').show();
            $('#message').hide();
            $('#trade_submit').attr("disabled", false);
            get_product_info();
        }    
        else if (type.indexOf("請先選擇") < 0 ) {
        	// 類別無商品
	        $('#product_id').empty();
            $('#product_id').hide();
            $('#message').show();
            $('#price_input').hide();
            $('#trade_submit').attr("disabled", true);
       	} 
        else{
        	// 類別還沒選
			$('#product_id').empty();
	        $('#product_input').hide();
	        $('#price_input').hide();
	        $('#trade_submit').attr("disabled", true);
        }

    })
    
    $('#product_id').change(function() {
    	get_product_info();
    })
         
})