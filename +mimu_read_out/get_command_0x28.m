function final_command = get_command_0x28(imus, varargin)
% Output raw IMU data
% Tells the module to output the raw data read from the IMUs together with
% a common time stamp (4 bytes). The 32 bits in the bit-field correspond
% to the up to potentially 32 IMUs of the modules. A set bit will give the
% data from the corresponding IMU. If a bit is set which corresponds to a non-
% existing IMU, zeros will be output. (The states are still there but no data
% is ever written to the states.) The time stamp (state 0x01) is a 32-bit clock
% register read when the data is received from the IMUs. With a 64MHz clock
% frequency, this time stamp will wrap every 67s.
% The output mode byte works the same way as for the general state output
% command but in addition to the rate divider (1st-4th bit), the lossy/lossless
% bit (5th bit) and the single/even rate transmission bit (6th bit), the 7th and
% 8th bit indicate if the raw inertial and/or the temperature readings of the
% IMUs should be output. The inertial data is 2 x 6 bytes per IMU and the
% temperature is 2 bytes per IMU.

    import mimu_read_out.*
    header_cmd = hex2dec('28');

    
    % Between 1 and 32
    validImuNumber = @(x) ~isempty(x) && all(x > 0) && all(x < 33) && length(x) < 33;
    
    p = inputParser;
    addRequired(p,'imus', validImuNumber); 
    
    imus_active = repmat('0', 1,32);
    imus_active(imus) = '1';

    arg_bin = fliplr(imus_active);    
    inds = reshape(1:length(arg_bin), 8, []);
    arg_dec = zeros(1, size(inds,2));
    for i = 1:size(inds, 2)
        arg_dec(i) = bin2dec(arg_bin(inds(:,i)));
    end

    final_command = [header_cmd arg_dec get_outputmode(varargin{:})];

end

