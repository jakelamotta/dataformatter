newTimes = [];

for i=1:length(uTimes)
    newTimes(i) = str2num(strrep(uTimes{1,i},':',''))/100;
end