<?php

require_once 'Routing.php';

$path = trim($_SERVER['REQUEST_URI'], '/');
$path = parse_url($path, PHP_URL_PATH);

Routing::get('','DefaultController');

Routing::get('signin','AuthController');
Routing::get('signup','AuthController');
Routing::post('logout','AuthController');
Routing::post('login','AuthController');
Routing::post('register','AuthController');
Routing::get('profile','AuthController');
Routing::get('userform','AuthController');
Routing::post('userupdate','AuthController');

Routing::post('addteam','TeamController');
Routing::get('myteams','TeamController');
Routing::get('teammember','TeamController');
Routing::get('searchteams','TeamController');
Routing::post('search','TeamController');
Routing::get('team','TeamController');
Routing::get('menageteam','TeamController');
Routing::post('deleteteam','TeamController');
Routing::get('challenge','TeamController');

Routing::post('createinvitation','InvitationController');
Routing::post('deleteinvitation','InvitationController');
Routing::post('acceptinvitation','InvitationController');
Routing::post('rejectinvitation','InvitationController');
Routing::get('userinvitations','InvitationController');
Routing::get('getuserinvitations','InvitationController');
Routing::get('teaminvitations','InvitationController');
Routing::get('getteaminvitations','InvitationController');

Routing::post('creategame','GameController');
Routing::post('acceptgame','GameController');
Routing::post('rejectgame','GameController');
Routing::post('deletegame','GameController');
Routing::get('menagegames','GameController');
Routing::get('getteamgames','GameController');
Routing::get('usergames','GameController');
Routing::get('getusergames','GameController');


Routing::run($path);