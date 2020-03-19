package Char;

require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw($my_name $bless $lite $food_container $water_container $holdfrontline);

{

	$my_name = "Besit";
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

	sub ether_attack {
		my $target = shift;
		return "cast 'disint' $target";
	}

	sub solid_attack {
		my $target = shift;
		return "backstab $target\r\nrem cinq\r\nwie sword-valor\r\nflail $target";
	}

	sub before_push {
		return "rem sword-valor\r\nwie cinq";
	}

	sub before_catch {
		return "";
	}

	sub after_catch {
		return "";
	}

	1;
}
