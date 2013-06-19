
init
mode = 'bursts';
figure(1); clf; hold on ;
figure(2); clf; hold on ;


parms.significance_threshold = 0.03;

sessionConfigs = getAllSessionConfigs();
session_names = fieldnames(sessionConfigs);
num_sessions = length(session_names);
cm = jet(num_sessions);
for i_session = 1:num_sessions;

  % Load data
  data = loadData(session_names{i_session});
  time_of_bac = 60*20*3;
    
  switch mode
   case 'bursts'
    burst_mode = 'gamma_on_base';
    [burst_times, pvalues] = detect_bursts(burst_mode, data.unitSpikeTimes, parms);
    window_length = 60*20; 
    isis = calc_isis(burst_times, window_length);
    num_bins = 10;
    [Dkl, rate] = track_dist_changes(isis, data.nBaselineHours, num_bins);
    
    xxx = 1:length(isis);
    figure(1); hold on ;  title('Dkl');
    hs(i_session) = plot(xxx, smooth(Dkl), 'Color', cm(i_session,:), 'linewidth', 3);
    % hl = legend(hs(i_session), session_names{i_session});
    figure(2); hold on ; title('burst rate');
    plot(xxx, smooth(rate), 'Color', cm(i_session,:), 'linewidth', 3);
    axis([0 50 0 0.06]);
    % legend(hs, session_names);
    drawnow;
    
   case 'isi' 
    plot_isis(data);
   case 'rate'
    plot_rate_vs_time;
   otherwise
    error('invalid mode = %s\n', mode);
  end

end