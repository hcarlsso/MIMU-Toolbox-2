function check_ack(ack,header_cmd)
    
if ack(1) ~= hex2dec('a0')
    disp('Incorrect ACK header')
    return
else
    disp('Correct ACK header')
end

if ack(2) ~= header_cmd
    disp('Incorrect cmd header in ack')
    return
else
    disp('Correct cmd header in ACK')
end

if ack(3:4) ~= calc_check_sum(ack(1:2))
    disp('Incorrect ack cksum')
    return
else
    disp('Correct ACK cksum')
end

end

