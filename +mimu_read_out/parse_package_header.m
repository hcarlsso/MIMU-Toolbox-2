function [Sz, header, Nt] = parse_package_header(package_header)
    header = package_header(1);
    disp(['header, should be AA: ' dec2hex(header)])
    Nt = package_header(2:3);
    show_package_number(Nt)
    Sz = package_header(4);
    disp(['Payload size:' num2str(Sz) ' bytes'])
end

