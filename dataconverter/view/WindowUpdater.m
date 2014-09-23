classdef WindowUpdater < handles
    %WINDOWUPDATER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties 
        textField;
        datatypeBtn;
        sourceBtn;
        targetBtn;
        expBtn;
        main;
    end
    
    methods (Access=public)
        
        function this = WindowsUpdater(m)
            this.main = m;
        end
        
        function updateView(this,str)
            
        end
    end    
end

