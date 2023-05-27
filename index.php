<?php

require_once 'Routing.php';

$path = trim($_SERVER['REQUEST_URI'], '/');
$path = parse_url($path, PHP_URL_PATH);

Routing::get('','DefaultController');
Routing::get('signin','DefaultController');
Routing::get('signup','DefaultController');

Routing::post('login','AuthController');
Routing::post('register','AuthtController');

Routing::get('teams','TeamController');
Routing::post('addTeam','TeamController');
Routing::post('search','TeamController');


Routing::run($path);