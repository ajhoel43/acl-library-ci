<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Myclass extends CI_Controller {
	function __construct()
	{
		$this->load->library('myacl');
	}

	function menu_read() {
		$this->myacl->validate_read();
	}

	function menu_specific_read() {
		$this->myacl->validate_read(currentFunction());
	}

	function save_data() {
		$this->myacl->validate_create();
	}
}