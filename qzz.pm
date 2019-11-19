package Char;

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

sub ether_attack {
    my $target = shift;
    return "wraithto $target\r\ncast 'firewind' $target";
}

sub solid_attack {
    my $target = shift;
    return "deathgrip $target\r\nstrike $target";
}

sub before_push {
    return "";
}

1;
}