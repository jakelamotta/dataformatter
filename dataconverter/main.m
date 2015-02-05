function main()

clear all;
clear classes;

setGlobalVariables();

handler = GUIHandler();

end

%%Initializes the only global variables in the program. 
function setGlobalVariables()
    global matrixColumns; %
    global colors;  %A cell containing colors for plotting
    global varmap;    
        
    %varMap is a hash table for creating variable names for behavior data...
    varmap = containers.Map();
    
    [notUsed,notUsed2,data] = xlsread(Utilities.getpath('behavior_variables.xls'));
    
    %...using a predefined insects-file.
    fid = fopen(Utilities.getpath('insects.txt'),'r');
    line = fgets(fid);
    flies = cell(1,1);
    index = 1;

    
    while line ~= -1
        flies{1,index} = line;
        index = index +1;
        line = fgets(fid);
    end
    
    fclose(fid);
    
    nrOfInsects = length(flies);
    behaveCols = cell(1,length(flies)*2+3);

    %Build up variable names from the insect names
    for i=1:nrOfInsects
        varmap([strrep(flies{i},char([13,10]),''),'d']) = [Utilities.padString(strrep(flies{i},char([13,10]),''),'_',5),'_dur'];
        varmap([strrep(flies{i},char([13,10]),''),'f']) = [Utilities.padString(strrep(flies{i},char([13,10]),''),'_',5),'_fre'];
        behaveCols{2*i-1} = [Utilities.padString(strrep(flies{i},char([13,10]),''),'_',5),'_fre'];
        behaveCols{2*i} = [Utilities.padString(strrep(flies{i},char([13,10]),''),'_',5),'_dur'];
    end
    
    behaveCols{end-2} = 'multi_dur';
    behaveCols{end-1} = 'multi_fre';
    behaveCols{end} = 'nofly';
    
    matrixColumns = [data,behaveCols];
    
    colors = {'black','blue','yellow','green'};
end