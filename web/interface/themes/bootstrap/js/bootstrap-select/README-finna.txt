-----------------------------------------------------------------
In bootstrap-select.js commented out the line
                 '<i class="icon-ok check-mark"></i>' + 
(the checkmarks are not needed in the dropdown menu)
-----------------------------------------------------------------
Use class 'selectpicker-exclude' to exclude the select element
from selectpicker. This is needed in Advanced search page due
to Chosen not working correctly otherwise.
-----------------------------------------------------------------
