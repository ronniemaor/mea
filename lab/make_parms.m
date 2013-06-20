function parms = make_parms(varargin)
    parms = struct;
    if mod(nargin,2) ~= 0
        error('make_parms inputs should be name, value, name, value...')
    end
    nargs = nargin/2;
    for i=1:nargs        
        parms.(varargin{2*i-1}) = varargin{2*i};
    end
end