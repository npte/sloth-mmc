package Char;  # ����� �� ��� � ��� ����� ����� ���
                     # ���������� '.pm'
use MUD;
require Exporter;    # ������������ ������ ��� �������� ����
@ISA = qw(Exporter); # -//-
#@EXPORT = qw(add_mob ping_proceed); # ����������� ����� �������.
                          # �������� ! ��� �������!
@EXPORT_OK = qw($my_name $bless $lite $food_container $water_container $holdfrontline);
#@EXPORT_OK = qw( $���������� @������ );  # ������� ���������
                # ����������, ������� � �.�. ���� ����������
{  # ������ ����� ������

$my_name = "avl";
$bless = "bless";
$armor = "stone skin";
$lite = "shield of fa";
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
    return "cast 'fireball' $target";
};

sub solid_attack {
    my $target = shift;
    return "cast 'fireball' $target";
};

sub before_push {
    return "rem halberd\r\nwie cinq";
};

1;
}