function main()
%MAIN this is the starting point of the dataconverter program

clear classes;

global matrixColumns;
global colors;

colors = {'black','blue','yellow','green'};
[a,b,matrixColumns] = xlsread(Utilities.getpath('behavior_variables.xls'));

handler = GUIHandler();
% mnger = DataManager;
% 
% handler.manager = mnger;
% handler.run();
% 
% while true
% 
%     if handler.exit
%         break;
%     end
%     pause(0.1);
% end

end