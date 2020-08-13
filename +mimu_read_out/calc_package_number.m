function N = calc_package_number(b1,b2)
    hex_tot = [dec2hex(b1) dec2hex(b2) ];
    N = hex2dec(hex_tot);
end