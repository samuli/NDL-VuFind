<?php
/**
 * Virtua ILS Driver Test Class
 *
 * PHP version 5
 *
 * Copyright (C) Villanova University 2010.
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
 * @package  Tests
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/unit_tests Wiki
 */
require_once dirname(__FILE__) . '/../prepend.inc.php';
require_once 'Drivers/Virtua.php';

/**
 * Virtua ILS Driver Test Class
 *
 * @category VuFind
 * @package  Tests
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/unit_tests Wiki
 */
class VirtuaTest extends PHPUnit_Framework_TestCase
{
    /**
     * Standard setup method.
     *
     * @return void
     * @access public
     */
    public function setUp()
    {
        // Without OCI functionality, we can't proceed:
        if (!function_exists('oci_connect')) {
            $this->markTestSkipped();
        }
    }

    /**
     * Test the constructor.
     *
     * @return void
     * @access public
     */
    public function testConstructor()
    {
        // Construct object to ensure that everything parses correctly:
        $virtua = new Virtua();
        $this->assertEquals(is_object($virtua), true);
    }

    /**
     * Standard teardown method.
     *
     * @return void
     * @access public
     */
    public function tearDown()
    {
    }
}
?>
