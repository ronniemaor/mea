

% Load data

dirname = fullfile('/', 'cortex', 'data', 'MEA', 'Slutsky2013', '10um bac');
filename = fullfile(dirname, '16.10.12_filtered.mat')
data = load(filename);


% transform into spike matrix 
trains = parse_data(data);
num_units = length(trains);
time_of_bac = 60*20*3

% Compute ISI pair distribution
window = [1, time_of_bac]
% plot_raster(trains)



for i_unit=1:num_units

  times = trains{i_unit};
  times = times(times<time_of_bac);
  
  isi = diff(times);
  isi1 = isi(1:end-1);
  isi2 = isi(2:end);
  
  figure(1); clf; hold; 
  h = plot(log10(isi1), log10(isi2), '.');
  % set(gca, 'xscale', 'log', 'yscale', 'log');
  
  figure(2); clf; hold on;
  hist(log10(isi), 100);
  
  pause
  
end

% four hours of 20min each in seconds

% t = find(spike_times>