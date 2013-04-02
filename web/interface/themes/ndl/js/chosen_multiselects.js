$(document).ready(function(){
	// make select multiple form elements fancy Chosen-elements
    if (!isTouchDevice()) {
        $(".chzn-select").chosen(); 
        $(".chzn-select-deselect").chosen({allow_single_deselect:true});
    }
});