function isis = calc_isis(spike_times, window_length)
%
  num_windows = ceil(max(spike_times)/window_length);
  isis = cell(1, num_windows);
  for i_window = 1:num_windows
    t_end = i_window * window_length;
    t_start = t_end - window_length;
    t = spike_times(spike_times > t_start & spike_times <= t_end);
    isis{i_window} = diff(t);
  end
end
