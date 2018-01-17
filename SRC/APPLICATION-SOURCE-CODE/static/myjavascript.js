$(document).ready(function(){
    $('#datepicker').datepicker({
        autoclose: true,
            format: 'yyyy-mm-dd',
            todayHighlight: true,
            endDate: '+0d',
            startDate: '0d'
     });
});