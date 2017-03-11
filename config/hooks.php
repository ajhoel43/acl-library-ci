<?php defined('BASEPATH') OR exit('No direct script access allowed');

function currentFunction() {
	$CI =& get_instance();
	return $CI->router->fetch_method();
}

function getClassName() {
	$CI = &get_instance();
	return $CI->router->fetch_class();
}

function requestFromAjax() {
    if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
        return true;
    } else {
        return false;
    }
}