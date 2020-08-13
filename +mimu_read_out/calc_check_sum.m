function [ck] = calc_check_sum(command)
% The checksum is a simple 16-bit modular addition of all proceeding bytes in
% the command/response stored in big-endian format.
    ck = [(sum(command)-mod(sum(command),256))/256 mod(sum(command),256)];
end

