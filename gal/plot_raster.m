function plot_raster(trains)
  
clf; hold on;
for i_unit = 1:length(trains)
  times = trains{i_unit};  
  plot(times, i_unit*ones(size(times)), '.')
end
  
