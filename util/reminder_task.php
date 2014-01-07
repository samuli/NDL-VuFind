<?php
/**
 * Base class for Reminder tasks
 *
 * PHP version 5
 *
 * Copyright (C) The National Library of Finland 2013.
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
 * @package  Controller
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/developer_manual Wiki
 */


/**
 * Base class for Reminder tasks
 * 
 * @category VuFind
 * @package  Due_Date_Reminders
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/
 * 
 */
class ReminderTask
{
    protected $mainDir;
    protected $errEmail;
    protected $errs = false;

    protected $mainConfig;
    protected $datasourceConfig;
    
    /**
     * Constructor
     *
     * @param string $mainDir  The main VuFind directory. 
                               Each web directory must reside 
                               under this (default: ..)
     * @param string $errEmail Email address for error reporting.
     *
     * @return void
     */
    function __construct($mainDir, $errEmail) 
    {
        $this->mainDir = $mainDir;
        $this->errEmail = $errEmail;

        $this->mainConfig = readConfig();
        $this->datasourceConfig = getExtraConfigArray('datasources');
    }

    /**
     * Send reminders
     *
     * @return void
     */
    protected function send() 
    {
    }

    /**
     * Search for institution configuration from the following 
     * locations within <mainDir>:
     *   1. 'mainView' for the given institution in datasource configuration
     *   2. /<institution>/<defaultPath> (specified in config.ini > defaultPath)
     *
     * If required, ['Site']['url'] is set according to the 
     * url schema for views (specified in config.ini > urlSchema)
     *
     * @param string $institution institution code
     *
     * @return array configuration or false on error
     */
    protected function readInstitutionConfig($institution) 
    {          
        $defaultDir = isset($this->mainConfig['Site']['defaultPath']) 
            ? $this->mainConfig['Site']['defaultPath']
            : 'default';
        
        if (isset($this->datasourceConfig[$institution]['mainView'])) {
            $configPath  = "$this->mainDir/" 
                         . $this->datasourceConfig[$institution]['mainView']
                         . '/conf';
            $msg = "Switching to configuration of '$institution' ($configPath)";
            $this->msg($msg);
        } else {
            $defaultPath = "$this->mainDir/$institution/$defaultDir";
            $msg = "'mainView' not defined for institution '$institution'."
                 . " Read configuration from $defaultPath";
            $this->msg($msg);
            // assume that view is functional if index.php exists.
            if (is_file("$defaultPath/index.php")) {
                $configPath = "$defaultPath/conf";
            } else {
                $msg = '  Failed to resolve default view for'
                     . " institution '$institution'.";
                $this->err($msg);
                return false;
            }
        }
        if (!is_file("$configPath/config.ini")) {
            $msg = '  No config.ini found for institution '
                 . "'$institution' in $configPath";
            $this->err($msg);
            return false;
        }

        // Read institution's configuration
        $configArray = readConfig($configPath);               
        $siteUrl = isset($configArray['Site']['url']) 
            ? $configArray['Site']['url'] 
            : false;
        $buildSiteUrl = false;

        if ($siteUrl) {
            if (strlen(trim($siteUrl)) == 0) {
                $parts = array($institution);
                $buildSiteUrl = true;                    
            } else {
                if (preg_match('/^https?:\/\/localhost/', $siteUrl)) {
                    $ds = $this->datasourceConfig;
                    $parts = isset($ds[$institution]['mainView']) 
                        ? explode('/', $ds[$institution]['mainView'])
                        : array($institution);
                    
                    if (end($parts) == $defaultDir) {
                        array_pop($parts);
                    }
                    $buildSiteUrl = true;
                }                    
            }
        } else {
            $parts = array($institution);
            $buildSiteUrl = true;
        }

        if ($buildSiteUrl) {
            // no valid site url defined, build from schema
            $siteUrl = $configArray['Site']['urlSchema'];
            $siteUrl = str_replace('{institution}', array_shift($parts), $siteUrl);
            $siteUrl = str_replace('{view}', array_shift($parts), $siteUrl);
            $siteUrl = rtrim($siteUrl, '/');
            $configArray['Site']['url'] = $siteUrl;
        }

        return $configArray;
    }
    
    /**
     * Output a message with a timestamp
     * 
     * @param string $msg Message
     * 
     * @return void
     */
    protected function msg($msg)
    {
        echo date('Y-m-d H:i:s') . ' [' . getmypid() . "] $msg\n"; 
    }

    /**
     * Collect error message
     * 
     * @param string $msg Message
     * 
     * @return void
     */
    protected function err($msg)
    {
        if (!$this->errs) {
            $this->errs = array();
        }
        $this->errs[] = $msg;
    }

    /**
     * Send error email if errors were reported.    
     * 
     * @return void
     */    
    protected function reportErrors()
    {
        if (!$this->errEmail) {
            $this->msg('Failed to send error report: no email address specified');
            return false;
        }
        if ($this->errs) {
            $mailer = new VuFindMailer();
            $from = $this->mainConfig['Site']['email'];
            $to = $this->errEmail;
            $subject = 'ReminderTask error <'
                     . gethostname() . '> : ' . get_class($this);
            $msg = implode(PHP_EOL, $this->errs);
            
            $this->msg('--------------');
            $this->msg(count($this->errs) . " errors, report sent to $to:");
            $this->msg($msg);
            
            $msg = date('Y-m-d H:i:s') 
                 . ' [' . getmypid() . "] " . PHP_EOL . "$msg\n";            

            if (!$result = $mailer->send($to, $from, $subject, $msg)) {
                $this->msg("Failed to send error email to $to");
            }
            $this->msg('--------------');
            return $result;
        }
    }


}