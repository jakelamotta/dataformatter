function sout = mergestruct(a,b)
%MERGESTRUCT Merge structures with unique fields.
     
%   Copyright 2009 The MathWorks, Inc.
fnames = fieldnames(a);
s = length(fnames);

sout = struct;

for i=1:s
   fname = fnames{i};
   
   if isfield(a,fname) && isfield(b,fname)
       sout.(fname) = [a.(fname),b.(fname)];
   elseif isfield(a,fname) && ~isfield(b,fname)
       sout.(fname) = a.(fname);
   elseif ~isfield(a,fname) && isfield(b,fname)
       sout.(fname) = b.(fname);
   end
end

end