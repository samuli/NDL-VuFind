<?php

/**
 * Generic Normalization Service Interface for On-the-fly metadata previewer. 
 *
 * PHP version 5
 *
 * Copyright (C) Eero Heikkinen 2013
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
 * @package  Support_Classes
 * @author   Eero Heikkinen <eero.heikkinen@gmail.com>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */

/**
 * Generic Normalization Service interface.
 * 
 * @category VuFind
 * @package  Support_Classes
 * @author   Eero Heikkinen <eero.heikkinen@gmail.com>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
interface NormalizationService
{
    /**
     * Normalize a given XML string into a set of index fields.
     * 
     * @param string $data The record metadata to parse
     * 
     * @return array The parsed index fields as an array
     */
    public function normalize($data);
}
