function [y] = predictAccArray(w,w_dot,s,r)
import mimu_read_out.*
Na = size(r,2);
N_sens = numel(r);
N = size(w,2);

y = zeros(N_sens, N);
inds = reshape(1:N_sens,3,[]);

for n = 1:N
    W = skew_sym(w(:,n))^2 + skew_sym(w_dot(:,n));
    for k = 1:Na
        kk = inds(:,k);
        y(kk,n) = W*r(:,k) + s(:,n);
    end
end

end

