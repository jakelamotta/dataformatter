function main()
%MAIN this is the starting point of the dataconverter program

clear all;
clear classes;

setGlobalVariables();
% p = {'C:\Users\Kristian\Downloads\behaviour test.xlsx'};
% ad = BehaviorDataAdapter();
% obj = ad.getDataObject(p);
% obj;
GUIHandler();

end

function setGlobalVariables()
    global matrixColumns;
    global colors;
    global varmap;

    varmap = containers.Map();

    fid = fopen(Utilities.getpath('insects.txt'),'r');
    line = fgets(fid);
    flies = cell(1,1);
    index = 1;

    while line ~= -1
        flies{1,index} = line;
        index = index +1;
        line = fgets(fid);
    end

    nrOfInsects = length(flies);
    matrixColumns = cell(1,length(flies)*2+3);
    flies = lower(flies);
    for i=1:nrOfInsects
        varmap([strrep(flies{i},char([13,10]),''),'d']) = [Utilities.padString(strrep(flies{i},char([13,10]),''),'_',5),'_dur'];
        varmap([strrep(flies{i},char([13,10]),''),'f']) = [Utilities.padString(strrep(flies{i},char([13,10]),''),'_',5),'_fre'];
        matrixColumns{2*i-1} = [Utilities.padString(strrep(flies{i},char([13,10]),''),'_',5),'_dur'];
        matrixColumns{2*i} = [Utilities.padString(strrep(flies{i},char([13,10]),''),'_',5),'_fre'];
    end
    
    matrixColumns{end-2} = 'multi_dur';
    matrixColumns{end-1} = 'multi_fre';
    matrixColumns{end} = 'nofly';
    
    colors = {'black','blue','yellow','green'};

%     type  = expQuest();
% 
%     if strfind(type,'Behavior')
%         [a,b,matrixColumns] = xlsread(Utilities.getpath('behavior_variables.xls'));
%     elseif strfind(type,'Pollination')
%         [a,b,matrixColumns] = xlsread(Utilities.getpath('behavior_variables.xls'));
%     end
end