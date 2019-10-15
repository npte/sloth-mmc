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

$my_name = "Teyo";
$bless = "bless";
$armor = "stone skin";
$lite = "sanctuary";
$food_container = "pack";
$recall_container = "pack";
$water_container = "waterskin";
$holdfrontline = 0;

$control_container = "red-black-robes";
$ac_container = "cloak-ancient-sensate-elite-low";
$rent_container = "cloak-ancient-sensate-elite-low";
$mana_container = "mantle-multicolored";
$main_container = "ornate-bag";



sub rem_regen {
   sendl("rem all");
   sendl("get $main_container $mana_container");
   sendl("put all.crystal-ring $mana_container");
   sendl("put sleeves-white-leather $mana_container");
   sendl("put boots-dolphin-skin $mana_container");
   sendl("put all.ruby $mana_container");
   sendl("put gauntlets-shadow-set $mana_container");
   sendl("put claw-green-dragon $mana_container");
   sendl("put golden-choker $mana_container");
   sendl("put circlet-electrum $mana_container");
   sendl("put golden-belt $mana_container");
   sendl("put leggings-ogre-hide $mana_container");
   sendl("put wind-shield $mana_container");
   #sendl("put bracelet-runed-onyx $mana_container");
   sendl("put all.bracer-flames $mana_container");
   sendl("put stricht $mana_container");
   sendl("put cutter $mana_container");
   sendl("put dark $mana_container");
   sendl("put $mana_container $main_container");
};

sub rem_ac {
   sendl("rem all");
   sendl("get $main_container $ac_container");
   sendl("put all.ring-elven-agility-golden $ac_container");
   ##sendl("put  $ac_container");
   sendl("put all.cloak-silvery-silver-fur $ac_container");
   sendl("put mystic-plate-mail $ac_container");
   sendl("put dragon-crested-helm $ac_container");
   sendl("put silver-leg-plates $ac_container");
   sendl("put elvenkind-elven-boots $ac_container");
   sendl("put shield-skull-great-yawning-death $ac_container");
   sendl("put gloves-forest-green $ac_container");
   sendl("put armplates-carved-bone $ac_container");
   sendl("put rope-belt $ac_container");
   sendl("put all.polished-steel-bracelet $ac_container");
   sendl("put star-black-morning $ac_container");
   #sendl("put staff $ac_container");
   sendl("put scarab $ac_container");
   sendl("put star $ac_container");
   sendl("put $ac_container $main_container");
};

sub rem_rent {
   sendl("rem all");
   sendl("get $main_container $rent_container");
   sendl("put $rent_container $main_container");
   sendl("get $mana_container $main_container");
   sendl("put all.crystal-ring $mana_container");
   sendl("put symbol-dark-lord $mana_container");
   sendl("put wind-shield $mana_container");
   sendl("put claw-green-dragon $mana_container");
   sendl("put platemail-ruby-mail-plate $mana_container");
   sendl("put cutter $mana_container");
   sendl("put $mana_container $main_container");
   sendl("get $ac_container $main_container");
   sendl("put cloak-silvery-silver-fur $ac_container");
   sendl("put dragon-crested-helm $ac_container");
   sendl("put silver-leg-plates $ac_container");
   sendl("put elvenkind-elven-boots $ac_container");
   sendl("put armplates-carved-bone $ac_container");
   sendl("put rope-belt $ac_container");
   sendl("put all.polished-steel-bracelet $ac_container");
   sendl("put scarab $ac_container");
   sendl("put $ac_container $main_container");
   sendl("get $control_container $main_container");
   sendl("put gauntlets $control_container");
   sendl("put $control_container $main_container");
   #sendl("put spellbook $main_container");
};

sub rem_damage {
   sendl("rem all");
   sendl("get $main_container $control_container");
   sendl("put gauntlets-arcane-moon $control_container");
   sendl("put eye-undead-haunting $control_container");
   sendl("put tome-runes-silver-grey $control_container");
   sendl("put staff-serpents-serpent-snake $control_container");
   sendl("put rose-corrupted $control_container");
   sendl("put crown-thorns-twisted $control_container");
   sendl("put all.strand-silk-opalescent-looped $control_container");
   sendl("put ankh-decaying-ugly $control_container");
   sendl("put woven-guards $control_container");
   sendl("put $control_container $main_container");
   sendl("get $ac_container $main_container");
   sendl("put $ac_container $main_container");
};

sub wear_ac {
 sendl("get $ac_container $main_container");
 sendl("get all $ac_container");
 sendl("put $main_container $ac_container");
 sendl("hold scarab");
 sendl("wie star-black-morning");
 sendl("wear all");
 $mode = "AC";
};

sub wear_regen {
 sendl("get $mana_container $main_container");
 sendl("get all $mana_container");
 sendl("put $main_container $mana_container");
 sendl("hold obsidian-serpent");
 sendl("wie cutter");
 sendl("wear all");
 $mode = "Regen";
};

sub wear_rent {
   #sendl("rem $rent_container");
   sendl("get $mana_container $main_container");
   #sendl("put $rent_container $main_container");
   #sendl("get $mana_container $main_container");
   sendl("get all.crystal-ring $mana_container");
   sendl("get wind-shield $mana_container");
   sendl("get symbol-dark-lord $mana_container");
   sendl("get claw-green-dragon $mana_container");
   sendl("get platemail-ruby-mail-plate $mana_container");
   sendl("get cutter $mana_container");
   sendl("put $mana_container $main_container");
   sendl("get $ac_container $main_container");
   sendl("get cloak-silvery-silver-fur $ac_container");
   sendl("get dragon-crested-helm $ac_container");
   sendl("get silver-leg-plates $ac_container");
   sendl("get elvenkind-elven-boots $ac_container");
   sendl("get armplates-carved-bone $ac_container");
   sendl("get rope-belt $ac_container");
   sendl("get all.polished-steel-bracelet $ac_container");
   sendl("get scarab $ac_container");
   sendl("put $ac_container $main_container");
   sendl("get $control_container $main_container");
   sendl("get gauntlets-arcane-moon $control_container");
   sendl("put $control_container $main_container");
   #sendl("get ruby-spellbook $main_container");
   #sendl("grab ruby-spellbook");
   #sendl("put $ac_container $main_container");
   sendl("get $rent_container $main_container");
   sendl("put $main_container $rent_container");
   sendl("wear all");
   $mode = "Rent";
};

sub wear_damage {
   #sendl("get $ac_container $main_container");
   #sendl("get staff-serpents-serpent-snake $ac_container");
   #sendl("put $ac_container $main_container");
   sendl("get $control_container $main_container");
   sendl("get all $control_container");
   sendl("put $main_container $control_container");
   sendl("wie staff");
   sendl("wear all");
   $mode = "Control";
};

1;
}
