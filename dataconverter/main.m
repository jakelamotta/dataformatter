function main()
%MAIN this is the starting point of the dataconverter program

clear all;
clear classes;

global matrixColumns;
global colors;

colors = {'black','blue','yellow','green'};

type  = expQuest();

if strfind(type,'Behavior')
    [a,b,matrixColumns] = xlsread(Utilities.getpath('behavior_variables.xls'));
elseif strfind(type,'Pollination')
    [a,b,matrixColumns] = xlsread(Utilities.getpath('behavior_variables.xls'));
end

handler = GUIHandler();

end