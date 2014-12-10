function [data,blank] = olftest(p_data,p_blank)
data = xlsread(p_data);
data = data(:,3);
blank = csvread(p_blank,3,0);
blank = blank(:,3);

indices_data = find(data > 2000000);
indices_blank = find(blank > 2000000);

avg_data = mean(data(indices_data(1:end)));
avg_blank = mean(blank(indices_blank(1:end)));

ampldiff = avg_data/avg_blank;
blank = blank*ampldiff;

[peak_data,posd] = findpeaks(data);
[peak_blank,posb] = findpeaks(blank);




data(indices_data(1:end)) = NaN;



end

