function [d2,d3,peak2,peak3] = olftest()
p2 = 'C:\Users\Kristian\Downloads\olf\4plot_site2_2.csv.xlsx';
p3 = 'C:\Users\Kristian\Downloads\olf\4plot_site2_3.csv.xlsx';

site2 = xlsread(p2);
site3 = xlsread(p3);

d2 = site2(:,3);
d3 = site3(:,3);

peak2 = findpeaks(d2);
peak3 = findpeaks(d3);

peak2 = peak2(peak2>2000000);
peak3 = peak3(peak3>2000000);
end

