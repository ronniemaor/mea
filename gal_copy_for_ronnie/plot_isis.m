function plot_isis(data)
    for i_unit=1:data.nUnits
      times = data.unitSpikeTimes{i_unit};
      times = times(times < data.nBaselineHours*1200);

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
end