function ad = merge_array_data(a1, a2)
    
    ad.raw_acc = zeros(3*8, length(a1.time));
    ad.raw_gyro = zeros(3*8, length(a1.time));
    ad.raw_gyrod = zeros(3*8, length(a1.time));
    ad.time = a1.time;
    
    
    for m = 1:4
        
        % Put array 2 first, since a1 is rotated wrt to a2
        inds = (1+3*(m-1):3*m);
        ad.raw_acc(inds, :) = squeeze(a2.raw_acc(:,m,:));
        ad.raw_gyro(inds, :) = squeeze(a2.raw_gyro(:,m,:));
        ad.raw_gyrod(inds, :) = squeeze(a2.raw_gyrod(:,m,:));

        inds = (1+3*(m-1):3*m) +3*4;
        ad.raw_acc(inds, :) = squeeze(a1.raw_acc(:,m,:));
        ad.raw_gyro(inds, :) = squeeze(a1.raw_gyro(:,m,:));
        ad.raw_gyrod(inds, :) = squeeze(a1.raw_gyrod(:,m,:));
    end
end