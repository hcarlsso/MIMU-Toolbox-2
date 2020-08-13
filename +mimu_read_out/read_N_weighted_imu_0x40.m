function data_tot = read_N_weighted_imu_0x40(com,N)



% 
header_cmd = hex2dec('40');
% Output imus 1-4

outputmode = [...
    '0001',... % rate divider
    '0',... % Lossy/lossless Does not matter USB
    '1',... % Single: 1 /even: 0 rate transmission
    '1',... % Raw inertial 
    '0']; %  Temperature 
arg = [0 0 0 bin2dec('0001') bin2dec(outputmode)];
command = [header_cmd arg];
cksum = calc_check_sum(command);

final_command = [command cksum];
fwrite(com,final_command,'uint8');
ack = fread(com,4,'uint8');

check_header(ack,header_cmd);

data_tot = cell(N,1);

for n = 1:N

    

    if Sz > 0
        data = fread(com,Sz,'uint8');
        disp('Data');
        data_tot{n} = data;
    else
        disp('No Data') 
        data_tot{n} = nan;
    end

    
    if Sz > 0
        package_to_check = [header; Nt; Sz; data];
    else
        package_to_check = [header; Nt; Sz];
    end
    ck = fread(com,2,'uint8');
    ck_sum_rec = calc_check_sum(package_to_check);
        
    if all(ck == ck_sum_rec)
        disp('Checksum correct')
    else
        disp('Checksum incorrect')
    end
end

stop_output_0x22(com)

end