$(document).ready(function() {
	$(".hierarchyTreeLink a").unbind('click').click(function(e) {
		var hierarchyID = $(this).parent().find(".hiddenHierarchyId")[0].value;
        var id = this.id.substr('hierarchyTree'.length);
        var $dialog = getLightbox('Record', 'HierarchyTree', id, null, this.title, '', '', '', {hierarchy: hierarchyID});
        e.preventDefault();
	});
});
