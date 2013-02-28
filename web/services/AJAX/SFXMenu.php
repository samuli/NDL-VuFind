<?php
/**
 * Ajax page for Cleaned-up SFX Menu
 *
 * PHP version 5
 *
 * Copyright (C) The National Library of Finland 2012
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
 * @package  Controller_Record
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Action.php';
require_once 'sys/Proxy_Request.php';
require_once 'simple_html_dom.php';

/**
 * Full cleaned-up SFX menu 
 *
 * @category VuFind
 * @package  Controller_Record
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class SFXMenu extends Action
{
    /**
     * Constructor.
     *
     * @access public
     */
    public function __construct()
    {
        parent::__construct();
        $_SESSION['no_store'] = true; 
    }

    /**
     * Process incoming parameters and display the page.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $interface;
        global $configArray;

        if (isset($_REQUEST['proxyitem'])) {
            $url = $configArray['OpenURL']['url'];
            // Strip main directory
            $url = substr($url, 0, strrpos($url, '/'));
            $url .= $_REQUEST['proxyitem'];
            $request = new Proxy_Request();
            $request->setMethod(HTTP_REQUEST_METHOD_GET);
            $request->setURL($url);
            $request->addHeader('X-Forwarded-For', $_SERVER['REMOTE_ADDR']);
            if (isset($configArray['OpenURL']['language'][$interface->lang])) {
                $request->addCookie('user-Profile', '%2B%2B%2B' . $configArray['OpenURL']['language'][$interface->lang]);
            }
            $result = $request->sendRequest();
            if (PEAR::isError($result)) {
                die($result->getMessage() . "\n");
            }
            foreach ($request->getResponseHeader() as $name => $value) {
                if (strcasecmp($name, 'content-type') == 0 || strcasecmp($name, 'content-length') == 0) {
                    header("$name: $value");
                }
            }
            echo $request->getResponseBody();
            exit;
        }
        
        header('Content-type: text/html; charset=UTF-8');
        header('Cache-Control: no-cache, must-revalidate'); // HTTP/1.1
        header('Expires: Mon, 26 Jul 1997 05:00:00 GMT'); // Date in the past

        if (!isset($_REQUEST['openurl']) || !$_REQUEST['openurl']) {
            die("Missing parameter 'openurl'");
            return;
        }
        
        $url = $configArray['OpenURL']['url'];
        $baseURL = substr($url, 0, strrpos($url, '/'));
        $proxyURL = $configArray['Site']['url'] . '/AJAX/SFXMenu?action=SFXMenu&amp;proxyitem=';
        
        if (substr($_REQUEST['openurl'], 0, 1) != '?') {
            $url .= '?';
        }
        $url .= $_REQUEST['openurl'];
        
        $request = new Proxy_Request();
        $request->setMethod(HTTP_REQUEST_METHOD_GET);
        $request->setURL($url);
        $request->addHeader('X-Forwarded-For', $_SERVER['REMOTE_ADDR']);
        if (isset($configArray['OpenURL']['language'][$interface->lang])) {
            $request->addCookie('user-Profile', '%2B%2B%2B' . $configArray['OpenURL']['language'][$interface->lang]);
        }
                
        // Perform request and die on error
        $result = $request->sendRequest();
        if (PEAR::isError($result)) {
            die($result->getMessage() . "\n");
        }
        $html = new simple_html_dom();
        $html->load($request->getResponseBody());
        
        echo <<<EOF
<html>
<head>
EOF;
        
        // Get style sheets and scripts
        foreach ($html->find('head link') as $link) {
            if (substr($link->href, 0, 1) == '/') {
                $link->href = $proxyURL . urlencode($link->href);
            } elseif (strcasecmp(substr($link->href, 0, strlen($baseURL)), $baseURL) == 0) {
                $link->href = $proxyURL . urlencode(substr($link->href, strlen($baseURL)));
            }
            echo "$link\n";
        }
        foreach ($html->find('head script') as $script) {
            if (substr($script->src, 0, 1) == '/') {
                $script->src = $proxyURL . urlencode($script->src);
            }
            echo "$script\n";
        }
        echo <<<EOF
<script type="text/javascript">
function openWindow(obj, form_name)
{
  var form = $("form[name=" + form_name + "]");
  var url = form.attr('action');
  var params = '';
  form.find("input[type=hidden]").each(function() {
    if (params) {
      params += '&';
    }
    params += encodeURIComponent($(this).attr('name')) + '=' + encodeURIComponent($(this).attr('value'));
  });
  var win = window.open();
  win.location = url + '?' + params;
}
</script>        
            
</head>
<body>
EOF;

        
        $container = $html->find('#basic_target_list_container', 0);
        if (!$container) {
            $container = $html->find('#advanced_target_list_container', 0);
        }
        if ($container) {
            // We have some actual items to display
            $table = $container->parent();
            
            foreach ($table->find('img') as $img) {
                if (substr($img->src, 0, 1) == '/') {
                    $img->src = $proxyURL . urlencode($img->src);
                }
            }

            foreach ($table->find('form') as $form) {
                if (substr($form->action, 0, 1) == '/') {
                    $form->action = $baseURL . $form->action;
                }
            }
            
            echo $table;
        }
        
        echo <<<EOF
</body>
</html>
EOF;
    }
}
