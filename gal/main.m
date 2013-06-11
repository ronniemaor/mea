
init

% Load data
[trains, filename] = load_data(1);
num_units = length(trains);
time_of_bac = 60*20*3


% Analyze
mode = 'bursts';

switch mode
 case 'bursts'
  [burst_times, pvalues] = detect_bursts(trains, parms);
 case 'isi', 
  plot_isis;
 case 'rate', 
  plot_rate_vs_time;
 otherwise
  error('invvalid mode = %s\n', mode);
end