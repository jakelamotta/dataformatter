s = size(c{1});
counter = 0;

for i=1:s(2)
    temp = c{1}(i);
    
    temp = strrep(temp,'[','');
    temp = strrep(temp,']','');
    temp = strrep(temp,',','');
    
    if ~strcmp(temp{1}(1),'{') && ~strcmp(temp{1}(end),'}')
        %temp(end)
        counter = counter + 1;
        temp{1}
    end    
    
end

disp(counter);