function res = actualTime(t,bHuman)
% Convert from the "times" reported by the system to actual times
% Each 20 minutes of input time belongs to another hour,
% so second 20 minutes is from 1:00:00 to 1:20:00 etc.
% After the 28th 20 minute part the jumps are 2 hours, so 
% the 29th 20 minute part doesn't start at 28:00:00 but at 29:00:00
% and the 30th 20 minute part starts at 31:00:00
    if nargin < 2
        bHuman = 0;
    end
    
    nHours = floor(t/1200);
    
    % after hour 27 each "hour" skips two hours (next hour is 29)
    if nHours > 27
        nHours = 27 + 2*(nHours-27);
    end
        
    nSec = mod(t,1200);
    res = 3600*nHours + nSec;
    
    if bHuman
        res = humanTime(res);
    end
end