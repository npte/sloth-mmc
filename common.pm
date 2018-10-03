# vim: ts=4 syn=perl:
# $Id: sample.mmcrc,v 1.2 2000/05/16 12:00:22 mike Exp $ # Bookmarks: 0,0 0,0 0,0 0,0 0,0 0,0 0,0 0,0 0,0 37,422 # Bookmarks: 0,0 0,0 0,0 0,0 0,0 0,0 0,0 0,0 0,0 1,424 # Bookmarks: 0,0 0,0 0,0 0,0 0,0 0,0 0,0 0,0 0,0 0,424; CollapsedSubs: CMD
# ��������� ������� ������

use Pinger;
#use Loopback;
##use Net::OSCAR;
use Char;
use DateTime;
use DateTime::Format::XSD;

my $mmc = $ENV{MMC} || $ENV{MMC} || $ENV{HOME} || '.';

# �������� ��� � ���� $MMC/<����>.log
my @Time = localtime;
$Time[4]=$Time[4]+1;
my $day=""; if ($Time[3] < 10) { $day = sprintf("%02d",$Time[3]); } else { $day = sprintf("%2d",$Time[3]); }
my $mon=""; if ($Time[4] < 10) { $mon = sprintf("%02d",$Time[4]); } else { $mon = sprintf("%2d",$Time[4]); }
MUD::logopen( sprintf ("./logs/$Char::my_name-%2d-$mon-$day.log", $Time[5]+1900 ) );
setArenaStatus("ARENA_STATUS_WAITING_FOR_NEXT_FIGHT");



CMD::cmd_ticksize(63);CMD::cmd_tickset;

CL::statusconf( $Conf::status_type, $Conf::status_height=3 );

#my $player = "mplayer";
#my $wave_path = "c:\windows\media";

### Color table
#        Color                          Code
#        ===========================
#        Black                          \003A
#        Red                            \003B
#        Green                          \003C
#        Brown                          \003D
#        Darkblue                       \003E
#        Magenta                        \003F
#        Blue                           \003G
#        Lightgray                      \003H
#        Gray                           \003I
#        Lightred                       \003J
#        Lightgreen                     \003K
#        Yellow                         \003L
#        Lightblue                      \003M
#        Lightmagenta                   \003N
#        Cyan                           \003O
#        White                          \003P
# У вас цвета могут быть и иными

#        Переменные, определенные как $U::var, будут потом доступны из клиента
#        как $var. Определять их не обязательно (можно сразу использовать), но
#        если сразу определить имена, то потом сложнее запутаться


$U::key_mode = "move";

$U::gods = "\003A";
$U::wraith = "\003A";
$U::spectral = "\003A";
$U::sanc = "\003A";
$U::aegis = "\003A";
$U::wall = "\003A";
$U::cloak = "\003A";
$U::darkness = "\003A";
$U::stone = "\003A";
$U::iron = "\003A";
$spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE\003A/".$U::iron."IRON";
$U::regen = "\003I";
$U::ac = "\003C";
$U::damage = "\003I";
$U::rent = "\003I";
$mode_keys = "\003I[F1:".$U::regen."REGEN\003I  F2:".$U::damage."Damage\003I  F3:".$U::ac."AC\003I  F4:".$U::rent."RENT\003I]";
$U::tank = $Char::my_name;
$U::target = undef;
$U::fight = 0;
$U::leader = undef;
$U::prefix = undef;

$U::total_exp = 0;
$U::gold = 0;

#WHEEL
$U::winner = "";
$U::max_roll = 0;
###

%U::triggers = (
TANKING => "ENABLE",
FOOD => "ENABLE",
AUTORESPELL => "ENABLE",
AUTOKICK => "DISABLE",
AUTOBLAST => "DISABLE",
FUNNYSUBST => "DISABLE",
AUTOSTUN => "DISABLE",
AUTOSTRIKE => "DISABLE",
AUTOGRIP => "DISABLE",
AUTOBROAD => "DISABLE"
);

#MUD colors
$U::mcLight = "\\a02";
$U::mcDrop =  "\\a01";
$U::mcRed = "\\c04";
$U::mcGreen = "\\c15";
$U::mcYellow = "\\c06";
$U::mcBlue = "\\c16";
$U::mcMagenta = "\\c05";
$U::mcCyan = "\\c11";
$U::mcGray = "\\c01";

nosave(qw(recall_container, food_container, my_name, leader, tank, target, fight, mode, spells));

### Добавляем переменные в строку состояния. Параметры: имя переменной,
#        ширина поля в символах и, возможно, порядковый номер цвета, которым
#        отображать текст.
#        После добавления переменной в строку состояния ей надо присвоить
#        новое значение.

$crap = ' ';
new_svy("   ", 1, 3, 3);
new_sv($U::align,7);
new_sv("Target:", 8);
new_sv($U::target, 25, 3);
new_sv("Loot:", 6);
new_sv($Sloot, 7, 3);
new_sv($Flags, 8, 9);
new_sv($U::_ticker, 13);
new_sv("    ", 4);
new_sv($U::total_exp, 9, 3);
new_sv($U::gold, 11, 5);
new_sv($U::room,10);
new_sv($U::ac,20);
new_svy($spells,1);
new_svy($mode_keys,2);

### Внутренние переменные.
my $loot = 0;
# off, coins, all, greedy
$Sloot = "coins";
$Flags = ' 'x8;
my $who_lines = 0;
my $user = 0;
my ($group_lines, $group_members);

### Вспомогательные процедуры
sub get_color($$) {
# Параметры: строка с цветами в формате внутренних цветов mmc
# и номер символа в ней.
# Возвращаемое значение: цвет этого символа в диапазоне A..P
               echo ($_[1]);
        return chr(ord(substr($_[0], 2*$_[1]+1, 1))+ord('A'));
}

my %flags = (
        P => 0,                 #poison
        W => 1,                 #web
        B => 2,                 #bash
        C => 3,
        S => 4,                 #Silence
        R => 5,
        D => 6,
        Z => 7,
);

sub Fset(*) {
        substr($Flags, $flags{$_[0]}, 1) = $_[0] if defined $flags{$_[0]};
}

sub Fclear(*) {
        substr($Flags, $flags{$_[0]}, 1) = ' ' if defined $flags{$_[0]};
}

sub cut {
        if ($_[0] < 10000) {
                $_[0];
        } elsif($_[0] < 10_000_000) {
                "" . int($_[0] / 1000) . "k";
        } else {
                "" . int($_[0] / 1000000 ) . "M";
        }
}

# Определим себе еще несколько команд
# перед каждой командой надо ставить префикс CMD::cmd_
sub CMD::cmd_autos {
 foreach $i (keys(%U::triggers))
  {
   echo("$i &U::triggers[$i]");
  };
}


my @books;
my $book;

sub CMD::cmd_lread {
	@books = @_;
	if (defined($book = shift @books)){
		sendl("read $book")
	}
}

trig {
	sendl("read $book")
} 'You finish reading .+, and close the cover', '1000n:AUTOREAD';

trig {
	if (defined($book = shift @books)){
		sendl("read $book")
	}
} 'You have read .+ for the very last time!', '1000n:AUTOREAD';

sub CMD::cmd_target {
 $U::target = $_[0];
}

sub CMD::cmd_gtarget {
 $U::target = $_[0];
 sendl("gt target $U::target")

}

sub CMD::cmd_leader {
$U::leader = $_[0];
$U::prefix = $_[1];
}

sub CMD::cmd_tank {
 $U::tank = $_[0];
}

sub CMD::cmd_holdfrontline {
 $Char::holdfrontline=!($Char::holdfrontline);
 if ($Char::holdfrontline) { echo("I will hold front line!"); } else { echo("I will watch group from back!"); };
}

sub CMD::cmd_loot {
# Настройка автоматического обирания трупов
# Параметры:    off         - выключить
#               pile        - вынимать деньги из трупов убитых мной врагов
#               on = all    - вынимать все из трупов убитых мной врагов
#               greedy      - вынимать деньги из всех трупов по дороге,
#                             подбирать валяющиеся деньги
        if (lc($_[0]) eq 'off') {
                $loot = 0;
                $Sloot = "off";
        } elsif (lc($_[0]) eq 'coins') {
                $loot = 1;
                $Sloot = "coins";
        } elsif (lc($_[0]) eq 'all' or lc($_[0]) eq 'on') {
                $loot = 2;
                $Sloot = "all";
        } elsif (lc($_[0]) eq 'greedy') {
                $loot = 3;
                $Sloot = "greedy";
        } else {
                msg($Sloot);
        }
}

# обираем труп
trig {
        if ($loot == 0) {
                sendl("exa corpse");
        } elsif ($loot == 1) {
                sendl("get gold corpse");
                sendl("exa corpse");
        } elsif ($loot >= 2) {
                sendl("get all corpse") unless $user;
        }
} '^You received [0-9]+ experience points', '2000fn:LOOT';

### Триггеры.
# Триггеру передаются запрошенные совпадения ($1-$9) и пришедшая от
# сервера строка, на которую этот триггер настроен. (На самом деле
# триггеру передаются 2 строки: $_ - это строка без цветов, и $; -
# строка с цветами во внутреннем формате mmc.) Триггер МОЖЕТ изменять
# эти строки, но:
#        1) это не рекомендуется
#        2) если триггер изменяет строки, он должен сам следить за соответствием
#                строк $_ и $;
# Кроме того, существует специальная переменная, $:. Из нее нельзя читать,
# но ей можно присваивать, и если ей присвоить строку с цветами, то эта
# строка попадет и в $;, а в $_ будет записана эта же строка без цветов.
# В переменной $~ хранится переменная, которая будет записана в лог.
# ЕЕ тоже можно менять, а если ей присвоить undef, то в лог не будет записано
# ничего.
# Общая идея назначения приоритетов триггерам такая:
# Триггеры с приоритетом выше 2000 заканчивают отложенные события.
# Назначение приоритетов выше 2000 должно производиться крайне осторожно.
# Ни один триггер с приоритетом выше 1500 не должен изменять строку или
# прерывать обработку.
# Триггеры, не удовлетворяющие этому условию, но делающие особо важную
# работу или настроенные на строки, точно никому больше не нужные, имеют
# приоритет от 1000 до 1500.
# Приоритет ниже 1000 имеют триггеры, удаляющие с экрана спам.
#0 PS: Вы можете придумать свою систему приоритетов.

#########################################################################
#                      Триггер на prompt                                #
#########################################################################
trig {
 $; = substr($;,0,(index($;,">")+2));
 $_ = substr($_,0,(index($_,">")+2));
 $U::current_hp = $1;
 $U::current_mana = $2;
 $U::total_exp = $4;
 $U::gold = $5;
 $U::align = $6;
 $U::room = $8;
 $U::ac = $9;
 if ( $U::align == 0 ) { $U::align = "N $U::align" };
 if ( ($U::align >= -3) && ($U::align < 0) ) { $U::align = "e $U::align" };
 if ( $U::align < -3 ) { $U::align = "E $U::align" };
 if ( ($U::align <= 3) && ($U::align > 0) ) { $U::align = "g $U::align" };
 if ( $U::align > 3 ) { $U::align = "G $U::align" };
 $U::total_exp =~ s/,//g; $U::total_exp = cut($U::total_exp);
 $U::gold =~ s/,//g; $U::gold = cut ($U::gold);
 if ( scalar(@currentBuffs) > 0 ) {
 disable("AUTOBUFFCORE"); disable('AUTOBUFF'); rebuff();
 }

#  foreach (@currentBuff) {
#            echo $_;
#  }
} '^<(\-?[0-9]+)hp\/[0-9]+hp ([0-9]+)ma\/[0-9]+ma [0-9]+mv\/[0-9]+mv (\-|[0-9]+)>\[([0-9,]+) ([0-9,]+) ([-+][0-9]+) ([-+][0-9]+) ([a-z]+) ([-]{0,1}[0-9]+\.[0-9]+)\]', '1400n:PROMPT';

trig {
 $U::total_exp=cut($1)." xp";
} '^You have (\d+) unused experience points\.$', '1000n:COUNT';

trig {
 $U::gold=cut($1)." coins";
} '^You have (\d+) gold coins\.$', '1000n:COUNT';

#Мои триггеры.
#Group

#rolling
trig {
   $total = $1 + $2 + $3 + $4 + $5;
   echo("\003L--- Total stats: $total");
} 'Str: \d+\[(\d+)\], Int: \d+\[(\d+)\], Wis: \d+\[(\d+)\], Dex: \d+\[(\d+)\], Con: \d+\[(\d+)\]', '1000n-:REROLL';


trig {
	sendl("resc $1\r\nresc $1");
} '^.+ disengages himself, and attacks (\w+)!$',"2000n-:TANKING";

trig {
	sendl("resc $1\r\nresc $1");
} '^SEEK SHELTER AT ONCE!  (\w+) has begun to sing\.$',"2000n-:TANKING";

#trigger na target
trig {
#  echo("$U::$leader.".".$U::$prefix.".".$U::$target");
#  echo("$1.".".$2.");
 if (($1 eq $U::leader) and (($2 eq $U::prefix." ") or ($U::prefix eq ""))) {
  $U::target = "$3" }
} '^(\w+) -- \'([\s\S]*)target ([a-zA-Z0-9\.\-]+)\'',"2000n:GROUP";

#trigger na all up
trig {
 if (($1 eq $U::leader) and (($2 eq $U::prefix." ") or ($U::prefix eq ""))) {
  sendl("wake\r\nstand");
 }
} '^(\w+) -- \'([\s\S]*)all up\'',"2000n:GROUP";

#trigger na catch
trig {
 if (($1 eq $U::leader) and (($2 eq $U::prefix." ") or ($U::prefix eq ""))) {
  sendl("sleep");
 }
} '^(\w+) -- \'([\s\S]*) catch\'',"2000n:GROUP";

#triggeri na sneak/stalk
#trig {
# if (($1 eq $U::leader) and (($2 eq " ".$U::prefix) or ($U::prefix eq ""))) {
#  sendl("sneak\r\nsneak\r\nsneak");
# }
#} '^(\w+) -- \'([\s\S]*) all sneak\'',"2000n:GROUP";

trig {
 if (($1 eq $U::leader) and (($2 eq " ".$U::prefix) or ($U::prefix eq ""))) {
  sendl("sneak\r\nsneak\r\nsneak");
 }
} '^(\w+) -- \'([\s\S]*) sneak\'',"2000n:GROUP";

trig {
 if (($1 eq $U::leader) and (($2 eq " ".$U::prefix) or ($U::prefix eq ""))) {
  sendl("stalk");
 }
} '^(\w+) -- \'([\s\S]*) stalk\'',"2000n:GROUP";

trig {
 if ($Char::holdfrontline) { sendl("man up"); } else { sendl("man back"); }
} '^Your front line collapses!  Your group is thrown into chaos!$|^You stumble as you try to move to the rear of the group\.$',"2000n:GROUP";

#Rogue yells 'KISS UR ARSE GOOD-BYE'
trig {
 if ($1 eq $U::tank) { sendl("warcry $2"); }
} '^(\w+) yells \'(.+)\'$',"2000n:GROUP";

#trig {
#
#} '^You have 6(572) hit, 58(426) mana and 176(166) movement points.',"2000n:COMM"

#modnii track
alias {$U::trackmob=$_[0];sendl("track $U::trackmob")} tra;

trig {
 sendl("$1");sendl("track $U::trackmob");
} 'lead (\w+)ward.$', "2000n:SWALK";


#PINGER
hook {
	Pinger::ping_proceed;
	if (getArenaStatus() eq "ARENA_STATUS_WAITING_FOR_NEXT_FIGHT") {
		sendl("wake\r\nstand\r\ncheck hourglass");
	}
	if (getArenaStatus() ne "ARENA_STATUS_WAITING_FOR_NEXT_FIGHT") {
		$U::ticks_waiting_for_orb = $U::ticks_waiting_for_orb + 1;
    if ($U::ticks_waiting_for_orb > 4) {
  		$U::ticks_waiting_for_orb = 0;
  		sendl("where");
  	}
	}

} "tick";


sub CMD::cmd_pingerhelp {
        echo("/pingtome");
        echo("/pingtogroup");
        echo("/showstatus");
        echo("/addmob");
        echo("/showlist");
        echo("/showlistback");
        echo("/remmobname");
        echo("/showmobname");

};

sub CMD::cmd_pingtome { Pinger::ping_to_me; };
sub CMD::cmd_pingtogroup { Pinger::ping_to_group; };
sub CMD::cmd_showstatus { Pinger::show_status; };
sub CMD::cmd_addmob { Pinger::add_mob(@_); };
sub CMD::cmd_showlist { Pinger::show_list(); };
sub CMD::cmd_showlistback { Pinger::show_list_background() };
sub CMD::cmd_remmobname { Pinger::del_mob_by_name(@_); };
sub CMD::cmd_showmobname { Pinger::show_mob_name(@_); };


trig {
	Pinger::mob_up("$1");
	if ( $U::botting == 1 ) {
		$U::target = $1;
		sendl ("hunt $U::target");
	}
} '^You tell .+ \'##pinger## (.+)\'$',"2000n:PINGER";

trig {
	if ( $U::botting == 1 ) {
		sendl ("strike $U::target");
	}
} '^\(The trail is seconds old!\)$',"2000n:BOTTING";

trig {
	if ( $U::botting == 1 ) {
		sendl ("strike $U::target");
	}
} '^Oh, that was a real tough search\. Open your eyes bozo\.$',"2000n:BOTTING";

trig { Pinger::mobs_down; } '^You tell the Innkeeper \'##pingerend##\'$',"2000n:PINGER";


#Eirok s neirokom!

#An eirok has arrived.

#Тикер
#Погода
trig {CMD::cmd_tickset;Pinger::ping_proceed;} '^It starts to rain', "1000n:TICK";
trig {CMD::cmd_tickset;Pinger::ping_proceed;} '^The rain stopped', "1000n:TICK";
trig {CMD::cmd_tickset;Pinger::ping_proceed;} '^The sky is getting', "1000n:TICK";
trig {CMD::cmd_tickset;Pinger::ping_proceed;} '^The sun slowly', "1000n:TICK";
trig {CMD::cmd_tickset;Pinger::ping_proceed;} '^The night has begun', "1000n:TICK";
trig {CMD::cmd_tickset;Pinger::ping_proceed;} '^The sun rises', "1000n:TICK";
trig {CMD::cmd_tickset;Pinger::ping_proceed;} '^The clouds disappear', "1000n:TICK";
trig {CMD::cmd_tickset;Pinger::ping_proceed;} '^Lightning starts', "1000n:TICK";
trig {CMD::cmd_tickset;Pinger::ping_proceed;} '^The day has begun', "1000n:TICK";
trig {CMD::cmd_tickset;Pinger::ping_proceed;} '^The lightning has stopped', "1000n:TICK";
#Misc
#trig {CMD::cmd_tickset} '^The portal flashes once, then shrinks and vanishes', "1000n:COMM";

trig {
	#if ($U::sleeping eq 3) {sendl ("wake\r\nget food $U::food_container\r\neat food\r\nslee")}
	#else {sendl ("get food $U::food_container\r\neat food")}
	if (getArenaStatus() eq "ARENA_STATUS_WAITING_FOR_NEXT_FIGHT") {
		sendl ("wake\r\nstand\r\ncast 'create food'\r\nget food\r\neat food\r\nslee");
	}
} '^You are hungry', "n:FOOD";

trig {
	if (getArenaStatus() eq "ARENA_STATUS_WAITING_FOR_NEXT_FIGHT") {
		sendl ("wake\r\nstand\r\ncast 'create water' $Char::water_container\r\ndri $Char::water_container\r\nslee")
	} else {
		if ($U::sleeping eq 3) {
			sendl ("wake\r\ndri $Char::water_container\r\nslee")
		} else {
			sendl ("dri $Char::water_container")
		}
	}
} '^You are thirsty', "n:FOOD";

#Spells
#trig {
# CMD::cmd_tickset;
#} '^Your fly spell just', "1000n:COMM";

trig {
 if ($U::sleeping eq 3) {sendl ("wake\r\nstand\r\ncast '$Char::bless' $Char::my_name\r\nslee")};
 if ($U::sleeping eq 2) {sendl ("stand\r\ncast '$Char::bless' $Char::my_name\r\nrest")};
 if ($U::sleeping eq 1) {sendl ("stand\r\ncast '$Char::bless' $Char::my_name\r\nrest")};
 if ($U::sleeping eq 0) {sendl ("cast '$Char::bless' $Char::my_name")};
} '^You feel less righteous\\.$', "1000n:AUTORESPELL";

trig {
 if ($U::sleeping eq 3) {sendl ("wake\r\nstand\r\ncast 'detect magic'\r\nslee")};
 if ($U::sleeping eq 2) {sendl ("stand\r\ncast 'detect magic'\r\nrest")};
 if ($U::sleeping eq 1) {sendl ("stand\r\ncast 'detect magic'\r\nrest")};
 if ($U::sleeping eq 0) {sendl ("cast 'detect magic'")};
} '^The detect magic wears off\\.$', "1000n:AUTORESPELL";

trig {
 if ($U::sleeping eq 3) {sendl ("wake\r\nstand\r\ncast 'detect invis'\r\nslee")};
 if ($U::sleeping eq 2) {sendl ("stand\r\ncast 'detect invis'\r\nrest")};
 if ($U::sleeping eq 1) {sendl ("stand\r\ncast 'detect invis'\r\nrest")};
 if ($U::sleeping eq 0) {sendl ("cast 'detect invis'")};
} '^Your detect invisibility wears off\\.$', "1000n:AUTORESPELL";

trig {
 if ($U::sleeping eq 3) {sendl ("wake\r\nstand\r\ncast '$Char::armor' $Char::my_name\r\nslee")};
 if ($U::sleeping eq 2) {sendl ("stand\r\ncast '$Char::armor' $Char::my_name\r\nrest")};
 if ($U::sleeping eq 1) {sendl ("stand\r\ncast '$Char::armor' $Char::my_name\r\nrest")};
 if ($U::sleeping eq 0) {sendl ("cast '$Char::armor' $Char::my_name")};
} '^You feel less protected\\.$|^The armor of bones crumbles to dust\\.$', "1000fn:AUTORESPELL";

#trig {
# if ($U::sleeping eq 3) {sendl ("wake\r\nstand\r\ncast 'stre'\r\nslee")};
# if ($U::sleeping eq 2) {sendl ("stand\r\ncast 'stre'\r\nrest")};
# if ($U::sleeping eq 1) {sendl ("stand\r\ncast 'stre'\r\nrest")};
# if ($U::sleeping eq 0) {sendl ("cast 'stre'")};
#} '^You feel weaker\\.$', "1000n:AUTORESPELL";

trig {
 sendl ("gt Beware! Magic room will close on tick!");
} '^The walls in this room start to tremble!', "1000n:COMM";

trig {
 if ($U::sleeping eq 3) {sendl ("wake\r\nstand")};
} '^As the room closes up around you', "1000n:COMM";

#trig {tickset} '', '1000n:COMM';


trig {
  sendl("stalk");
} '^Your attempt to stalk fails','1000n:COMM';

# Подсветка сильных ударов
trig {
        my $acolor = ($CMD::complist{$1} || $1 eq 'You')?"C":"N";
        if ($3 eq 'YOU') {
                $: = "\003$acolor$1\003L" . uc($2) . "\003K$3\003H$4";
                CMD::cmd_bell if $2 ne " massacres ";
        } else {
                my $wcolor = $CMD::complist{$3}?"K":"P";
                $: = "\003$acolor$1\003H" . uc($2) . "\003$wcolor$3\003H$4";
        }
} '^([^*]*)( massacres? )(.*)( with [^\']*)$', "500n:HIGHLIGHT";

## Спеллы в статус линии
trig {
 $U::gods = "\003L";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '[A-Za-z\\\']+ song engulfs you into the spirit of battle!', "1000n:COMM";

trig {
 $U::gods = "\003A";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^The song ends and you are less inspired by the deeds of the war gods\\.', "1000n:COMM";

trig {
 $U::wraith = "\003L";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^Your body slowly takes on a wraithly form, becoming insubstantial\\.', "1000n:COMM";

trig {
 $U::wraith = "\003A";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^Your body returns to solid form\\.', "1000n:COMM";

trig {
 $U::spectral = "\003L";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^You bind some nearby spectres into an undulating shield around you\\.', "1000n:COMM";

trig {
 $U::spectral = "\003A";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^The binding of the spectres wears off, and the shield they formed dissipates\\.', "1000n:COMM";

trig {
 $U::sanc = "\003L";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^You start glowing\\.', "1000n:COMM";

trig {
 $U::sanc = "\003A"; $U::cloak = "\003A"; sendl ("gt Sanc down!");
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^The white aura around your body fades\\.', "1000n:COMM";

trig {
 $U::aegis = "\003L";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^You are surrounded by a radiant light\\.', "1000n:COMM";

trig {
 $U::aegis = "\003A"; $U::cloak = "\003A"; sendl ("gt Aegis down!");
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^The radiant sphere around your body fades\\.', "1000n:COMM";

trig {
 $U::wall = "\003L";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^You are surrounded by a wall of rotting flesh\\.', "1000n:COMM";

trig {
 $U::wall = "\003A";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^The wall of flesh decays around you\\.', "1000n:COMM";

trig {
 $U::wall = "\003A";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^As you step through the protective wall of flesh, it disintegrates into a pile of goo\\.', "1000n:COMM";

trig {
 $U::cloak = "\003L";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^A dark haze precipitates around your body\\.', "1000n:COMM";

trig {
 $U::darkness = "\003L";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^A cloud of inky darkness envelops you\\.', "1000n:COMM";

trig {
 $U::darkness = "\003A";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^The inky darkness around you fades\\.', "1000n:COMM";

trig {
 $U::stone = "\003L";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^You feel your skin become much, much stronger\\.', "1000n:COMM";

trig {
 $U::stone = "\003A";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^You feel less protected\\.', "1000fn:COMM";

trig {
 $U::iron = "\003L";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^You feel your skin become much, much stronger\\.', "1000n:COMM";

trig {
 $U::iron = "\003A";
 $spells = $U::gods."GODS ".$U::wraith."WRAITH ".$U::spectral."SPECTRAL ".$U::sanc."SANC\003A/".$U::aegis."AEGIS"."\003A/".$U::wall."WALL ".$U::cloak."CLOAK ".$U::darkness."DARKNESS ".$U::stone."STONE"."\003A/".$U::iron."IRON";
} '^You feel less protected\\.', "1000n:COMM";

## Важные предупрежнения
sub HL_g {
        $: = "\003N$_";
}

sub HL_y {
        $: = "\003L$_";
}

sub HL_re {
        $: = "\003LREFLECT: \003H$_";
}

sub HL_r {
        #CMD::cmd_bell;
        $: = "\003J$_";
}

sub HL_c {
        $: = "\003G$_";
}

sub HL_w {
        $: = "\003P$_";
}

sub HL_X {
        $: = "\003X$_";
}

sub HL_Y {
        $: = "\003Y$_";
}

sub HL_Z {
        $: = "\003Z$_";
}


# Подсветка предупреждений
my @cyan_w = (
'^.+ briefly reveals a red aura$',
'^.+ is enmeshed in thick webs!$',
'^[A-Za-z]+ reac.+ out and touch.{0,2} .+, draining .+ strength\\.$',
'^.+ seems to be blinded!$',
);

#trig {
#        echo length($;);
#        echo length($_);
#} '.+', "1000n:COMMON";

# trig {
#        for ($i=0; $i<length($_); $i++) {
#                      get_color($_,$i);
#        }
# } 'Mozz Agate', "1000n:GEMS";

#subst ("Mozz Agate", "\003PMozz Agate [+1 CHA gloves]");

#gems
my @t1_gems = (
'Amber',
'Bloodstone',
'Brilliant Green Garnet',
'Carnelian',
'Chalcedony',
'Chrysoprase',
'Citrine',
'Coral',
'Dark Green Spinel',
'Eye Agate',
'Freshwater Pearl',
'Moss Agate',
'Orange Zircon',
'Pale Golden Pearl',
'Pearl',
'Peridot',
'Quartz',
'Red Spinel',
'Rock Crystal Quartz',
'Salmon Pink Garnet',
'Silver Pearl',
'Zircon',
'Deep Blue Spinel'
);

#foreach (@t1_gems) {
#    trig(\&HL_X, $_, "n:HIGHLIGHT");
#}
undef @t1_gems;

my @t2_gems = (
'Alexandrite',
'Amethyst',
'Aquamarine',
'Azurite',
'Banded Agate',
'Blue Quartz',
'Blue Star Sapphire',
'Bright Green Emerald',
'Brown Red Spinel',
'Champagne Pearl',
'Crysoberyl',
'Fire Opal',
'Golden Yellow Topaz',
'Hematite',
'Jade',
'Lapus Lazuli',
'Moonstone',
'Opal',
'Purple Star Sapphire',
'Sadonyx',
'Silvery Blue Pearl',
'Violet Garnet',
'Water Opal'
);

#foreach (@t2_gems) {
#    trig(\&HL_Y, $_, "n:HIGHLIGHT");
#}
undef @t2_gems;

my @t3_gems = (
'Aventurine',
'Black Onyx',
'Colorless Sapphire',
'Emerald',
'Gray White Diamond',
'Jacinth',
'Jasper',
'Jet',
'Light Blue Iolite',
'Malachite',
'Obsidian',
'Pink Diamond',
'Rhodochrosite',
'Rose Quartz',
'Ruby',
'Sapphire',
'Smokey Quartz',
'Star Ruby',
'Tiger Eye',
'Tomb Jade',
'Tourmaline',
'White Opal'
);

#foreach (@t3_gems) {
#    trig(\&HL_Z, $_, "n:HIGHLIGHT");
#}
undef @t3_gems;

my @green_w = (
'^Your fly spell just',
'^The detect magic wears off\\.$',
'^Your detect invisibility wears off\\.$',
'^You feel less righteous\\.$',
'^You feel less protected\\.$',
'^The white aura around your body fades\\.$',
'^You feel weaker\\.$',
'^The ball of light following you winks out\\.$',
);

foreach (@green_w) {
        trig(\&HL_g, $_, "n:HIGHLIGHT");
}
undef @green_w;

trig {
        #CMD::cmd_bell;
        $: = "\003C$_";
} '^You feel a slight chill\\.$', "n:HIGHLIGHT";

# Reflect
my @reflect_w = (
'^You get a good hold of $char, shocking him\\.$',
'^Your shield protects you from ${char}\'s magic missiles\\.$',
'^(\w+)\'s shield protects him from \\1\'s magic missiles\\.$',
'^(\w+) misses \\1 and destroys an image instead\\.$'
);

foreach (@reflect_w) {
        trig(\&HL_re, $_, "n:HIGHLIGHT");
}
undef @reflect_w;

# Осторожно, опасность!
my @yellow_w = (
'^[A-Za-z \',]+ pokes you in the back with \w+ finger\\.$',
'^[A-Za-z \',]+ is continually trying to get behind you\\.$',
'is destroyed\\.$',
'decays in your hands\\.$',
'^A yellowish-green cloud permeates the air\\.$',
'^You become confused as the surrounding fumes take effect on you\\.$',
'^[A-Za-z \',]+ starts following you\\.$',
'^(\w+) stops following (\w+)\\.$',
'^(\w+) disappears\\.$',
'^Your body tingles slightly, for a brief moment\\.',
'^You scream in pain as inky black tentacles constrict you\\.'
);

foreach (@yellow_w) {
        trig(\&HL_y, $_, "n:HIGHLIGHT");
}
undef @yellow_w;

# Серьезные проблемы
my @red_w = (
'^You disappear\\.$',
'^You lost your concentration!$',
'^Your casting is disrupted by the fighting!$',
'^Your body returns to solid form\\.',
'^The binding of the spectres wears off, and the shield they formed dissipates\\.',
'^Your flurry of blows subsides\\.',
'^Your hands go right through .+!$'
);

foreach (@red_w) {
        trig(\&HL_r, $_, "n:HIGHLIGHT");
}
undef @red_w;

# Особо опасные ситуации. Такие проблемы показываются в строке состояния
trig {
        #CMD::cmd_bell;
        $: = "\003J$_";
        Fset P;
} '^You feel very sick\\.$', "n:HIGHLIGHT";

trig {
        #CMD::cmd_bell;
        $: = "\003J$_";
        Fset P;
} '^You feel burning poison in your blood, and suffer\\.$', "n:HIGHLIGHT";

trig {
        $: = "\003J$_";
        Fset W;
} '^You are covered in sticky webs!$', "n:HIGHLIGHT";

trig {
        $: = "\003L=== $_ ===";
        sendl('st') if $U::autostand;
        Fset B;
} q(^[A-Za-z ',]+ kick knocks you back a few feet and you fall to the ground\\.$), "g:HIGHLIGHT";

trig {
        $: = "\003L=== $_ ===";
        sendl('st') if $U::autostand;
        Fset B;
} '^The momentum of your kick brings you crashing to the ground\\.$', "g:HIGHLIGHT";

trig {
        #CMD::cmd_bell;
        $: = "\003L=== $_ ===";
        sendl('st') if $U::autostand;
        Fset B;
} '^You are sent sprawling', "n:HIGHLIGHT";

trig {
        #CMD::cmd_bell;
        $: = "\003J$_";
        Fset C;
} '^You fall under the influence of', "n:HIGHLIGHT";

trig {
        #CMD::cmd_bell;
        $: = "\003J$_";
        Fset S;
} '^You suddenly lose all feeling of your mouth and tongue\\.$', "n:HIGHLIGHT"; #ispravit' na silence


# Окончание проблем
trig {
        $: = "\003C$_";
        Fclear P;
} '^A warm feeling runs through your body\\.$', "n:HIGHLIGHT";

trig {
        $: = "\003C$_";
        Fclear W;
} '^You break free of the webs!$', "n:HIGHLIGHT";

trig {
        $: = "\003C$_";
        Fclear W;
} '^Many spiders crawl upon you and start removing the webs\.\.\.$', "n:HIGHLIGHT";

#trig {
#        $: = "\003C$_";
#        Fclear C;
#} '^You realize that (.*) is a jerk!$', "n:HIGHLIGHT";

#trig {
#        $: = "\003C$_";
#        Fclear S;
#} '^You feel the oppressive silence on you shatter!$', "n:HIGHLIGHT";

#trig {
#        $: = "\003C$_";
#        Fclear H;
#} '^You feel the magic bond holding you shatter!$', "n:HIGHLIGHT";


#Триггеры на вставание\сидение :)
#TODO фиксить триггеры
trig {
 $U::sleeping = 0;
} '^You stand up\\.', "n:HIGHLIGHT";

trig {
 $U::sleeping = 0;
} '^You stop resting, and stand up\\.', "n:HIGHLIGHT";

trig {
 $U::sleeping = 1;
} '^You wake, and sit up\\.', "n:HIGHLIGHT";

trig {
 $U::sleeping = 2;
} '^You sit down and rest your tired bones\\.', "n:HIGHLIGHT";

trig {
 $U::sleeping = 3;
} '^You go to sleep\\.', "n:HIGHLIGHT";

# Триггеры на список игроков, находящихся в игре
# Часть работы с этим списком находится в prompt hook
#trig {
#        if (!$who_lines) {
#                $who_lines = 1;
#                enable("CHECK_WHO");
#        }
#} '^Mortals$', '2000n:CORE';

#trig {
#        if ($who_lines) {
#                $who_lines = 0;
#                disable("CHECK_WHO");
#                my $Total = "\003L$_";
#                foreach my $col (keys(%NCO)) {
#                        $Total .= " \003$col($NCO{$col})" unless $col eq "O";
#                }
#                $: = $Total;
#                undef %NCO;
#        }
#} '^\s*Total visible people', '2000n:CORE';

#trig {
#        if (!$_ or $_ =~ /^-+$/) {
#                return;
#        }
#        my @title = split /\s+/;
#        my $name = shift @title;
#        foreach my $prefix (qw(Sir Madame Ms Mrs Miss Lady Lord)) {
#                $name = shift @title if $name eq $prefix;
#        }
#        if (defined($char_list{$name})) {
#                my ($class, $color, $message) = @{$char_list{$name}};
#                $message = "- $color $class, $message";
#                $Pcolor = $CLAN_COLOR{$color} || "O";
#                $: = "\003$Pcolor$_ $message";
#                ++$NCO{$Pcolor};
#        }
#} '.*', "1500n-:CHECK_WHO";

# Фолловерсы за работой
alias {
       if ( @_[0] eq '' ) { sendl ("order followers kill $U::target"); }
       else { sendl ("order followers kill @_[0]"); };
      } "ofk";

alias {
       if ( @_[0] eq '' ) { sendl ("order followers assist $U::tank"); }
       else { sendl ("order followers assist @_[0]"); };
      } "ofa";

alias {
       sendl ("order followers @_");
      } "of";

alias {
       sendl ("order followers flee");
      } "off";

#AUTOKICK & AUTOBLAST
trig {
 sendl("cast 'destruct' $U::target");sendl("cast 'destruct' $U::target");
} '^Wise utters the words, \'yufzxuie\'', "2000n-:AUTOBLAST";

trig {
 sendl("kick");
} '^Your kick hits', "2000n-:AUTOKICK";

trig {
 sendl("kick");
} '^Your boots need polishing again - blood all over', "2000n-:AUTOKICK";

trig {
 sendl("kick");
} '^Your beautiful full-circle-kick misses', "2000n-:AUTOKICK";

trig {
 sendl("kick");
} '^You miss your kick at', "2000n-:AUTOKICK";

trig {
 sendl("strike");
} '^Your strike at', "2000n-:AUTOSTRIKE";

trig {
 sendl("strike");
} '^You land a powerful strike into', "2000n-:AUTOSTRIKE";

trig {
 sendl("counter");
} '^You cease your counterattack stance.$|^You fumble your counter-attack stance\.$', "2000n:AUTOCOUNTER";

trig {
 sendl("broad");
} '^You use the flat of your weapon to crush', "2000n-:AUTOBROAD";

trig {
 if ($1 eq $U::leader) {
        sendl("deathgrip $U::target");
 }
} '^You follow (\w+)\.$', "2000n-:AUTOGRIP";

#FISHING

trig {
 sendl("castout");
} '^You pull your arm back and try to cast out your line', "2000n-:FISHING";


trig {
 sendl("reelin"); sendl("castout");
} '^Your line suddenly jumps to life', "2000n-:FISHING";


trig {
 sendl("reelin"); sendl("castout");
} '^You feel a very solid pull on your line', "2000n-:FISHING";

# перенос спама в другое окно
# Vekna[]> '
# Medios gossips-- 'oh baby i like it raw, oh baby i like it raw'
# wecho($window, $message)
#

#trig {
# sendl("kick");
#} ''(\w+)\[(\w+)\]> \'', "2000n-:AUTOKICK";


# Некоторые горячие кнопки

#bindkey (\&CMD::cmd_quit, "C-C");
bindkey (\&recall_tank, "M-R");
bindkey { sendl('group') } "M-g";
bindkey { sendl("ass $U::tank") } "M-a";
bindkey { sendl('flee') } "M-f";
bindkey { sendl("cast 'invis' $Char::my_name") } "C-q";
#bindkey { echo("\003CTarget=$U::Target") } "M-z";
#bindkey { sendl("kill $U::Target") } "M-K";
bindkey { CMD::cmd_tick } "M-t";

=comment
bindkey {
 if ($Char::mode ne "Regen") {
     if ($Char::mode eq "AC") { Char::rem_ac; $U::ac = "\003I"; }
     if ($Char::mode eq "Rent") { Char::rem_rent; $U::rent = "\003I"; }
     if ($Char::mode eq "Control") { Char::rem_damage; $U::damage = "\003I"; }
     Char::wear_regen;
     $U::regen = "\003C";
     $mode_keys = "\003I[F1:".$U::regen."REGEN\003I  F2:".$U::damage."Damage\003I  F3:".$U::ac."AC\003I  F4:".$U::rent."RENT\003I]";
 };
} "f1";

bindkey {
 if ($Char::mode ne "Control") {
     if ($Char::mode eq "AC") { Char::rem_ac; $U::ac = "\003I"; }
     if ($Char::mode eq "Rent") { Char::rem_rent; $U::rent = "\003I"; }
     if ($Char::mode eq "Regen") { Char::rem_regen; $U::regen = "\003I"; }
     Char::wear_damage;
     $U::damage = "\003C";
     $mode_keys = "\003I[F1:".$U::regen."REGEN\003I  F2:".$U::damage."Damage\003I  F3:".$U::ac."AC\003I  F4:".$U::rent."RENT\003I]";
 };
} "f2";

bindkey {
 if ($Char::mode ne "AC") {
    if ($Char::mode eq "Regen") { Char::rem_regen; $U::regen = "\003I"; }
    if ($Char::mode eq "Rent") { Char::rem_rent; $U::rent = "\003I"; }
    if ($Char::mode eq "Control") { Char::rem_damage; $U::damage = "\003I"; }
    Char::wear_ac;
    $U::ac = "\003C";
    $mode_keys = "\003I[F1:".$U::regen."REGEN\003I  F2:".$U::damage."Damage\003I  F3:".$U::ac."AC\003I  F4:".$U::rent."RENT\003I]";
  };
} "f3";

bindkey {

 if ($Char::mode ne "Rent") {
    if ($Char::mode eq "Regen") { Char::rem_regen; $U::regen = "\003I"; }
    if ($Char::mode eq "AC") { Char::rem_ac; $U::ac = "\003I"; }
    if ($Char::mode eq "Control") { Char::rem_damage; $U::damage = "\003I"; }
    Char::wear_rent;
    $U::rent = "\003C";
    $mode_keys = "\003I[F1:".$U::regen."REGEN\003I  F2:".$U::damage."Damage\003I  F3:".$U::ac."AC\003I  F4:".$U::rent."RENT\003I]";
  };
} "f4";

bindkey {
 if ($Char::mode ne "regen") {
     wear('regen');
     $U::regen = "\003C";
     $mode_keys = $Char::mode;
 };
} "f1";

bindkey {
 if ($Char::mode ne "uc") {
     wear('uc');
     $U::damage = "\003C";
     $mode_keys = $Char::mode;;
 };
} "f2";

bindkey {
 if ($Char::mode ne "ac") {
    wear('ac');
    $U::ac = "\003C";
    $mode_keys = $Char::mode;";
  };
} "f3";


bindkey {
 if ($Char::mode ne "regen") {
     wear('regen');
     $U::regen = "\003C";
     $mode_keys = $Char::mode;
 };
} "f1";

bindkey {
 if ($Char::mode ne "uc") {
     wear('uc');
     $U::damage = "\003C";
     $mode_keys = $Char::mode;
 };
} "f2";

bindkey {
 if ($Char::mode ne "ac") {
    wear('ac');
    $U::ac = "\003C";
    $mode_keys = $Char::mode;
  };
} "f3";
=cut


# Алиасы

alias {
        if ($_[0] =~ /^(\d+)\.$/) {
                sendl("get all $1.corpse");
                return;
        }
        if ($_[0] =~ /^\d+$/) {
                for (my $i = 2; $i <= $_[0]; $i++) {
                        sendl("get all $i.corpse");
                }
        }
        sendl("get all corpse");
} "gac";

alias {
        if ($_[0] =~ /^(\d+)\.$/) {
                sendl("get gold $1.corpse");
                return;
        }
        if ($_[0] =~ /^\d+$/) {
                for (my $i = 2; $i <= $_[0]; $i++) {
                        sendl("get gold $i.corpse");
                }
        }
        sendl("get gold corpse");
} "gcoins";

alias {
        if (!$#_) {
                if ($_[0] =~ /^\d+$/) {
                        for (my $i = 1; $i <= $_[0]; $i++) {
                                sendl("exa $i.corpse");
                        }
                } elsif ($_[0] =~ /^(\d+)\.$/) {
                        sendl("exa $1.corpse");
                } else {
                        sendl("exa @_[0]");
                }
        } else {
                sendl("exa @_[0]");
        }
} "exa";

alias {sendl("wake\r\nstand");} "was";

alias {
       if ($_[0] =~ /^([a-zA-Z0-9\.\-]+)$/) {
            CMD::cmd_target($_[0]);sendl("deathgrip $U::target");
       } else {sendl("deathgrip $U::target");}
} "dg";

alias {
       if ($_[0] =~ /^([a-zA-Z0-9\.\-]+)$/) {
            CMD::cmd_target($_[0]);sendl("wraithtouch $U::target");
       } else {sendl("wraithtouch $U::target");}
} "wt";

alias {
       #sendl("focus");
       if ($_[0] ne "") {
            sendl("strike $_[0]");
       } else {sendl("strike")}
} "ss";

alias {
       #sendl("focus");
	   sendl("strike $U::target")
} "sst";

alias {
       sendl("backstab $U::target")
} "bt";

alias {sendl("look $U::target");} "lt";
alias {sendl("kill $U::target");} "kt";

#COMBAT
alias { sendl("cast 'fireball' @_[0]") }                "fb";
alias { sendl("cast 'fireball' $U::target") }        "fbt";
alias { sendl("cast 'dispel evil' @_[0]") }                "de";
alias { sendl("cast 'dispel evil' $U::target") }        "det";
alias { sendl("cast 'acid blast' @_[0]") }                "ab";
alias { sendl("cast 'acid blast' $U::target") }                "abt";
alias { sendl("cast 'firewind' @_[0]") }                "fw";
alias { sendl("cast 'firewind' $U::target") }                "fwt";
alias { sendl("cast 'destruction' @_[0]") }                "dd";
alias { sendl("cast 'destruction' $U::target") }                "ddt";
alias { sendl("cast 'web' @_[0]") }                        "web";
alias { sendl("cast 'web' $U::target") }                "webt";
alias { sendl("cast 'disi' @_[0]") }                        "disi";
alias { sendl("cast 'disi' $U::target") }                "dist";
alias { sendl("cast 'ice ray' @_[0]") }                        "ir";
alias { sendl("cast 'ice ray' $U::target") }                "irt";
alias { sendl("cast 'ice strom'") }                        "is";
alias { sendl("cast 'blindness' @_[0]") }                "bld";
alias { sendl("cast 'blindness' $U::target") }                "bldt";
alias { sendl("cast 'curse' @_[0]") }                        "cs";
alias { sendl("cast 'curse' $U::target") }                "cst";
alias { sendl("cast 'demon bind' @_[0]") }                "db";
alias { sendl("cast 'demon bind' $U::target") }                "dbt";
alias { sendl("cast 'demon touch' @_[0]") }                "dt";
alias { sendl("cast 'demon touch' $U::target") }        "dtt";
alias { sendl("cast 'demon touch' @_[0]") }                "dt";
alias { sendl("cast 'demon touch' $U::target") }        "dtt";
alias { sendl("cast 'weaken' @_[0]") }                        "wk";
alias { sendl("cast 'weaken' $U::target") }                "wkt";
alias { sendl("cast 'faerie fire' $U::target") }        "ff";

#ENCHANT
alias { sendl("cast 'spell shield' @_[0] 40") }                "sshield";
alias { sendl("cast 'spectral shield'") }                "spectral";
alias { sendl("cast 'wraithform'") }                        "wra";

alias { $victim = $Char::my_name;
        if (@_[0] ne "") { $victim = @_[0]; };
        sendl("cast 'infravision' $victim"); }                "infra";
alias { $victim = $Char::my_name;
        if (@_[0] ne "") { $victim = @_[0]; };
        sendl("cast 'fly' $victim");}                        "fly";
alias { $victim = $Char::my_name;
        if (@_[0] ne "") { $victim = @_[0]; };
        sendl("cast '$Char::bless' $victim");}                "bl";
alias { $victim = $Char::my_name;
        if (@_[0] ne "") { $victim = @_[0]; };
        sendl("cast '$Char::armor' $victim");}                "stone";
alias { $victim = $Char::my_name;
        if (@_[0] ne "") { $victim = @_[0]; };
        sendl("cast '$Char::lite' $victim"); }                "lite";
alias { $victim = $Char::my_name;
        if (@_[0] ne "") { $victim = @_[0]; };
        sendl("cast 'wall' $victim"); }                        "wall";
alias { $victim = $Char::my_name;
        if (@_[0] ne "") { $victim = @_[0]; };
        sendl("cast 'dark cloak' $victim"); }                "cloak";
alias { $victim = $Char::my_name;
        if (@_[0] ne "") { $victim = @_[0]; };
        sendl("cast 'invisibility' $victim"); }                "invis";
alias { $victim = $Char::my_name;
        if (@_[0] ne "") { $victim = @_[0]; };
        sendl("cast 'water breathing' $victim"); }        "wb";
alias { $victim = $Char::my_name;
        if (@_[0] ne "") { $victim = @_[0]; };
        sendl("cast 'darkness' $victim"); }                "dark";
alias { $victim = $Char::my_name;
        if (@_[0] ne "") { $victim = @_[0]; };
        sendl("cast 'regeneration' $victim"); }                "rg";

alias { sendl("cast 'fluidity' $Char::my_name") }        "flui";
alias { sendl("cast 'glamour' $Char::my_name") }        "glamour";
alias { sendl("cast 'undead visage' $Char::my_name") }        "visage";
alias { sendl("cast 'detect magic' $Char::my_name") }        "dm";
alias { sendl("cast 'detect evil' $Char::my_name") }        "dev";
alias { sendl("cast 'detect good' $Char::my_name") }        "deg";
alias { sendl("cast 'detect invis' $Char::my_name") }        "di";
alias { sendl("cast 'sense life' $Char::my_name") }        "dl";
alias { sendl("cast 'darksight' $Char::my_name") }        "ds";
alias { sendl("cast 'protection from evil' $Char::my_name") }        "pfe";
alias { sendl("cast 'str'") }                                "str";
alias { sendl("cast 'unholy str'") }                        "ustr";
alias { sendl("cast 'aerial servant'") }                "kom";
alias { sendl("cast 'mindbar'") }                        "mind";
alias { sendl("cast 'silence' @_[0]") }                        "sil";
alias { sendl("cast 'feast'") }                                "feast";
#MISC
alias {
        if ($_[0] =~ /^(\d+)$/) {
                sendl("cast 'embalm' $1.corpse");
                return;
        }
        if ($_[0] =~ /^\d+$\./) {
                for (my $i = 2; $i <= $_[0]; $i++) {
                        sendl("cast 'embalm' $i.corpse");
                }
        }
        sendl("cast 'embalm' corpse");
} "em";

alias { sendl("cast 'locate object' @_[0]") }                "locate";
alias { sendl("cast 'sleep' @_[0]") }                        "sleep";
alias { sendl("cast 'dark mace'") }                        "mace";
alias { sendl("cast 'cheat death'") }                        "cheat";
alias { sendl("cast 'familiar' @_[0]") }                "fam";
alias { sendl("cast 'force field' @_[0]") }                "field";
alias { sendl("cast 'gate' @_[0]") }                        "gate";
alias { sendl("cast 'passage' @_[0]") }                        "passage";
alias { sendl("cast 'lloyds beacon' @_[0]") }                "llb";
alias { sendl("cast 'raise dead' @_[0]") }                "raise";
alias { sendl("cast 'vision' @_[0]") }                        "vis";
alias { sendl("cast 'word of recall'") }                "wrr";
alias { sendl("cast 'create food'\nget food\neat food") }        "cfood";
alias { sendl("cast 'create water' $Char::water_container\ndri water") }        "cwater";
alias { sendl("cast 'summon undead' @_[0]") }                "call";
#HEAL AND REMOVE EFFECTS
alias { if (@_[0] ne "") { sendl("cast 'dispel magic' @_[0]"); } }        "dism";
alias { sendl("cast 'dispel magic' $U::target") }        "dismt";
alias { sendl("cast 'cure blind' @_[0]") }                "cblind";

alias { $victim = $Char::my_name;
        if (@_[0] ne "") { $victim = @_[0]; };
        sendl("cast 'greater heal' $victim");}                "gh";
alias { $victim = $Char::my_name;
        if (@_[0] ne "") { $victim = @_[0]; };
        sendl("cast 'heal' $victim");}                        "h";
alias { $victim = $Char::my_name;
        if (@_[0] ne "") { $victim = @_[0]; };
        sendl("cast 'restoration' $victim");}                "rt";
alias { $victim = $Char::my_name;
        if (@_[0] ne "") { $victim = @_[0]; };
        sendl("cast 'refresh' $victim");}                "refresh";
alias { $victim = $Char::my_name;
        if (@_[0] ne "") { $victim = @_[0]; };
        sendl("cast 'remove curse' $victim");}                "rcurse";
alias { $victim = $Char::my_name;
        if (@_[0] ne "") { $victim = @_[0]; };
        sendl("cast 'remove poison' $victim");}                "rpoison";

alias { sendl("cast 'greater heal' $U::tank") }                "ght";
alias { sendl("cast 'heal' $U::tank") }                        "ht";
alias { sendl("cast 'restoration' $U::tank") }                "rtt";

alias {
        if ($_[0] =~ /^(\d+)\.$/) {
                sendl("cast 'embalm' $1.corpse");
                return;
        }
        if ($_[0] =~ /^\d+$/) {
                for (my $i = 2; $i <= $_[0]; $i++) {
                        sendl("cast 'embalm' $i.corpse");
                }
        }
        sendl("cast 'embalm' corpse");
} "embalm";


#bard songs
#lion chorus
alias  {
     if ($Char::bard_prime) {
          sendl("play 'lion chorus'");
     } else {
          sendl("sing 'lion chorus'")
     }
} "lion";

#wealth and glory

#call of the cuillen
#brothers in arms
alias  {
     if ($Char::bard_prime) {
          sendl("play 'brothers in $Char::brothers'");
     } else {
          sendl("sing 'brothers in $Char::brothers'")
     }
} "bro";

#beyond the shadows
#sanctuary for the soul
#march of the heroes
alias  {
     if ($Char::bard_prime) {
          sendl("play 'march of the heroes'");
     } else {
          sendl("sing 'march of the heroes'")
     }
} "march";
#fare thee well
#dreams of the castle
alias  {
     if ($Char::bard_prime) {
          sendl("play 'dreams of the castle'");
     } else {
          sendl("sing 'dreams of the castle'")
     }
} "dreams";
#echolocation
#dance of the many
#song of the mist
#knights blessing
#knights prayer
#hymn of the morning star
#sacred reprieve
#haunted dirge
#flames at midnight
#gods of war
alias  {
     if ($Char::bard_prime) {
          sendl("play 'gods of war'");
     } else {
          sendl("sing 'gods of war'")
     }
} "gods";
#reign of confusion
#wall of sleep
#eye of the beholder
#rina cruinne
#oghams psalm of discipline
#cry of the avatars
#call of the sidhe
#hymn of an artisan
#dance of the seven luck gods



#MUD::conn "game.slothmud.org", 6101;

#trig {
#  sendl("play 'brothers in arms'");
#} '^The song ends, and you feel less camaraderie with your party\\.$', "2000n-:AUTOBUFF";

#trig {
#  sendl("play 'gods of war'");
#}'^The song ends and you are less inspired by the deeds of the war gods\\.', "2000n-:AUTOBUFF";

#Bots

trig {
 sendl("cast '$Char::lite' $1");
} '^(\w+) tells you \'lite\'', "2000n-:BOT";


trig {
 sendl("cast 'stone' $1");
} '^(\w+) tells you \'stone\'', "2000n-:BOT";

trig {
 sendl("cast 'bless' $1");
} '^(\w+) tells you \'bless\'', "2000n-:BOT";

trig {
 sendl("cast 'refresh' $1");
} '^(\w+) tells you \'refresh\'', "2000n-:BOT";

trig {
 sendl("cast 'feast'");
} '^(\w+) tells you \'feast\'', "2000n-:BOT";


trig {
 sendl("cast 'heal' $1");
} '^(\w+) tells you \'heal\'', "2000n-:BOT";

#BOT ������ 0.1
sub CMD::cmd_bottin {
 if ($_[0] eq "on") {
        open(BOT,"bot.txt");
        @lines=<BOT>;
        foreach $line (@lines) {
                chomp($line);
                if ($line =~ /^mob=/) {
                        @tmp = split /=/;
                        echo("$tmp[1] target=$tmp[2]");
                        ##trig { sendl("cast 'heal' $1"); } '(\w+) tells you \'heal\'', "2000n:BOT";
                }
        }
 };
 if ($_[0] eq "off") {
        echo("off");
 };
 if ($_[0] eq "") {
        echo("Usage: /bottin on|off");
 };
}

#AutoBuff

sub CMD::cmd_buffs {
     enable('AUTOBUFF');
     sendl('score');
}

trig {
      @currentBuffs = ();
      enable('AUTOBUFFCORE');
} '^You are affected by the following spells:$', '2000n-:AUTOBUFF';

trig {
      $tmpString = $_;
      $tmpString =~ s/^[ ]+//g;
      $tmpString =~ s/[ ]+$//g;
      push @currentBuffs, $tmpString;
} '^[ ].+', '2000n-:AUTOBUFFCORE';

sub rebuff {
#     if ( scalar(@currentBuffs) > 0 ) {
        foreach $aBuff (@Char::autoBuffs) {
                 $flag = 1;
                 # echo "$aBuff";
                 foreach $cBuff (@currentBuffs) {
                       # echo "    $cBuff";
                       if ($aBuff eq $cBuff) { $flag = 0 };
                 }
                 $tmpString = $aBuff;
                 $tmpString =~ s/Invisible/Invisibility/;
                 # echo "    $flag";
                 if ( $flag) { sendl("cast '$tmpString' $Char::my_name") };
        }
        undef @currentBuffs;
#     }
}

#������ ��� ����� ��� ����
#��������� �����:
#1. trigger �� damnation ��� curse - �������� autoblind (�������� ��������2)
#2. trigger �� blind - �������� �������
#3. � ���� �� �������� ���������� ������� ��
# $U::tank [Lvl:%1  %2hp %3ma %4mv] - ���� ���� ������
# �� �������� rtt;gg ���� �� ���� trip;gg
# � ���� �� �������� ���� ���� ������ - $U::tank �������������� �� 2.�����
# ��� �� ��������� ������� �� �����
# ��� �� ��������� ������� �� ��������� �����
#4. ������� �� ��������� ����� - ����������� �3 ���������� �1

sub HL_target {
	$: = "\003J$_";
}

my @hltarget = (
	'a powerful crosswind',
	'an irregular gust',
);

foreach (@hltarget) {
        #trig(\&HL_target, $_, "n:HIGHLIGHT");
}
undef @hltarget;

#WishList

sub HL_wish {
        #CMD::cmd_bell;
        $: = "\003K$_";
}

# open(WishFile, "wishlist.txt") ;
# while ($line = <WishFile>) {
  # echo("$line");
  # trig(\&HL_wish, $line, "n:HIGHLIGHT");
# }

my @books = (
	'digest-protection',
	'forgotten-techniques',
	'slippery-spellbook',
	'book-acrobats'
);
my @wish = (
  'chunk of red volcanic glass',
  'some fine sanding paper',
  'chunk of black glass',
  'pile of fire bricks',
  'some hot embers',
  'a skeletal branch',
  'an ornate glass broach',
  'a vial of green slime',
  'a loathsome vulture feather',
  'a knife made of vampire fangs',
  'ring of the City',
  'a werewolf\'s claw',
  'a dark sword',
  'a salamander\'s scale',
  'a glass jar',
  'a wooden stopper',
  'distilled water',
  'a stone pestle',
  'a stone mortar',
  'rose petals',
  'yellow chrysanthemum petals',
  'violet petals',
  'little dancing star',
  'ruby spider brooch',
  'a small note from a tomb guardian',
  'a very small ruby from a yuan-ti sentry',
  'a jagged rock from a yuan-ti warrior',
  'a sack of black dust from a yuan-ti elite guard',
  'a small cutting stone',
  'vial of black acid',
  'string of tiny golden charms',
  'grains of golden sand',
  'an opposum\'s pouch',
  'crushed coral',
  'willow fronds',
  'birch bark',
  'peat fire embers',
  'a stone pestle',
  'a stone mortar',
  'adamantite chains',
  'obsidian dragon crest',
  'Staff of the Demon Mage',
  'Girdle of the Demon Mage',
  'Breast Plate of the Demon Mage',
  'Bracers of the Demon Mage',
  'rose petals',
   'a vial of distilled alcohol',
  'a lump of urine soap',
  'distillery pipes',
  'peat fire embers',
  'a glass collection tray',
  'an oil skimmer',
  'an empty vial',
  'gold hoop earring',
  'an argosian treasure chest',
  'an argosian cutlass',
  'bar of gold',
  'the physician\'s mirror',
  'a bar of platinum',
  'a sharp set of horns',
  'tainted red scales of a pyrohydra',
  'a purple stinger',
  'a pair of cobra fangs',
  'a multi-colored cloth',
  'Holy Chalice of Ra',
  'a large bag of boulders',
  'a bottle of hatred',
  'the holy gem of Omah',
  'an odd looking page',
  'a jagged claw',
  'skin of an ogre magi',
  'a pair of roc wings',
  'a small piece of sphinx',
  'a large bag of boulders',
  'scales of a sandworm',
  'bag of sand',
  'a grain of black sand',
  'ripped page from a forger\'s manual',
  'a weak whirlwind',
  'a powerful crosswind',
  'an irregular gust'
);

foreach (@wish) {
        #trig(\&HL_wish, $_, "n-:ARENA0");
}
undef @wish;

trig { $U::target = "lizard"; sendl("cast 'thunder clap' $U::target\r\n\r\ncast 'thunder clap' $U::target") } 'A bright-red fire lizard is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "warrior"; sendl("cast 'thunder clap' $U::target") } 'A faerine warrior is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "bug"; sendl("cast 'thunder clap' $U::target") } 'A giant sow bug is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "octopus"; sendl("cast 'thunder clap' $U::target") } 'A giant undead octopus is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "mouther"; sendl("cast 'fireball' $U::target") } 'A gibbering mouther is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "gladiator"; sendl("cast 'thunder clap' $U::target") } 'A kobold gladiator slave is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "assassin"; sendl("cast 'thunder clap' $U::target") } 'A masked quickling assassin is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "zombie"; sendl("cast 'thunder clap' $U::target") } 'A ravenous zombie is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "monster"; sendl("cast 'thunder clap' $U::target") } 'A sludge monster is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "gnoll"; sendl("cast 'thunder clap' $U::target") } 'A snarling gnoll axeman is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "bunny"; sendl("cast 'thunder clap' $U::target") } 'A vorpal bunny is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "firenewt"; sendl("cast 'thunder clap' $U::target") } 'An adept firenewt battle mage is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "firenewt"; sendl("cast 'thunder clap' $U::target") } 'An adept firenewt battle priest is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "slime"; sendl("cast 'thunder clap' $U::target") } 'An agitated green slime is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "Calliperus"; sendl("cast 'thunder clap' $U::target") } 'Calliperus the rogue is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "Devon"; sendl("cast 'thunder clap' $U::target") } 'Devon the bard is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "Eunice"; sendl("cast 'thunder clap' $U::target") } 'Eunice the mage is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "Giolvira"; sendl("cast 'thunder clap' $U::target") } 'Giolvira, daughter of Kyuss is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "Gordo"; sendl("cast 'thunder clap' $U::target") } 'Gordo, the barbarian is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "Sonjill"; sendl("cast 'thunder clap' $U::target") } 'Sonjill the warrior bard is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "warrior"; sendl("cast 'thunder clap' $U::target") } 'A skeletal warrior is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "Merate"; sendl("cast 'thunder clap' $U::target") } 'Merate the thief acrobat is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "gorilla"; sendl("cast 'thunder clap' $U::target") } 'A silverback gorilla is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "golem"; sendl("cast 'thunder clap' $U::target") } 'A thatch golem is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "stick"; sendl("cast 'thunder clap' $U::target") } 'A giant walking stick is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "guard"; sendl("cast 'thunder clap' $U::target") } 'The king\'s royal guard is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "dwarf"; sendl("cast 'thunder clap' $U::target") } 'A dirty drunken dwarf is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "samurai"; sendl("cast 'thunder clap' $U::target") } 'A silver samurai is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "shaman"; sendl("cast 'thunder clap' $U::target") } 'A fairy shaman is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "minotaur"; sendl("cast 'thunder clap' $U::target") } 'A juvenile minotaur is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "blade"; sendl("cast 'thunder clap' $U::target") } 'A blade wielding snudiss is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "dragon"; sendl("cast 'firewind' $U::target") } 'A small chromatic dragon is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "sinister"; sendl("cast 'firewind' $U::target") } 'A sinister floating head is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "warrior"; sendl("cast 'firewind' $U::target") } 'A phantom warrior is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "fire"; sendl("cast 'firewind' $U::target") } 'A giant fire serpent is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "crab"; sendl("cast 'firewind' $U::target") } 'A giant land crab is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "owlbear"; sendl("cast 'acid blast' $U::target\r\ncast 'firewind' $U::target") } 'An owlbear gladiator is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "dragon"; sendl("cast 'firewind' $U::target") } 'A ferocious green dragon is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "abysmal"; sendl("cast 'firewind' $U::target") } 'An abysmal darkness is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "dragonitte"; sendl("cast 'firewind' $U::target") } 'An arrogant dragonitte gladiator is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "follower"; sendl("cast 'firewind' $U::target") } 'A follower of Amathea is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "illusionist"; sendl("cast 'firewind' $U::target") } 'An illusionist is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "remorhaz"; sendl("cast 'firewind' $U::target") } 'A giant remorhaz is waiting for you on the other side\.', '2000n-:ARENA0';

trig { $U::target = "swarm"; CMD::cmd_disable("ARENAASSIST"); sendl("cast 'thunder clap' $U::target") } 'A swarm of midges is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "guardian"; CMD::cmd_disable("ARENAASSIST"); sendl("cast 'thunder clap' $U::target") } 'A dark guardian is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "shadow"; CMD::cmd_disable("ARENAASSIST"); sendl("cast 'turn undead' shadow\r\ncast 'turn undead' shadow") } 'A lesser shadow is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "ant"; CMD::cmd_disable("ARENAASSIST"); sendl("cast 'turn undead' ant\r\ncast 'turn undead' ant\r\ncast 'turn undead' ant") } 'A giant ethereal ant is waiting for you on the other side\.', '2000n-:ARENA0';
trig { $U::target = "poltergeist"; CMD::cmd_disable("ARENAASSIST"); sendl("cast 'turn undead' poltergeist\r\ncast 'turn undead' poltergeist\r\ncast 'turn undead' poltergeist") } 'A chaotic poltergeist is waiting for you on the other side\.', '2000n-:ARENA0';

trig { sendl("order followers assist Phase"); } "(hates your guts!)|(Your followers don't seem to be obeying you today)", '2000n-:ARENAASSIST';
trig { sendl("cast 'destruction' $U::target"); } "You failed to cast 'destruction'", '2000n-:ARENA0';

trig {
	if (getArenaStatus() eq "ARENA_STATUS_FIGHT_AFTER_ORB") {
        	$U::ticks_waiting_orb = 0;
		setArenaStatus("ARENA_STATUS_FIGHTING");
		sendl("wake");
		sendl("sta");
		healup();
	}
	if (getArenaStatus() eq "ARENA_STATUS_REGEN_IN_NEXT_ROOM_AFTER_FIGHT") {
	    sendl("wake");
		sendl("sta");
		healup();
	}
 } "A floating orb bathes you in blue light refreshing your energy", '2000n-:ARENA0';

trig { sendl("cast 'thunder clap' $U::target"); } "You struggle with a giant undead octopus's tentacle, to no effect", '2000n-:ARENA0';
trig { sendl("cast 'destruction' $U::target"); } " is blasted away", '2000n-:ARENA0';
trig { sendl("cast 'fireball' $U::target"); } "You failed to cast 'fireball'", '2000n-:ARENA0';
trig { sendl("cast 'fireball' $U::target"); } "^You throw a fireball", '2000n-:ARENA0';
trig { sendl("cast 'thunder clap' $U::target"); } "You failed to cast 'thunder clap'", '2000n-:ARENA0';
trig { sendl("cast 'thunder clap' $U::target"); } "Your thunder clap hits", '2000n-:ARENA0';
trig { sendl("cast 'firewind' $U::target"); } "vanishes in a burning wind", '2000n-:ARENA0';
trig { sendl("cast 'firewind' $U::target"); } "You failed to cast 'firewind'", '2000n-:ARENA0';

trig {
	if (getArenaStatus() eq "ARENA_STATUS_WAITING_FOR_NEXT_FIGHT") {
        CMD::cmd_disable("CHECKARENAENTER");
        setArenaStatus("ARENA_STATUS_BUFFING");
		sendl("cast 'wall of flesh'");
	}
    #if (getArenaStatus() eq "ARENA_STATUS_REGEN_IN_NEXT_ROOM_AFTER_FIGHT") {
    #    sendl("sleep");
    #}
	##CMD::cmd_enable("ARENAASSIST");
} "A pedestal underfoot begins to swivel on its axis, moving you into the arena", '2000n-:ARENA0';

trig { sendl("|\r\ncast 'wall of flesh'"); } "You failed to cast 'wall of flesh'", '2000n-:ARENA0';

trig {
	sendl("cast 'stone skin'")
} "You are surrounded by a wall of rotting flesh", '2000n-:ARENA0';
trig { sendl("|\r\ncast 'stone skin'"); } "You failed to cast 'stone skin'", '2000n-:ARENA0';

trig {
	sendl("cast 'bless'")
} "You feel your skin become much, much stronger", '2000n-:ARENA0';
trig { sendl("|\r\ncast 'bless'"); } "You failed to cast 'bless'", '2000n-:ARENA0';

trig {
	sendl("cast 'regeneration'")
} "You feel righteous", '2000n-:ARENA0';
trig { sendl("|\r\ncast 'regeneration'"); } "You failed to cast 'regeneration'", '2000n-:ARENA0';

trig {
	sendl("cast 'fluidity'")
} "You suddenly feel incredibly healthy and vigorous!", '2000n-:ARENA0';
trig { sendl("|\r\ncast 'fluidity'"); } "You failed to cast 'fluidity'", '2000n-:ARENA0';

trig {
  setArenaStatus("ARENA_STATUS_FIGHTING");
	sendl("push button");
} "Your body mass slowly changes from solid to gelatinous", '2000n-:ARENA0';

trig {
	sendl("kill $U::target")
} "is mortally wounded, and will die soon, if not aided", '2000n-:ARENA0';

trig {
    if (getArenaStatus() eq "ARENA_STATUS_FIGHTING") {
        setArenaStatus("ARENA_STATUS_REGEN_IN_NEXT_ROOM_AFTER_FIGHT");
        sendl("e");
        sendl("pull chain");
        sendl("w");
        sendl("sleep");
    }
} "The floor swivels, forcing you to leave the arena area", '2000n-:ARENA0';

trig {
    echo("=== CharName $Char::my_name $1");
    if ($1 eq $Char::my_name) {
        sendl("sleep");
    } else {
        sendl("pull chain");
    }
} "([A-Za-z]+) must wait ([0-9]+) minutes before being allowed back into the arena area", '2000n:CHECKARENAENTER';

trig {
	sendl("|\r\npull chain")
} "No one is on the waiting list to enter the arena", '2000n:CHECKARENAENTER';

trig {
	sendl("sleep")
} "This isn't the post office!", '2000n-:CHECKARENAENTER';

trig {
	sendl("|");
	healup();
} "(You received)|(Total exp for kill is)", '2000n-:ARENA0';


sub healup {
    if ($U::current_mana > 43) {
        $rest = int ((666 - $U::current_hp) / 200);
        $gheal = int ((666 - $U::current_hp - $rest * 200) / 150);
        $heal = int ((666 - $U::current_hp - $rest * 200 - $gheal * 150) / 100 + 1);
        echo("restor $rest times");
        echo("gheal $gheal times");
        echo("heal $heal times");
        for (my $i = 0; $i < $rest; $i++) {
            sendl("cast 'restoration'");
        }
        for (my $i = 0; $i < $gheal; $i++) {
            sendl("cast 'greater heal'");
        }
        for (my $i = 0; $i < $heal; $i++) {
            sendl("cast 'heal'");
        }
        sendl("save");
	} else {
	    echo("HealUp: $U::current_mana < 43, wait for orb");
	    setArenaStatus("ARENA_STATUS_FIGHT_AFTER_ORB");
	    sendl("slee");
	}
}

sub setArenaStatus {
  my $newStatus = $_[0];
  echo("=== SET NEW STATUS: $newStatus");
  $U::ARENA_STATUS = $newStatus;
}

sub getArenaStatus {
  echo("=== CURRENT STATUS: $U::ARENA_STATUS");
  return $U::ARENA_STATUS;
}

trig {
	if (getArenaStatus() eq "ARENA_STATUS_REGEN_IN_NEXT_ROOM_AFTER_FIGHT") {
		if ((666 - $U::current_hp) > 200) {
            echo("=== Saving items, ARENA_STATUS_REGEN_IN_NEXT_ROOM_AFTER_FIGHT: Hp = (666 - $U::current_hp) > 200, healup");
		    healup()
		} else {
		    echo("=== Saving items, ARENA_STATUS_REGEN_IN_NEXT_ROOM_AFTER_FIGHT: Hp = (666 - $U::current_hp) < 200, go to start");
		    CMD::cmd_disable("AUTORESPELL");
		    CMD::cmd_enable("CHECKARENAENTER");
            setArenaStatus("ARENA_STATUS_WAITING_FOR_NEXT_FIGHT");
            sendl("wake");
            sendl("sta");
            sendl("pull chain");
            sendl("w");
		    sendl("sleep");
		    sendl("score");
		}
	}
    if (getArenaStatus() eq "ARENA_STATUS_FIGHTING") {
        if ((666 - $U::current_hp) > 100) {
            echo("=== Saving items, ARENA_STATUS_FIGHTING: Hp = 666 - $U::current_hp > 100, healup");
            healup();
        } else {
            if ($U::current_mana > 200) {
                echo("=== Saving items, ARENA_STATUS_FIGHTING: Mana = $U::current_mana > 200, push button");
                sendl("push button");
            } else {
                echo("=== Saving items, ARENA_STATUS_FIGHTING: Mana = $U::current_mana < 200, wait for orb");
                setArenaStatus("ARENA_STATUS_FIGHT_AFTER_ORB");
                sendl("sleep");
            }
        }
    }
} "Saving items", '2000n-:ARENA0';


trig {
    CMD::cmd_disable("AUTORESPELL");
    CMD::cmd_enable("CHECKARENAENTER");
    setArenaStatus("ARENA_STATUS_WAITING_FOR_NEXT_FIGHT");
} "Gladiator Pit Entrance Level Four", '2000n-:ARENA0';

trig {
  my $filename = "./logs/score.txt";
  open(my $fh, '>>', $filename);
  my $dt = DateTime->now;
  print $fh DateTime::Format::XSD->format_datetime($dt) . " $1";
  close $fh;

} "^You have ([0-9]+) unused experience points\.", "2000n-:ARENA0";
__DATA__
[tablist]

[sounds]
Editor        beep
MudBeep        beep
[hooks]

[keys]

[aliases]
eg2midgaard	shape ferret;/3e;s;/3e;/2n;/7e;shape ret;
eg2smuggler	/3e;s;/2e;n;open door;/3n;u;w;open door n;n;open box;n;e;n;w;n;w;w;n;n;
king2lila	/5 d;ope crack e;e;/3 n;w;n;e;e;s;e;e;s;/3 w;/3 s;/3 e;/4 s;/5 w;ope door n;n;close door s;exa lila
landing2king	e;d;w;w;/3 n;/3 e;n;w;w;n;w;w;s;s;s;e;s;ope crack w;w;/5 u;exa king
landing2oct	u;u;w;s;u;u;e;ope vines;/5 e;d;bac oct
sg2king	/3 n;/4 e;u;s;w;ope trapdoor;d;bac king
[vars]

[triggers]
1	You get musical tones of sacrosanct from the corpse	drop tones		1000:27003a8
1	You get an aqua spellbook from the corpse	drop aqua-spellbook		1000:2593140
1	You get a sea green spellbook from the corpse	drop sea-green-spellbook		1000:259323c
1	You get an ancient spellbook from the corpse	drop ancient-spellbook		1000:2593338
1	You get a white scaly jacket from the corpse	drop white-scaly-jacket		1000:25dfbc0
1	You get a vial of squids ink from the corpse	drop vial-ink		1000:25dfc74
1	You get a white scaly shield from the corpse	drop white-scaly-shield		1000:25dfe30
1	You get a glowing chunk of metal from the corpse	drop chunk-metal		1000:26b17cc

[complete]
