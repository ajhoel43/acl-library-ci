<?php defined('BASEPATH') OR exit('No direct script access allowed');
/**
* This is an ACL for Research
*/
class Myacl
{
	protected $CI;
	protected $myDB;
	protected $mySession;
	private $granted = 1;

	public $create = 'create';
	public $read = 'read';
	public $update = 'update';
	public $delete = 'delete';
	public $report = 'report';

	function __construct() {
		$this->CI = &get_instance();
		$this->CI->load->library('session', 'database');
		$this->CI->load->helper(array('url', 'language'));
		$this->CI->lang->load('en', 'english');
		$this->loadDB();
	}

	public function getMySession() {
		// ** Getting User from Session
		// $this->mySession = $this->CI->session->userdata();
		
		// ** Manually set for testing ** //
		$sess = new stdClass();
		$sess->username = 'test_user';
		$this->mySession = $sess;
	}

	public function isAllGranted() {
		$this->myDB->select('u.username, g.nama');
		$this->myDB->where('u.username', $this->mySession->username);
		$this->myDB->where('g.grant_all_access', $this->granted);

		$this->myDB->join('user_group ug', 'ug.id_user = u.id');
		$this->myDB->join('group g', 'ug.id_group = g.id');

		$query = $this->myDB->get('user u')->result();

		if(!empty($query))
			return true;
		else
			return false;
	}

	public function operationGranted($class, $operationname = '', $func = '') {
		$this->getMySession();
		$isAllGranted = $this->isAllGranted();

		if($isAllGranted === true)
			return true;

		// ** Checking Group Privileges **
		$gparams = array('classname' => $class, 'operation' => $operationname, 'function' => $func);
		$isGroupGranted = $this->isGroupGranted($gparams);

		if($isGroupGranted === true)
			return true;

		// ** Checking Personal Privileges ** //
		$isUserGranted = $this->isUserGranted($gparams);

		if($isUserGranted === true)
			return true;

		$this->noAccess($gparams);
	}

	public function isGroupGranted($params) {
		$this->myDB->select('
			u.username, g.nama, m.name,
			m.class_name, m.func_name,
			ga.create, ga.read, ga.update,
			ga.delete, ga.report
			');
		$this->myDB->where('u.username', $this->mySession->username);
		$this->myDB->where('m.class_name', $params['classname']);
		$this->myDB->where('ga.'.$params['operation'], $this->granted);

		if(isset($params['function']) && !empty($params['function']))
			$this->myDB->where('m.func_name', $params['function']);

		$this->myDB->join('user_group ug', 'u.id = ug.id_user');
		$this->myDB->join('group g', 'ug.id_group = g.id');
		$this->myDB->join('group_acl ga', 'g.id = ga.id_group');
		$this->myDB->join('menu m', 'ga.id_menu = m.id');

		$query = $this->myDB->get('user u')->result();

		if(!empty($query))
			return true;
		else
			return false;
	}

	public function isUserGranted($params = array()) {
		$this->myDB->select('
			u.username, m.name, m.class_name,
			m.func_name, ua.create, ua.read,
			ua.update, ua.delete, ua.report
			');

		$this->myDB->where('u.username', $this->mySession->username);
		$this->myDB->where('m.class_name', $params['classname']);
		$this->myDB->where('ua.'.$params['operation'], $this->granted);

		if(isset($params['function']) && !empty($params['function']))
			$this->myDB->where('m.func_name', $params['function']);

		$this->myDB->join('user_acl ua', 'u.id = ua.id_user');
		$this->myDB->join('menu m', 'ua.id_menu = m.id');

		$query = $this->myDB->get('user u')->result();

		if(!empty($query))
			return true;
		else
			return false;
	}

	public function noAccess($params = array()) {
		// ** Get Menu Name for a better Feedback ** //
		$func = $params['function'];
		$class = $params['classname'];
		$opr = $params['operation'];
		if(!is_null($func))
			$this->myDB->where('func_name', $func);
		$this->myDB->where('class_name', $class);

		$menu = $this->myDB->get('menu')->row();

		$naparams = array('operation' => $opr);
		if(count($menu) > 0)
			$naparams['menu_name'] = lang('onMenu').' '.$menu->name;

		if(!empty($naparams)) {
			$langname = 'msg_op_'.$naparams['operation'];
			$message = lang('msg_nopermission_menu').' '.lang($langname);
			if(!empty($naparams['menu_name']))
				$message .= ' '.$naparams['menu_name'];
		} else {
			$message = lang('msg_nopermission_menu');
		}

		if(!requestFromAjax()) {
			$this->CI->session->set_flashdata('flash_message', $message);
			redirect('acl_controller');
		} else {
			$ERROR = 1;
			jsonRet($ERROR, $message);
		}

		die();
	}

	// ******* VALIDATE ******* //
	// Docs
	// Just fill $func_name parameters when you has been register the function name in acl table

	public function validate_read($func_name = '', $classname = '') {
		if($classname == '') {
			$classname = getClassName();
		}

		$granted = $this->operationGranted($classname, $this->read, $func_name);
	}

	public function validate_create($func_name = '', $classname = '') {
		if($classname == '') {
			$classname = getClassName();
		}
		$granted = $this->operationGranted($classname, $this->create, $func_name);
	}

	public function validate_update($func_name = '', $classname = '') {
		if($classname == '') {
			$classname = getClassName();
		}
		$granted = $this->operationGranted($classname, $this->update, $func_name);
	}

	public function validate_delete($func_name = '', $classname = '') {
		if($classname == '') {
			$classname = getClassName();
		}
		$granted = $this->operationGranted($classname, $this->delete, $func_name);
	}

	public function validate_report($func_name = '', $classname = '') {
		if($classname == '') {
			$classname = getClassName();
		}
		$granted = $this->operationGranted($classname, $this->report, $func_name);
	}

	private function loadDB() {
		$mydb = array(
			'dsn'	=> '',
			'hostname' => 'localhost',
			'username' => '',
			'password' => '',
			'database' => 'belajar',
			'dbdriver' => 'mysqli',
			'dbprefix' => '',
			'pconnect' => FALSE,
			'db_debug' => (ENVIRONMENT !== 'production'),
			'cache_on' => FALSE,
			'cachedir' => '',
			'char_set' => 'utf8',
			'dbcollat' => 'utf8_general_ci',
			'swap_pre' => '',
			'encrypt' => FALSE,
			'compress' => FALSE,
			'stricton' => FALSE,
			'failover' => array(),
			'save_queries' => TRUE
		);

		$this->myDB = $this->CI->load->database($mydb, TRUE);
	}

}