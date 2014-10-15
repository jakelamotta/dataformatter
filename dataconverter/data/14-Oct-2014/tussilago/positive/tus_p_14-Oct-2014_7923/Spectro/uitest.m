function uitest(varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    t = varargin{3};
    
    disp('called back');
    disp(get(t,'selected'));
end

