
%
% plot_rate_vs_time
%

init
init_plot;
do_save=0;

% Load data 
[trains, filename] = load_data(i_session);
window_length = 600; % 1200 ==> 20min, then skipped to next hour
time_of_bac = 60*20*3; % three hours, 20min each, in seconds


% Estimate recovery of individual cells
figure(1); clf; hold on;
num_units = length(trains);
cmap = hsv(num_units); 
recoveries = zeros(num_units,1);
for i_unit=1:num_units
  times = trains{i_unit};
  % round times into buckets of size window-length
  times = window_length*ceil(times/window_length);
  rate = sparse(times, ones(size(times)), ones(size(times)));
  base_rate = max(rate(1:time_of_bac));
  compressed_rate = rate(window_length:window_length:end) / base_rate;
  xxx = (1:length(compressed_rate));
  plot(xxx, compressed_rate, CLR, cmap(i_unit,:), LW, 2);
  recoveries(i_unit) = mean(compressed_rate(end-10:end));
end
plot([min(xxx) max(xxx)], [1 1], CLR, [0.5 0.5 0.5]);
xlabel('samples', FS, 20)
ylabel('firing rate (vs baseline)', FS, 20)
set(gca, 'Fontsize', 20);

mean_recovery = mean(recoveries)

% Estimate recovery of overall firing rate
if 1 
  times = sort(cell2mat(trains'));
  times = window_length*ceil(times/window_length);
  rate = sparse(times, ones(size(times)), ones(size(times)));
  base_rate = max(rate(1:time_of_bac));
  compressed_rate = rate(window_length:window_length:end) / base_rate;
  xxx = (1:length(compressed_rate));
  plot(xxx, compressed_rate, CLR, [0 0 0], LW, 5);
  recovery = mean(compressed_rate(end-10:end));
end

fig_filename = sprintf('Figures/rate_recovery_%s', filename);
fig_save(fig_filename, do_save);


% Estimaet network burst sizes, as a function of time and burst widths
% Estimate recovery of overall firing rate
binsizes = [1 2 5 10 20 50];
for binsize = binsizes
  binsize
  times = sort(cell2mat(trains'));
  times = binsize*ceil(times/binsize);
  rate = sparse(times, ones(size(times)), ones(size(times)));
  compressed_rate = rate(binsize:binsize:end);
  xxx = (1:length(compressed_rate));
  figure(2); clf; hold on;
  plot(xxx, compressed_rate, CLR, [0 0 0], LW, 2);

  fmt = 'Figures/network_counts_binsize%d_%s';
  fig_filename = sprintf(fmt, binsize, filename);
  fig_save(fig_filename, do_save);
  pause(0.5)
end
xlabel('samples', FS, 20)
ylabel('network spike count', FS, 20)
set(gca, 'Fontsize', 20);
