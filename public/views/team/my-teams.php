<?php 
  session_start();
  if(!isset($_SESSION['userId'])){
    $url = "http://$_SERVER[HTTP_HOST]";
    header("Location: {$url}/signin");
  }
?>


<!DOCTYPE html>
<head>  
  <meta name="viewport" content="width=device-width">
  <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1" />
  
  <script
    src="https://kit.fontawesome.com/46d253cbeb.js"
    crossorigin="anonymous"
  ></script>
  <title>My Teams</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link
    href="https://fonts.googleapis.com/css2?family=Iceland&family=Roboto:wght@400;500&display=swap"
    rel="stylesheet"
  />
  <link rel="stylesheet" type="text/css" href="/public/css/index.css" />
  <link rel="stylesheet" type="text/css" href="/public/css/layout/navigation.css" />
  <link rel="stylesheet" type="text/css" href="/public/css/layout/main.css" />
  <link rel="stylesheet" type="text/css" href="/public/css/layout/sidebar.css" />
  <link rel="stylesheet" type="text/css" href="/public/css/layout/footer.css" />
  <link rel="stylesheet" type="text/css" href="/public/css/team/my-teams.css" />
  <script src="https://kit.fontawesome.com/46d253cbeb.js" crossorigin="anonymous"></script>
  <script type="text/javascript" src="/public/js/ui-sidebar.js" defer></script>


</head>

<body>

  <?php include('public/views/layout/navigation.php') ?>

  <main class="main">
    <div class="main__sidebar">
      <nav id="sidebar" class="sidenav">
        <div class="sidenav__container">
          
          <div class="sidenav__profile">
            <h3 class="sidenav__name"><?= $_SESSION['username'] ; ?></h3>
            <picture class="sidenav__avatar">
              <img
                class="sidenav__img"
                src="public/uploads/avatars/<?= $_SESSION['avatar'] ; ?>"
                alt="User avatar"
              />
            </picture>
          </div>

          <ul class="sidenav__menu">
            <li class="menu__button ">
              <a class="menu__link" href="/profile">
                <i class="fa-solid fa-user"></i>
                Profile
              </a>
            </li>
            <li class="menu__button" >
              <a class="menu__link" href="/searchteams">
                <i class="fa-solid fa-magnifying-glass"></i>
                Search</a
              >
            </li>

            <li class="menu__button active">
              <a class="menu__link" href="/myteams">
                <i class="fa-solid fa-users"></i>
                Teams</a
              >
            </li>
            <li class="menu__button">
              <a class="menu__link" href="/usergames">
                <i class="fa-solid fa-circle-play"></i>
                Compet</a
              >
            </li>
            <li class="menu__button">
              <a class="menu__link" href="/userinvitations">
              <i class="fa-solid fa-envelope"></i>
                Invitations</a
              >
            </li>
            <li class="menu__button">
              <a class="menu__link" href="/logout">
                <i class="fa-sharp fa-solid fa-arrow-right-from-bracket"></i>
                Logout</a
              >
            </li>
          </ul>
        </div>
      </nav>
    </div>

    <div class="main__page">
      <section class="teams">

      

        <nav class="teams__actions">
          <ul class="teams__ul">
            <li>
              <a  class="teams__link teams__link--border teams__link--active" href="/myteams">
                <i class="fa-solid fa-user-shield teams__icon--nav"></i>
                Owner
              </a>
            </li>
            <li>
              <a  class="teams__link teams__link--border" href="/teammember">
              <i class="fa-solid fa-user teams__icon--nav"></i>
                Member
              </a>
            </li>
            <li>
              <a class="teams__link" href="/addteam">
                <i class="fa-solid fa-plus teams__icon--nav"></i>
                Create team
              </a>
            </li>
          </ul>
        </nav>

 
       <div class="teams__header">
          <h2>
            My Teams
          </h2>
       </div>
       <ul class="teams__list">
       <?php if(count($teams)) : ?>
        <?php foreach($teams as $team):?>
            <li>
              <article class="team__item">
                <div class="team__name">
                  <h3><?= $team->getTitle() ?></h3>
                </div>

                <div class="team__info">
                  <p class="team__data">
                    <i class="fa-solid fa-basketball team__icon"></i>  
                    <?= $team->getGame() ?>
                  </p>
                  <p class="team__data">
                    <i class="fa-sharp fa-solid fa-city team__icon"></i>
                    <?= $team->getCity() ?>
                  </p>
                  <p class="team__data"> 
                    <i class="fa-solid fa-users team__icon"></i>
                    <?= $team->getMembers() ?>
                  </p>
                </div>

                <picture class="team__picture"> 
                  <img class="team__img" src="public/uploads/<?= $team->getImage() ?>" alt="Team">
                </picture>
                
                <div class="team__description">
                  <p class="team__about">
                  <i class="fa-solid fa-circle-info team__icon"></i>
                    About us:
                  </p>
                  <p class="team__text">
                  <?= $team->getDescription() ?>
                  </p>
                </div>

                <div class="team__actions">
                  <a class="team__button" href="/menageteam/<?= $team->getId() ?>" >Menage</a>
                </div>

              </article>
            </li>
            <?php endforeach; ?>
          <?php else : ?>
            <li>
              <h3>You do not own any team.</h3>
            </li>
          <?php endif; ?>
       </ul>
      
      </section>
    </div>
  </main>

  <?php include('public/views/layout/footer.php') ?>
</body>
