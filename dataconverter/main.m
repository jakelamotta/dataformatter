function main()
%MAIN this is the starting point of the dataconverter program

handler = GUIHandler;
mnger = DataManager;

handler.manager = mnger;
handler.launchGUI('mainwindow');

while true

    if handler.exit
        break;
    end
    pause(0.1);
end

end