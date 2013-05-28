function trains = parse_data(data)
%   
  trains = zeros(0,2);
  channels = fields(data);
  total_units_so_far=0;
  for i_chan = 1:length(channels)
    chan = data.(channels{i_chan});
    if ~isempty(chan)
      num_units = max(chan(:,2));
      for i_unit = 1:num_units;
	total_units_so_far = total_units_so_far+1;
	inds = chan(:,2) == i_unit;	
	trains{total_units_so_far} = chan(inds,3);
      end
    end
  end
  
  
end