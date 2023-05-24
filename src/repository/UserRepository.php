<?php

require_once 'Repository.php';
require_once __DIR__.'/../models/User.php';

class UserRepository extends Repository{

    public function getUser ($email): ?User{

        $stmt = $this->database->connect()->prepare('
            SELECT * FROM public.users WHERE email = :email
        ');
        $stmt->bindParam(':email', $email, PDO::PARAM_STR);
        $stmt->execute();

        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user == false) {
            //Add Exception
            return null;
        }

        return new User(
            $user['email'],
            $user['password'],
            $user['username'],
            $user['name'],
            $user['surname']
        );
    }

}