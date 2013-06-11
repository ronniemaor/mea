function [trains, filename] = load_data(datatype)
% 
% Load data
% 


  switch datatype
    case 1, 
     dirname = fullfile('/', 'cortex', 'data', 'MEA', 'Slutsky2013', '10um bac');
     filename = '16.10.12_filtered.mat';
    case 2,
     dirname = fullfile('/', 'cortex', 'data', 'MEA', 'Slutsky2013', '10um bac');
     filename = '16.3.13_final_filtered.mat';
    case 3,
     dirname = fullfile('/', 'cortex', 'data', 'MEA', 'Slutsky2013', '1um bac');
     filename = '13.3.13_final_filtered.mat';
    case 4,
     dirname = fullfile('/', 'cortex', 'data', 'MEA', 'Slutsky2013', '1um bac');
     filename = '2.9.12_filtered.mat';
   otherwise, error('invalid session');
  end

  fullname = fullfile(dirname, filename)
  data = load(fullname);
  
  % transform into spike matrix 
  trains = parse_data(data);
end