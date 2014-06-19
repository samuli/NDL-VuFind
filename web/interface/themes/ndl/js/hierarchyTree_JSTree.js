function initHierarchyTree(q) {
  $.getJSON(path + "/AJAX/AJAX_HierarchyTree?q=" + q,
    {
      method: "getHierarchyTree",
    },
    function(r) {
      for (var key in r) {
        var e = r[key];
        var treeDoc = '<ul>';
        for (var k = 0, m = e.length; k < m; k++) {
          var f = e[k];
          var siblingIndicator = (f[2] === true) ? '<span class="hierarchy-expander id__'+f[0]+'"></span>' : '';
          var type = (key == 'root') ? '/Collection/' : '/Record/'; // Root level is collection
            treeDoc += '<li class="id__' + f[0] + (f[2] === true ? '' : ' item') + '">'+siblingIndicator+'<a title="'+f[1]+'" href="'+path+type+f[0]+'">'+f[1]+'</a></li>';
        }
        treeDoc += '</ul>'; 

        if (key != 'root') {
          key = jqEscape(key);
          $('#hierarchyTree li.id__'+key).append(treeDoc)
            .addClass('openPath').find('>span').addClass('open expanded');
        } else {
          $('#hierarchyTree').html(treeDoc).removeClass('hierarchyLoading');
        }
      }
    $('#hierarchyTree li.id__'+jqEscape(q)).addClass('openPath');
    }    
  );
}

function expandBranch(id, target, pos) {
  // Get id of the opened path in this branch
  var openPathId = (target.find('li.openPath').first().length > 0) ? 
    target.find('li.openPath').first().attr('class').split(' ')[1].split('id__')[1] :
    '';

  var posString = '';
  // If more leaves requested, build offset string
  if (typeof pos !== 'undefined') {
    posString = "&pos=" + pos;
  } 

  // Do the querying
  $.getJSON(path + "/AJAX/AJAX_HierarchyTree?q=" + id + posString,
    {method: "getHierarchyBranch"},function(r) {
      // Determine if results clipped 
      // (and then remove that index from the results array)
      var clipped = r[0][0];
      var clippedPosition = r[0][1];
      delete r[0];

      // Init branch string
      var branchDoc = '';

      // Iterate results
      for (var i = 1, l = r.length; i < l; i++) {
        var e = r[i];
          var hasChildren = e[2];
          var siblingIndicator = (hasChildren) ? '<span class="hierarchy-expander id__'+e[0]+'"></span>' : '';
          var classString = "";
          if (openPathId == e[0] || q == e[0]) {
              classString = 'openPath ' + 'id__'+e[0];
          }          
          if (!hasChildren) {              
              if (classString != "") {
                  classString += ' ';
              }
              classString += 'item';
          }
          if (classString != "") {
              classString = ' class="' + classString + '"';
          }
        branchDoc += '<li'+classString+'>'+siblingIndicator+'<a title="'+e[1]+'" href="'+path+'/Record/'+e[0]+'">'+e[1]+'</a></li>';
      }

        
      // If results clipped, add "more" link
      if (clipped == 'true') {
        branchDoc += '<li class="moreLeaves pos__'+clippedPosition+'"><a href="#">'+vufindString.moreLeaves+'</a></li>';
      }

      // If more leaves requested, append contents inside the unordered list
      if (typeof pos !== 'undefined') {
        target.find('.moreLeaves').remove();
        target.append(branchDoc);
      } else {
        if (target.find('>ul').length < 1) {
          target.append('<ul><ul>');
        }
        target.find('>ul').html(branchDoc);
        target.find('.hierarchyLoading').remove();
      }
    }
  );
}

// Expander
$('#hierarchyTree, .collectionDetailsTree').on('click', '.hierarchy-expander', function() {
  var $target = $(this).closest('li');
  var id = $(this).attr('class').split(' ')[1].split('__')[1];
  var $children = $(this).siblings('ul');
  if (!$(this).hasClass('expanded')) {
    $target.append('<span class="hierarchyLoading"></span>');
    expandBranch(id, $target);
  } else {
    if ($(this).hasClass('open')) {
      $children.hide();
    } else {
      $children.show();
    }
  }
  $(this).addClass('expanded').toggleClass('open');
});

// More link
$('#hierarchyTree, .collectionDetailsTree').on('click','.moreLeaves a', function(e) {
  e.preventDefault();
  var id = $(this).closest('ul').siblings('span.hierarchy-expander').attr('class').split(' ')[1].split('__')[1];
  var pos = $(this).parent('li').attr('class').split(' ')[1].split('pos__')[1];
  var $target = $(this).closest('ul');
  $(this).append('<span class="hierarchyLoading"></span>');
  expandBranch(id, $target, pos);
});