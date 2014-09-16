function main()
%MAIN this is the starting point of the dataconverter program

handler = GUIHandler;
mnger = DataManager;

handler.manager = mnger;
handler.run();

while true

    if handler.exit
        break;
    end
    pause(0.1);
end

end