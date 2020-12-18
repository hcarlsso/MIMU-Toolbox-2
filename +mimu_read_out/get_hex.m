function [cmd_hex] = get_hex(cmd)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    cmd_hex = cellstr(dec2hex(cmd, 2))';


end

