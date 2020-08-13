function cmd = get_outputmode(varargin)
%get_outputmode construct output mode command

    p = inputParser;

    expectedRateTypes = {'single','even'};
    expectedTransmissionModes = {'lossy', 'lossless'};
    
    addOptional(p,'temp', false, @(x) islogical(x)); 
    addOptional(p,'inertial', false, @(x) islogical(x));
    addParameter(p,'rate_type', 'even', @(x) any(validatestring(x, expectedRateTypes)));
    addParameter(p,'transmission_mode', 'lossy', @(x) any(validatestring(x, expectedTransmissionModes)));
    addParameter(p,'rate_divider', 1, @(x) x > 0 &&  x < 16);
    
    parse(p,varargin{:});
    
    outputmode = repmat('0', 1,8);
    
    if p.Results.temp
        outputmode(8) = '1';
    end
    
    if p.Results.inertial
        outputmode(7) = '1';
    end
    
    % 0: even/continous output, at the rate specified by rate_divider
    % 1: output is pulled a single time.
    if strcmp(p.Results.rate_type,'single')
        outputmode(6) = '1';
    end
    
    % 0: lossy transmission mode
    % 1: lossless transmission mode
    if strcmp(p.Results.transmission_mode, 'lossless')
        outputmode(5) = '1';
    end
        
    outputmode(1:4) = fliplr(dec2bin(p.Results.rate_divider, 4));
    
    cmd = bin2dec(fliplr(outputmode));
end

