package Pinger;  # Такое же как и имя этого файла без
                 # расширения '.pm'

use MUD;
use CMD;

require Exporter;    # Обязательная строка для экспорта имен
@ISA = qw(Exporter); # -//-
@EXPORT = qw(ping_to_me ping_to_group show_status add_mob show_list show_list_background del_mob_by_name ping_proceed mob_up mobs_down show_mob_name); # Перечисляем имена функций.
            # Внимание ! нет запятой!
#@EXPORT_OK = qw($pinging);  # Указать публичные
               # переменные, массивы и т.д. если необходимо

{  # Начало блока модуля

%is_up = ();
%ticks_up = ();
%ticks_down = ();
%repops = ();
%repop_min = ();
%repop_max = ();
%msg_up = ();
%msg_down = ();
%time_known = ();
%time_repoped = ();
%repop_flag = ();
$only_for_me = 1;
$DEBUG = 0;

sub pinger_debug {
	$DEBUG = @_[0];
}

sub ping_to_me {
	$only_for_me = 1;
	CMD::cmd_echo("Ping will report only for me (use /pingtogroup for change).");
};

sub ping_to_group {
	$only_for_me = 0;
	CMD::cmd_echo("Ping will report for all group (use /pingtome for change).");
};

sub show_status {
	if ( $only_for_me ) {
		CMD::cmd_echo("Ping report only for me (use /pingtogroup for change).");
	} else {
		CMD::cmd_echo("Ping report for all group (use /pingtome for change).");
	};
};


sub add_mob {
	$name = @_[0];
	if ( $name ne "" ) {
	        for ($i = 1; $i < @_; ++$i) { 
			$name = $name.'-'.$_[$i]; 
		};

		$is_up{$name} = 0;
		$ticks_up{$name} = 0;
		$ticks_down{$name} = 0;
		$repops{$name} = -1;
		$repop_max{$name} = 0;
		$repop_min{$name} = 100;
		$msg_up{$name} = '';
		$msg_down{$name} = '';
		$time_known{$name} = 0;
		$time_repoped{$name} = 0;
		if ( $only_for_me ) {
			CMD::cmd_echo("$name added to pinglist.");
		} else {
		        MUD::sendl("gt $name added to pinglist.");
		};
		MUD::sendl("tell $name ##pinger## $name");
	};

};

sub show_list {
	if ( $only_for_me ) {
		CMD::cmd_echo("Pinglist:");
##sprintf("%02d",$Time[3])
		CMD::cmd_echo("       Mob Name       |Status| TicksU/D | RTMin | RTMax | Count");
			foreach $keyword ( sort(keys(%is_up)) ) { 
			
				if ( $is_up{$keyword} ) {
					$str = sprintf("%20s | %4s | %8d | %5d | %5d | %d | %d | %d",substr($keyword,0,20),"UP",$ticks_up{$keyword},$repop_min{$keyword},$repop_max{$keyword},$repops{$keyword});
				} else {
					$str = sprintf("%20s | %4s | %8d | %5d | %5d | %d | %d | %d",substr($keyword,0,20),"DOWN",$ticks_down{$keyword},$repop_min{$keyword},$repop_max{$keyword},$repops{$keyword});
				}
				CMD::cmd_echo("$str");
			};
	} else {
		MUD::sendl("gt Pinglist:");
		MUD::sendl("       Mob Name       |Status| TicksU/D | RTMin | RTMax | Count");
			foreach $keyword ( sort(keys(%is_up)) ) { 
				if ( $is_up{$keyword} ) {
					$str = sprintf("%20s | %4s | %8d | %5d | %5d | %d | %d | %d",substr($keyword,0,20),"UP",$ticks_up{$keyword},$repop_min{$keyword},$repop_max{$keyword},$repops{$keyword});
				} else {
					$str = sprintf("%20s | %4s | %8d | %5d | %5d | %d | %d | %d",substr($keyword,0,20),"DOWN",$ticks_down{$keyword},$repop_min{$keyword},$repop_max{$keyword},$repops{$keyword});
				}
				MUD::sendl("gt $str");
			};
	};
};


sub show_list_background {
	my @Time = localtime;
	my $min = ''; if ($Time[1] < 10) { $min = sprintf("%02d",$Time[1]); } else { $min = sprintf("%2d",$Time[1]); }
	my $hou = ''; if ($Time[2] < 10) { $hou = sprintf("%02d",$Time[2]); } else { $hou = sprintf("%2d",$Time[2]); }

        CMD::cmd_wecho(1,"--\003P $hou:$min \003H----------------------------------------------------------");
	CMD::cmd_wecho(1,"Pinglist:");
	CMD::cmd_wecho(1," ## |       Mob Name       |Status| Ticks U/D | RTMin | RTMax | Count");
		foreach $keyword ( sort(keys(%is_up)) ) {
			if ( $is_up{$keyword} ) {
					$str = sprintf("%20s | %4s | %8d | %5d | %5d | %d | %d | %d",$keyword,"UP",$ticks_up{$keyword},$repop_min{$keyword},$repop_max{$keyword},$repops{$keyword});
				} else {
					$str = sprintf("%20s | %4s | %8d | %5d | %5d | %d | %d | %d",$keyword,"DOWN",$ticks_down{$keyword},$repop_min{$keyword},$repop_max{$keyword},$repops{$keyword});
				}
			CMD::cmd_wecho(1,"$str");
		};
	CMD::cmd_wecho(1,"-------------------------------------------------------------------\n\n");
};

sub del_mob_by_name {
	$name = @_[0];
	
	if ( $only_for_me ) {
		CMD::cmd_echo("$name deleted from pinglist.");
	} else {
	        MUD::sendl("gt $name deleted from pinglist.");
	};
	delete($is_up{$name});
	delete($ticks_up{$name});
	delete($ticks_down{$name});
	delete($repops{$name});
	delete($repop_min{$name});
	delete($repop_max{$name});
	delete($msg_up{$name});
	delete($msg_down{$name});
	delete($time_known{$name});
	delete($time_repoped{$name});
	delete($repop_flag{$name});
};

sub show_mob_name {
	$name = @_[0];
	foreach $keyword ( sort(keys(%is_up)) ) {
		if ( $keyword =~ m/$name/i )  {
			if ( $only_to_me ) {
				CMD::cmd_echo("$keyword");
			} else {
				MUD::sendl("gt $keyword");
			}
		}
	}
}

sub ping_proceed {
	if ( %is_up ) {
		foreach $name ( sort(keys(%is_up)) ) { 
			MUD::sendl("tell $name ##pinger## $name");
			$repop_flag{$name} = 0;
		};
		MUD::sendl("tell bal-innkeeper ##pingerend##");	
	}
};

sub mob_up {
	$keyword = @_[0];
	$now = time;
	$repop_flag{$keyword} = 1;
	if ( ! $is_up{$keyword} ) {
		$ticks_up{$keyword} = 0;
		$repop_min{$name} = $ticks_down{$keyword};
		$ticks_down{$keyword} = 0;
		$repops{$keyword} = $repops{$keyword} + 1;
	} else {
		$ticks_up{$keyword} = $ticks_up{$keyword} + 1;
	}
	
	
	# if ( ! $is_up{$keyword} ) {
		# if ( $DEBUG ) {
			# CMD::cmd_echo("$keyword $time_repoped{$keyword}-$now");			
		# }
		# $ticks_up{$keyword} = 0;
		# $time_repoped{$keyword} = time;
		# if ( $ticks_down{$keyword} > $repop_max{$keyword} || $repop_max{$keyword} == 0 ) { $repop_max{$keyword} = $ticks_down{$keyword}; };
		# if ( $ticks_down{$keyword} < $repop_min{$keyword} || $repop_min{$keyword} == 0 ) { $repop_min{$keyword} = $ticks_down{$keyword}; };		
		# $ticks_down{$keyword} = 0;
		# $repops{$keyword} = $repops{$keyword} + 1;
		# if ( $repops{$keyword} eq 0 ) { $repop_time = 0; } else { $repop_time = $now - $time_repoped{$keyword}; };
		# $time_known{$keyword}=$now;
	# } 
	# if ( $is_up{$keyword} ) {
		# $ticks_up{$keyword} = $ticks_up{$keyword} + 1;
		# $time_known{$keyword}=$now;
	# }
	# $is_up{$keyword} = 1;
};

sub mobs_down {
	foreach $keyword ( sort(keys(%is_up)) ) {
		if ( $repop_flag{$keyword} == 0 ) {
			$ticks_down{$keyword} =  $ticks_down{$keyword} + 1;
		}
		# $now = time;
		#CMD::cmd_echo("$i -- $now -- $time_known[$i]--");
		# if ( $time_repoped{$keyword} ) {
			# if ( ($now - $time_known{$keyword}) > 20 ) { $is_up{$keyword} = 0; $ticks_down{$keyword} = int ( ($now - $time_repoped{$keyword} ) / 60 ); };
		# } else { $ticks_down{$keyword} =  $ticks_down{$keyword} + 1; };
	}
}

1;
}

