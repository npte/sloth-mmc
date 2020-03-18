package Char;

require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw($my_name $bless $lite $food_container $water_container $holdfrontline);
{

	$my_name = "Avl";
	$bless = "bless";
	$armor = "stone skin";
	$lite = "sanctuary";
	$food_container = "pack";
	$recall_container = "pack";
	$water_container = "barrel";
	$holdfrontline = 0;

	$control_container = "red-black-robes";
	$ac_container = "cloak-ancient-sensate-elite-low";
	$rent_container = "cloak-ancient-sensate-elite-low";
	$mana_container = "mantle-multicolored";
	$main_container = "ornate-bag";

	sub ether_attack {
		my $target = shift;
		return "cast 'firewind' $target";
	};

	sub solid_attack {
		my $target = shift;
		return "cast 'firewind' $target";
	};

	sub before_push {
		return "";
	};

	sub before_catch {
		return "eqset wear mana";
	}

	sub after_catch {
		return "eqset wear spelldam";
	}

	1;
}
