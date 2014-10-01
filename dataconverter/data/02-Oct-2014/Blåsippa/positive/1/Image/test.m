k = getappdata(0,'v');

while k < 10
    k = k+1;
    setappdata(0,'v',k);
    drawnow;
    pause(1);
end