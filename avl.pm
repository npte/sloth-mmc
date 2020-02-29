package Char;  # Такое же как и имя этого файла без
                     # расширения '.pm'
use MUD;
require Exporter;    # Обязательная строка для экспорта имен
@ISA = qw(Exporter); # -//-
#@EXPORT = qw(add_mob ping_proceed); # Перечисляем имена функций.
                          # Внимание ! нет запятой!
@EXPORT_OK = qw($my_name $bless $lite $food_container $water_container $holdfrontline);
#@EXPORT_OK = qw( $переменная @массив );  # Указать публичные
                # переменные, массивы и т.д. если необходимо
{  # Начало блока модуля

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



sub rem_regen {
   MUD::sendl("rem all");
   MUD::sendl("get $main_container $mana_container");
   MUD::sendl("put all.crystal-ring $mana_container");
   MUD::sendl("put sleeves-white-leather $mana_container");
   MUD::sendl("put boots-dolphin-skin $mana_container");
   MUD::sendl("put all.ruby $mana_container");
   MUD::sendl("put gauntlets-shadow-set $mana_container");
   MUD::sendl("put claw-green-dragon $mana_container");
   MUD::sendl("put golden-choker $mana_container");
   MUD::sendl("put circlet-electrum $mana_container");
   MUD::sendl("put golden-belt $mana_container");
   MUD::sendl("put leggings-ogre-hide $mana_container");
   MUD::sendl("put wind-shield $mana_container");
   #MUD::sendl("put bracelet-runed-onyx $mana_container");
   MUD::sendl("put all.bracer-flames $mana_container");
   MUD::sendl("put stricht $mana_container");
   MUD::sendl("put cutter $mana_container");
   MUD::sendl("put dark $mana_container");
   MUD::sendl("put $mana_container $main_container");
};

sub rem_ac {
   MUD::sendl("rem all");
   MUD::sendl("get $main_container $ac_container");
   MUD::sendl("put all.ring-elven-agility-golden $ac_container");
   ##MUD::sendl("put  $ac_container");
   MUD::sendl("put all.cloak-silvery-silver-fur $ac_container");
   MUD::sendl("put mystic-plate-mail $ac_container");
   MUD::sendl("put dragon-crested-helm $ac_container");
   MUD::sendl("put silver-leg-plates $ac_container");
   MUD::sendl("put elvenkind-elven-boots $ac_container");
   MUD::sendl("put shield-skull-great-yawning-death $ac_container");
   MUD::sendl("put gloves-forest-green $ac_container");
   MUD::sendl("put armplates-carved-bone $ac_container");
   MUD::sendl("put rope-belt $ac_container");
   MUD::sendl("put all.polished-steel-bracelet $ac_container");
   MUD::sendl("put star-black-morning $ac_container");
   #MUD::sendl("put staff $ac_container");
   MUD::sendl("put scarab $ac_container");
   MUD::sendl("put star $ac_container");
   MUD::sendl("put $ac_container $main_container");
};

sub rem_rent {
   MUD::sendl("rem all");
   MUD::sendl("get $main_container $rent_container");
   MUD::sendl("put $rent_container $main_container");
   MUD::sendl("get $mana_container $main_container");
   MUD::sendl("put all.crystal-ring $mana_container");
   MUD::sendl("put symbol-dark-lord $mana_container");
   MUD::sendl("put wind-shield $mana_container");
   MUD::sendl("put claw-green-dragon $mana_container");
   MUD::sendl("put platemail-ruby-mail-plate $mana_container");
   MUD::sendl("put cutter $mana_container");
   MUD::sendl("put $mana_container $main_container");
   MUD::sendl("get $ac_container $main_container");
   MUD::sendl("put cloak-silvery-silver-fur $ac_container");
   MUD::sendl("put dragon-crested-helm $ac_container");
   MUD::sendl("put silver-leg-plates $ac_container");
   MUD::sendl("put elvenkind-elven-boots $ac_container");
   MUD::sendl("put armplates-carved-bone $ac_container");
   MUD::sendl("put rope-belt $ac_container");
   MUD::sendl("put all.polished-steel-bracelet $ac_container");
   MUD::sendl("put scarab $ac_container");
   MUD::sendl("put $ac_container $main_container");
   MUD::sendl("get $control_container $main_container");
   MUD::sendl("put gauntlets $control_container");
   MUD::sendl("put $control_container $main_container");
   #MUD::sendl("put spellbook $main_container");
};

sub rem_damage {
   MUD::sendl("rem all");
   MUD::sendl("get $main_container $control_container");
   MUD::sendl("put gauntlets-arcane-moon $control_container");
   MUD::sendl("put eye-undead-haunting $control_container");
   MUD::sendl("put tome-runes-silver-grey $control_container");
   MUD::sendl("put staff-serpents-serpent-snake $control_container");
   MUD::sendl("put rose-corrupted $control_container");
   MUD::sendl("put crown-thorns-twisted $control_container");
   MUD::sendl("put all.strand-silk-opalescent-looped $control_container");
   MUD::sendl("put ankh-decaying-ugly $control_container");
   MUD::sendl("put woven-guards $control_container");
   MUD::sendl("put $control_container $main_container");
   MUD::sendl("get $ac_container $main_container");
   MUD::sendl("put $ac_container $main_container");
};

sub wear_ac {
 MUD::sendl("get $ac_container $main_container");
 MUD::sendl("get all $ac_container");
 MUD::sendl("put $main_container $ac_container");
 MUD::sendl("hold scarab");
 MUD::sendl("wie star-black-morning");
 MUD::sendl("wear all");
 $mode = "AC";
};

sub wear_regen {
 MUD::sendl("get $mana_container $main_container");
 MUD::sendl("get all $mana_container");
 MUD::sendl("put $main_container $mana_container");
 MUD::sendl("hold obsidian-serpent");
 MUD::sendl("wie cutter");
 MUD::sendl("wear all");
 $mode = "Regen";
};

sub wear_rent {
   #MUD::sendl("rem $rent_container");
   MUD::sendl("get $mana_container $main_container");
   #MUD::sendl("put $rent_container $main_container");
   #MUD::sendl("get $mana_container $main_container");
   MUD::sendl("get all.crystal-ring $mana_container");
   MUD::sendl("get wind-shield $mana_container");
   MUD::sendl("get symbol-dark-lord $mana_container");
   MUD::sendl("get claw-green-dragon $mana_container");
   MUD::sendl("get platemail-ruby-mail-plate $mana_container");
   MUD::sendl("get cutter $mana_container");
   MUD::sendl("put $mana_container $main_container");
   MUD::sendl("get $ac_container $main_container");
   MUD::sendl("get cloak-silvery-silver-fur $ac_container");
   MUD::sendl("get dragon-crested-helm $ac_container");
   MUD::sendl("get silver-leg-plates $ac_container");
   MUD::sendl("get elvenkind-elven-boots $ac_container");
   MUD::sendl("get armplates-carved-bone $ac_container");
   MUD::sendl("get rope-belt $ac_container");
   MUD::sendl("get all.polished-steel-bracelet $ac_container");
   MUD::sendl("get scarab $ac_container");
   MUD::sendl("put $ac_container $main_container");
   MUD::sendl("get $control_container $main_container");
   MUD::sendl("get gauntlets-arcane-moon $control_container");
   MUD::sendl("put $control_container $main_container");
   #MUD::sendl("get ruby-spellbook $main_container");
   #MUD::sendl("grab ruby-spellbook");
   #MUD::sendl("put $ac_container $main_container");
   MUD::sendl("get $rent_container $main_container");
   MUD::sendl("put $main_container $rent_container");
   MUD::sendl("wear all");
   $mode = "Rent";
};

sub wear_damage {
   #MUD::sendl("get $ac_container $main_container");
   #MUD::sendl("get staff-serpents-serpent-snake $ac_container");
   #MUD::sendl("put $ac_container $main_container");
   MUD::sendl("get $control_container $main_container");
   MUD::sendl("get all $control_container");
   MUD::sendl("put $main_container $control_container");
   MUD::sendl("wie staff");
   MUD::sendl("wear all");
   $mode = "Control";
};

1;
}