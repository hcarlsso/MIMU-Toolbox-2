function p_out = find_payload_size(data, Pmax)

    p_out = 0;
    for p = 1:Pmax
        preceding_bytes = data(1:p);
        ck = calc_check_sum(preceding_bytes);
        disp(p)
        disp([ck data(p+(1:2))'])
        if all(ck == data(p+(1:2))')
            disp('Payload is')
            disp(p)
            p_out = p;
        end
    end
end