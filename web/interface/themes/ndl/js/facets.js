function enableDynatree(tree, facet, url, action, searchObject)
{
  var query = url.split('?')[1];
  tree.dynatree({
    isLazy: true,
    query: query,
    action: action,
    onActivate: function(node) {
      if (node.data.url)
        window.location.href = node.data.url;
	},
	onLazyRead: function(node) {
      var level = node.data.level + 1;
      getFacetList(node, node.tree.options.query, node.tree.options.query.action, node.data.facet, level, node.data.filter, node.data.searchObject);
    }
  });
  var node = $(tree).dynatree("getRoot");
  tree.find('.facet_loading').show();
  getFacetList(node, query, action, facet, 0, '', searchObject);
}

function getFacetList(node, query, action, facet, level, prefix, searchObject)
{
  var params = {
    method: "getFacets",
    facetName: facet,
    facetLevel: level,
    facetPrefix: prefix,
  };
  if (searchObject) {
    params['searchObject'] = searchObject;
  }

  $.getJSON(path + (action == "NewItem" ? "/AJAX/JSON_FacetsNewItem?" : "/AJAX/JSON_Facets?") + query,
    params,
    function(response, textStatus) {
      $('#facet_' + facet).find('.facet_loading').hide();
      if (response.status == "OK") {
        var list = response.data;
        res = [];
        for (var i = 0, l = list.length; i < l; i++) {
          var e = list[i];
          var title = e.value;
          if (e.value == e.untranslated) {
              e.value = e.value.replace(/^\d+\//, '');
          }
          res.push({title: '<span class="facetTitle" title="' + title + '">' + e.value + '</span><span class="facetCount"> (' + e.count + ')</span>', href: e.url, url: e.url, icon: false, 
        	facet: facet, level: level, filter: e.untranslated, searchObject: searchObject, unselectable: true, isLazy: e.children ? true : false});
        }
        node.setLazyNodeStatus(DTNodeStatus_Ok);
        node.addChild(res);
      } else {
        node.setLazyNodeStatus(DTNodeStatus_Error, {
          tooltip: response.faultDetails,
          info: response.faultString
        });
      }
    }
  );
}
