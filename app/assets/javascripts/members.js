var init_member_lookup;

init_member_lookup = function() {
	$('#member-lookup-form').on('ajax:before', function(event, data, status){
		show_spinner();
	});
	$('#member-lookup-form').on('ajax:after', function(event, data, status){
		hide_spinner();
	});
	$('#member-lookup-form').on('ajax:success', function(event, data, status) {
		$('#member-lookup').replaceWith(data);
		init_member_lookup();
	});
	$('#member-lookup-form').on('ajax:error', function(event, xhr, status, error){
		hide_spinner();
		$('#member-lookup-results').replaceWith(' ');
		$('#member-lookup-errors').replaceWith('Member was not found.');
		//$('#member-lookup-errors').replaceWith(error);
	})
}


$(document).ready(function() {
	init_member_lookup();
	
	$('.datepicker').datepicker({
          format: "yyyy-mm-dd",
          todayHighlight: true,
          todayBtn: 'linked',
          autoclose: true
      });
})
