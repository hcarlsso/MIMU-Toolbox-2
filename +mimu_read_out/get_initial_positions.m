function [r] = get_initial_positions()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% In meter 
% In the axes of array coordinate system
dx = 0.0063; dy = 0.0063; dz = 0.001;
r = [-1.5*dx  0.5*dy  1*dz;   %  1
     -1.5*dx  0.5*dy -1*dz;   %  2
     -1.5*dx  1.5*dy  1*dz;   %  3
     -1.5*dx  1.5*dy -1*dz;   %  4
     -1.5*dx -1.5*dy  1*dz;   %  5
     -1.5*dx -1.5*dy -1*dz;   %  6
     -1.5*dx -0.5*dy  1*dz;   %  7
     -1.5*dx -0.5*dy -1*dz;   %  8
     -0.5*dx  0.5*dy  1*dz;   %  9
     -0.5*dx  0.5*dy -1*dz;   % 10
     -0.5*dx  1.5*dy  1*dz;   % 11
     -0.5*dx  1.5*dy -1*dz;   % 12
     -0.5*dx -1.5*dy  1*dz;   % 13
     -0.5*dx -1.5*dy -1*dz;   % 14
     -0.5*dx -0.5*dy  1*dz;   % 15
     -0.5*dx -0.5*dy -1*dz;   % 16
      0.5*dx  0.5*dy  1*dz;   % 17
      0.5*dx  0.5*dy -1*dz;   % 18
      0.5*dx  1.5*dy  1*dz;   % 19
      0.5*dx  1.5*dy -1*dz;   % 20
      0.5*dx -1.5*dy  1*dz;   % 21
      0.5*dx -1.5*dy -1*dz;   % 22
      0.5*dx -0.5*dy  1*dz;   % 23
      0.5*dx -0.5*dy -1*dz;   % 24
      1.5*dx  0.5*dy  1*dz;   % 25
      1.5*dx  0.5*dy -1*dz;   % 26
      1.5*dx  1.5*dy  1*dz;   % 27
      1.5*dx  1.5*dy -1*dz;   % 28
      1.5*dx -1.5*dy  1*dz;   % 29
      1.5*dx -1.5*dy -1*dz;   % 30
      1.5*dx -0.5*dy  1*dz;   % 31
      1.5*dx -0.5*dy -1*dz]'; % 32

% Reorder measurements instead of the positions.
% a = r(:,1);
% b = r(:,2);
% r(:,1) = b;
% r(:,2) = a;
% 
% a = r(:,31);
% b = r(:,32);
% r(:,31) = b;
% r(:,32) = a;

end

