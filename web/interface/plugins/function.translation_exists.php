<?php
/**
 * translatePrefix Smarty plugin
 *
 * PHP version 5
 *
 * Copyright (C) The National Library of Finland 2012.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * @category VuFind
 * @package  Smarty_Plugins
 * @author   Kalle Pyykkönen <kalle.pyykkonen@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_plugin Wiki
 */

/**
 * Smarty plugin
 * -------------------------------------------------------------
 * Type:     function
 * Name:     translationExists
 * Purpose:  Checks if a translation exist for given key
 * -------------------------------------------------------------
 *
 * @param array  $params  Incoming parameter array
 * @param object &$smarty Smarty object
 *
 */ // @codingStandardsIgnoreStart
function smarty_function_translation_exists($params, &$smarty)
{   // @codingStandardsIgnoreEnd
    if (is_array($params)) {
        $prefix = isset($params['prefix']) ? $params['prefix'] : '';
        $text = isset($params['text']) ? $params['text'] : '';
    } else {
        $text = $params;
    }
    // default true for backwards compatibility
    $status = true;
    if (function_exists('translationExists')) {
        $status = translationExists(
                    array(
                        'text' => $text, 
                        'prefix' => $prefix, 
                    )
                  );        
    }

    $smarty->assign('translationStatus', $status);
}
?>