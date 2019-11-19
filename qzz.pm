package Char;

use MUD;

require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw($my_name $bless $lite $food_container $water_container $holdfrontline);

{

$my_name = "Qzz";
$bless = "bless";
$armor = "stone skin";
$lite = "aegis";
$food_container = "pack";
$recall_container = "pack";
$water_container = "waterskin";
$holdfrontline = 1;

$control_container = "red-black-robes";
$ac_container = "cloak-ancient-sensate-elite-low";
$rent_container = "cloak-ancient-sensate-elite-low";
$mana_container = "mantle-multicolored";
$main_container = "ornate-bag";

sub ether_attack($) {
    MUD::sendl("wraithto $_[0]");
    MUD::sendl("cast 'firewind' $_[0]");
}

sub solid_attack($) {
    MUD::sendl("deathgrip $_[0]");
    MUD::sendl("strike $_[0]");
}

1;
}