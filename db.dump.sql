PGDMP     -                    {           fun_fits    14.3    14.3 V    Y           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            Z           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            [           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            \           1262    16536    fun_fits    DATABASE     d   CREATE DATABASE fun_fits WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Polish_Poland.1250';
    DROP DATABASE fun_fits;
                postgres    false            T           1247    16555    sports    TYPE     f   CREATE TYPE public.sports AS ENUM (
    'Football',
    'Voleyball',
    'Basketball',
    'Tenis'
);
    DROP TYPE public.sports;
       public          postgres    false            W           1247    16564    status    TYPE     U   CREATE TYPE public.status AS ENUM (
    'Pending',
    'Accepted',
    'Rejected'
);
    DROP TYPE public.status;
       public          postgres    false            �            1255    16672    acceptgame(integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE public.acceptgame(IN userid integer, IN gameid integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
   gameRow games%ROWTYPE;
   opponentTeam teams%ROWTYPE;
BEGIN
 

   
   SELECT * INTO gameRow FROM games WHERE id=gameId;
   SELECT * INTO opponentTeam FROM teams WHERE id=gameRow.opponent_id;
      
   IF opponentTeam IS NOT NULL AND opponentTeam.owner_id = userId AND  gameRow IS NOT NULL THEN
      UPDATE games SET  status = 'Accepted' WHERE id=gameId;
   END IF;

   COMMIT;
END;$$;
 H   DROP PROCEDURE public.acceptgame(IN userid integer, IN gameid integer);
       public          postgres    false            �            1255    16668 "   acceptinvitation(integer, integer) 	   PROCEDURE     v  CREATE PROCEDURE public.acceptinvitation(IN invid integer, IN userid integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
   invitation invitations%ROWTYPE;
   team teams%ROWTYPE;
BEGIN
   
   SELECT * INTO invitation FROM invitations WHERE id=invId;
   SELECT * INTO team FROM teams WHERE teams.id = invitation.team_id;

   IF invitation IS NOT NULL AND team IS NOT NULL AND team.owner_id=userId THEN
         UPDATE invitations SET  status = 'Accepted' WHERE id=invId;
         UPDATE teams SET members=members + 1  WHERE id=team.id;
         INSERT INTO users_teams (user_id, team_id) VALUES (userId, team.id);
   END IF;


END;$$;
 M   DROP PROCEDURE public.acceptinvitation(IN invid integer, IN userid integer);
       public          postgres    false            �            1255    16670 K   creategame(integer, integer, integer, character varying, character varying) 	   PROCEDURE     �  CREATE PROCEDURE public.creategame(IN userid integer, IN hostid integer, IN opponentid integer, IN place character varying, IN game_date character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
   hostTeam teams%ROWTYPE;
   opponentTeam teams%ROWTYPE;
BEGIN
 

   SELECT * INTO hostTeam FROM teams WHERE teams.id=hostId;
   SELECT * INTO opponentTeam FROM teams WHERE teams.id=opponentId;

   IF hostTeam IS NOT NULL AND hostTeam.owner_id = userId AND  opponentTeam IS NOT NULL  AND hostTeam.id != opponentTeam.id AND hostTeam.game = opponentTeam.game   THEN
   INSERT INTO games (host_id, opponent_id, place, date) VALUES (hostId, opponentId, place, game_date::timestamp );
   END IF;

   COMMIT;
END;$$;
 �   DROP PROCEDURE public.creategame(IN userid integer, IN hostid integer, IN opponentid integer, IN place character varying, IN game_date character varying);
       public          postgres    false            �            1255    16666 "   createinvitation(integer, integer) 	   PROCEDURE     p  CREATE PROCEDURE public.createinvitation(IN userid integer, IN teamid integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
   invitation invitations%ROWTYPE;
   team teams%ROWTYPE;
   user_team users_teams%ROWTYPE;
BEGIN
 
   SELECT * INTO invitation FROM invitations WHERE team_id=teamId AND  user_id=userId;
   SELECT * INTO team FROM teams WHERE id=teamId;
   SELECT * INTO user_team FROM users_teams WHERE team_id=teamId AND user_id=userId;

   IF invitation IS NULL AND team.owner_id != userId AND  user_team IS NULL THEN
   INSERT INTO invitations (user_id, team_id) VALUES (userId, teamId);
   END IF;

   COMMIT;
END;$$;
 N   DROP PROCEDURE public.createinvitation(IN userid integer, IN teamid integer);
       public          postgres    false            �            1255    16671    deletegame(integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE public.deletegame(IN userid integer, IN gameid integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
   hostTeam teams%ROWTYPE;
   gameRow games%ROWTYPE;
BEGIN
 
   SELECT * INTO gameRow FROM games WHERE id=gameId;
   SELECT * INTO hostTeam FROM teams WHERE id=gameRow.host_id;

   IF hostTeam IS NOT NULL AND hostTeam.owner_id = userId AND  gameRow IS NOT NULL THEN
   DELETE FROM games WHERE id=gameId;
   END IF;

   COMMIT;
END;$$;
 H   DROP PROCEDURE public.deletegame(IN userid integer, IN gameid integer);
       public          postgres    false            �            1255    16667 "   deleteinvitation(integer, integer) 	   PROCEDURE       CREATE PROCEDURE public.deleteinvitation(IN invid integer, IN userid integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
   invitation invitations%ROWTYPE;
BEGIN
 
   SELECT * INTO invitation FROM invitations WHERE id=invId AND  user_id=userId;

   IF invitation IS NOT NULL AND invitation.user_id = userId  THEN
   DELETE FROM invitations WHERE id=invId;
   END IF;

   COMMIT;
END;$$;
 M   DROP PROCEDURE public.deleteinvitation(IN invid integer, IN userid integer);
       public          postgres    false            �            1255    16665    deleteteam(integer, integer) 	   PROCEDURE     +  CREATE PROCEDURE public.deleteteam(IN teamid integer, IN userid integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
   team teams%ROWTYPE;
BEGIN
 
   SELECT * INTO team FROM teams WHERE id=teamId;

   IF team.owner_id = userId THEN
   DELETE FROM teams where id = teamId;
   END IF;

   COMMIT;
END;$$;
 H   DROP PROCEDURE public.deleteteam(IN teamid integer, IN userid integer);
       public          postgres    false            �            1255    16673    rejectgame(integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE public.rejectgame(IN userid integer, IN gameid integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
   opponentTeam teams%ROWTYPE;
   gameRow games%ROWTYPE;
BEGIN
 
   SELECT * INTO gameRow FROM games WHERE id=gameId;
   SELECT * INTO opponentTeam FROM teams WHERE id=gameRow.opponent_id;
      
   IF opponentTeam IS NOT NULL AND opponentTeam.owner_id = userId AND  gameRow IS NOT NULL THEN
      UPDATE games SET  status = 'Rejected' WHERE id=gameId;
   END IF;

   COMMIT;
END;$$;
 H   DROP PROCEDURE public.rejectgame(IN userid integer, IN gameid integer);
       public          postgres    false            �            1255    16669 "   rejectinvitation(integer, integer) 	   PROCEDURE     �  CREATE PROCEDURE public.rejectinvitation(IN invid integer, IN userid integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
   invitation invitations%ROWTYPE;
   team teams%ROWTYPE;
BEGIN
 
   SELECT * INTO invitation FROM invitations WHERE id=invId;
   SELECT * INTO team FROM teams WHERE teams.id = invitation.team_id;

   IF invitation IS NOT NULL AND team IS NOT NULL AND team.owner_id=userId THEN
   UPDATE invitations SET  status = 'Rejected' WHERE id=invId;
   END IF;

   COMMIT;
END;$$;
 M   DROP PROCEDURE public.rejectinvitation(IN invid integer, IN userid integer);
       public          postgres    false            �            1259    16646    games    TABLE       CREATE TABLE public.games (
    id integer NOT NULL,
    host_id integer NOT NULL,
    opponent_id integer NOT NULL,
    place character varying(31) NOT NULL,
    date timestamp with time zone NOT NULL,
    status public.status DEFAULT 'Pending'::public.status
);
    DROP TABLE public.games;
       public         heap    postgres    false    855    855            �            1259    16644    games_host_id_seq    SEQUENCE     �   CREATE SEQUENCE public.games_host_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.games_host_id_seq;
       public          postgres    false    220            ]           0    0    games_host_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.games_host_id_seq OWNED BY public.games.host_id;
          public          postgres    false    218            �            1259    16643    games_id_seq    SEQUENCE     �   CREATE SEQUENCE public.games_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.games_id_seq;
       public          postgres    false    220            ^           0    0    games_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.games_id_seq OWNED BY public.games.id;
          public          postgres    false    217            �            1259    16645    games_opponent_id_seq    SEQUENCE     �   CREATE SEQUENCE public.games_opponent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.games_opponent_id_seq;
       public          postgres    false    220            _           0    0    games_opponent_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.games_opponent_id_seq OWNED BY public.games.opponent_id;
          public          postgres    false    219            �            1259    16682    invitations    TABLE     �   CREATE TABLE public.invitations (
    id integer NOT NULL,
    user_id integer NOT NULL,
    team_id integer NOT NULL,
    status public.status DEFAULT 'Pending'::public.status NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);
    DROP TABLE public.invitations;
       public         heap    postgres    false    855    855            �            1259    16679    invitations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.invitations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.invitations_id_seq;
       public          postgres    false    225            `           0    0    invitations_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.invitations_id_seq OWNED BY public.invitations.id;
          public          postgres    false    222            �            1259    16681    invitations_team_id_seq    SEQUENCE     �   CREATE SEQUENCE public.invitations_team_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.invitations_team_id_seq;
       public          postgres    false    225            a           0    0    invitations_team_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.invitations_team_id_seq OWNED BY public.invitations.team_id;
          public          postgres    false    224            �            1259    16680    invitations_user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.invitations_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.invitations_user_id_seq;
       public          postgres    false    225            b           0    0    invitations_user_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.invitations_user_id_seq OWNED BY public.invitations.user_id;
          public          postgres    false    223            �            1259    16588    teams    TABLE     N  CREATE TABLE public.teams (
    id integer NOT NULL,
    owner_id integer NOT NULL,
    title character varying(31) NOT NULL,
    city character varying(31) NOT NULL,
    game public.sports NOT NULL,
    description character varying(511) NOT NULL,
    image character varying(255) NOT NULL,
    members integer DEFAULT 1 NOT NULL
);
    DROP TABLE public.teams;
       public         heap    postgres    false    852            �            1259    16586    teams_id_seq    SEQUENCE     �   CREATE SEQUENCE public.teams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.teams_id_seq;
       public          postgres    false    213            c           0    0    teams_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;
          public          postgres    false    211            �            1259    16587    teams_owner_id_seq    SEQUENCE     �   CREATE SEQUENCE public.teams_owner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.teams_owner_id_seq;
       public          postgres    false    213            d           0    0    teams_owner_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.teams_owner_id_seq OWNED BY public.teams.owner_id;
          public          postgres    false    212            �            1259    16538    users    TABLE     �  CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(63) NOT NULL,
    username character varying(63) NOT NULL,
    password character varying(255) NOT NULL,
    name character varying(31) DEFAULT 'User'::character varying NOT NULL,
    surname character varying(31) DEFAULT 'Anonymous'::character varying NOT NULL,
    avatar character varying(255) DEFAULT 'default_avatar.png'::character varying NOT NULL,
    phone character varying(15) DEFAULT '-'::character varying NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    16537    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    210            e           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    209            �            1259    16605    users_teams    TABLE     `   CREATE TABLE public.users_teams (
    user_id integer NOT NULL,
    team_id integer NOT NULL
);
    DROP TABLE public.users_teams;
       public         heap    postgres    false            �            1259    16604    users_teams_team_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_teams_team_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.users_teams_team_id_seq;
       public          postgres    false    216            f           0    0    users_teams_team_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_teams_team_id_seq OWNED BY public.users_teams.team_id;
          public          postgres    false    215            �            1259    16603    users_teams_user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_teams_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.users_teams_user_id_seq;
       public          postgres    false    216            g           0    0    users_teams_user_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_teams_user_id_seq OWNED BY public.users_teams.user_id;
          public          postgres    false    214            �            1259    16674    v_games_teams    VIEW     �  CREATE VIEW public.v_games_teams AS
 SELECT host.title AS host_title,
    host.owner_id AS host_owner,
    games.host_id,
    games.id,
    games.place,
    games.date,
    games.status,
    opponent.title AS opponent_title,
    opponent.owner_id AS opponent_owner,
    games.opponent_id
   FROM ((public.games
     LEFT JOIN public.teams host ON ((host.id = games.host_id)))
     RIGHT JOIN public.teams opponent ON ((opponent.id = games.opponent_id)));
     DROP VIEW public.v_games_teams;
       public          postgres    false    213    213    213    220    220    220    220    220    220    855            �            1259    16702    v_teams_invitations    VIEW     p  CREATE VIEW public.v_teams_invitations AS
 SELECT invitations.id,
    invitations.user_id,
    invitations.team_id,
    invitations.status,
    invitations.created_at,
    teams.owner_id,
    teams.title,
    teams.city,
    teams.image,
    teams.game,
    teams.members
   FROM (public.invitations
     LEFT JOIN public.teams ON ((teams.id = invitations.team_id)));
 &   DROP VIEW public.v_teams_invitations;
       public          postgres    false    213    213    213    213    213    213    213    225    225    225    225    225    852    855            �            1259    16707    v_users_invitations    VIEW     �  CREATE VIEW public.v_users_invitations AS
 SELECT invitations.id,
    invitations.user_id,
    invitations.team_id,
    teams.owner_id,
    invitations.status,
    invitations.created_at,
    users.email,
    users.username,
    users.name,
    users.surname,
    users.avatar,
    users.phone
   FROM ((public.invitations
     LEFT JOIN public.users ON ((users.id = invitations.user_id)))
     LEFT JOIN public.teams ON ((teams.id = invitations.team_id)));
 &   DROP VIEW public.v_users_invitations;
       public          postgres    false    225    210    213    225    225    225    225    213    210    210    210    210    210    210    855            �           2604    16649    games id    DEFAULT     d   ALTER TABLE ONLY public.games ALTER COLUMN id SET DEFAULT nextval('public.games_id_seq'::regclass);
 7   ALTER TABLE public.games ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    220    220            �           2604    16650    games host_id    DEFAULT     n   ALTER TABLE ONLY public.games ALTER COLUMN host_id SET DEFAULT nextval('public.games_host_id_seq'::regclass);
 <   ALTER TABLE public.games ALTER COLUMN host_id DROP DEFAULT;
       public          postgres    false    220    218    220            �           2604    16651    games opponent_id    DEFAULT     v   ALTER TABLE ONLY public.games ALTER COLUMN opponent_id SET DEFAULT nextval('public.games_opponent_id_seq'::regclass);
 @   ALTER TABLE public.games ALTER COLUMN opponent_id DROP DEFAULT;
       public          postgres    false    219    220    220            �           2604    16685    invitations id    DEFAULT     p   ALTER TABLE ONLY public.invitations ALTER COLUMN id SET DEFAULT nextval('public.invitations_id_seq'::regclass);
 =   ALTER TABLE public.invitations ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    225    222    225            �           2604    16686    invitations user_id    DEFAULT     z   ALTER TABLE ONLY public.invitations ALTER COLUMN user_id SET DEFAULT nextval('public.invitations_user_id_seq'::regclass);
 B   ALTER TABLE public.invitations ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    223    225    225            �           2604    16687    invitations team_id    DEFAULT     z   ALTER TABLE ONLY public.invitations ALTER COLUMN team_id SET DEFAULT nextval('public.invitations_team_id_seq'::regclass);
 B   ALTER TABLE public.invitations ALTER COLUMN team_id DROP DEFAULT;
       public          postgres    false    224    225    225            �           2604    16591    teams id    DEFAULT     d   ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);
 7   ALTER TABLE public.teams ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    211    213    213            �           2604    16592    teams owner_id    DEFAULT     p   ALTER TABLE ONLY public.teams ALTER COLUMN owner_id SET DEFAULT nextval('public.teams_owner_id_seq'::regclass);
 =   ALTER TABLE public.teams ALTER COLUMN owner_id DROP DEFAULT;
       public          postgres    false    213    212    213            �           2604    16541    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    210    210            �           2604    16608    users_teams user_id    DEFAULT     z   ALTER TABLE ONLY public.users_teams ALTER COLUMN user_id SET DEFAULT nextval('public.users_teams_user_id_seq'::regclass);
 B   ALTER TABLE public.users_teams ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    214    216    216            �           2604    16609    users_teams team_id    DEFAULT     z   ALTER TABLE ONLY public.users_teams ALTER COLUMN team_id SET DEFAULT nextval('public.users_teams_team_id_seq'::regclass);
 B   ALTER TABLE public.users_teams ALTER COLUMN team_id DROP DEFAULT;
       public          postgres    false    215    216    216            R          0    16646    games 
   TABLE DATA           N   COPY public.games (id, host_id, opponent_id, place, date, status) FROM stdin;
    public          postgres    false    220   �x       V          0    16682    invitations 
   TABLE DATA           O   COPY public.invitations (id, user_id, team_id, status, created_at) FROM stdin;
    public          postgres    false    225   �x       K          0    16588    teams 
   TABLE DATA           ]   COPY public.teams (id, owner_id, title, city, game, description, image, members) FROM stdin;
    public          postgres    false    213   �x       H          0    16538    users 
   TABLE DATA           \   COPY public.users (id, email, username, password, name, surname, avatar, phone) FROM stdin;
    public          postgres    false    210   �x       N          0    16605    users_teams 
   TABLE DATA           7   COPY public.users_teams (user_id, team_id) FROM stdin;
    public          postgres    false    216   y       h           0    0    games_host_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.games_host_id_seq', 1, false);
          public          postgres    false    218            i           0    0    games_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.games_id_seq', 1, false);
          public          postgres    false    217            j           0    0    games_opponent_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.games_opponent_id_seq', 1, false);
          public          postgres    false    219            k           0    0    invitations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.invitations_id_seq', 1, false);
          public          postgres    false    222            l           0    0    invitations_team_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invitations_team_id_seq', 1, false);
          public          postgres    false    224            m           0    0    invitations_user_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invitations_user_id_seq', 1, false);
          public          postgres    false    223            n           0    0    teams_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.teams_id_seq', 1, false);
          public          postgres    false    211            o           0    0    teams_owner_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.teams_owner_id_seq', 1, false);
          public          postgres    false    212            p           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 1, false);
          public          postgres    false    209            q           0    0    users_teams_team_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.users_teams_team_id_seq', 1, false);
          public          postgres    false    215            r           0    0    users_teams_user_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.users_teams_user_id_seq', 1, false);
          public          postgres    false    214            �           2606    16654    games games_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.games DROP CONSTRAINT games_pkey;
       public            postgres    false    220            �           2606    16691    invitations invitations_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.invitations DROP CONSTRAINT invitations_pkey;
       public            postgres    false    225            �           2606    16597    teams teams_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.teams DROP CONSTRAINT teams_pkey;
       public            postgres    false    213            �           2606    16551    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public            postgres    false    210            �           2606    16549    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    210            �           2606    16611    users_teams users_teams_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.users_teams
    ADD CONSTRAINT users_teams_pkey PRIMARY KEY (user_id, team_id);
 F   ALTER TABLE ONLY public.users_teams DROP CONSTRAINT users_teams_pkey;
       public            postgres    false    216    216            �           2606    16553    users users_username_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key;
       public            postgres    false    210            �           2606    16655    games games_host_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_host_id_fkey FOREIGN KEY (host_id) REFERENCES public.teams(id) ON UPDATE CASCADE ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.games DROP CONSTRAINT games_host_id_fkey;
       public          postgres    false    220    213    3243            �           2606    16660    games games_opponent_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_opponent_id_fkey FOREIGN KEY (opponent_id) REFERENCES public.teams(id) ON UPDATE CASCADE ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.games DROP CONSTRAINT games_opponent_id_fkey;
       public          postgres    false    220    213    3243            �           2606    16697 $   invitations invitations_team_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON UPDATE CASCADE ON DELETE CASCADE;
 N   ALTER TABLE ONLY public.invitations DROP CONSTRAINT invitations_team_id_fkey;
       public          postgres    false    3243    213    225            �           2606    16692 $   invitations invitations_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 N   ALTER TABLE ONLY public.invitations DROP CONSTRAINT invitations_user_id_fkey;
       public          postgres    false    210    3239    225            �           2606    16598    teams teams_owner_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.teams DROP CONSTRAINT teams_owner_id_fkey;
       public          postgres    false    3239    210    213            �           2606    16617 $   users_teams users_teams_team_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.users_teams
    ADD CONSTRAINT users_teams_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON UPDATE CASCADE ON DELETE CASCADE;
 N   ALTER TABLE ONLY public.users_teams DROP CONSTRAINT users_teams_team_id_fkey;
       public          postgres    false    216    3243    213            �           2606    16612 $   users_teams users_teams_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.users_teams
    ADD CONSTRAINT users_teams_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
 N   ALTER TABLE ONLY public.users_teams DROP CONSTRAINT users_teams_user_id_fkey;
       public          postgres    false    216    3239    210            R      x������ � �      V      x������ � �      K      x������ � �      H      x������ � �      N      x������ � �     