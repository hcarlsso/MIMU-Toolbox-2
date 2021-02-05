function a = skew_sym(b)
% Make a 3x3 matrix to return
% Could maybe just print the matrix tensor directly here.
    a = [  0 -b(3)  b(2); 
         b(3)   0  -b(1); 
        -b(2) b(1)    0];
end

