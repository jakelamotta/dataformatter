classdef AbstractDataAdapter
    %ABSTRACTDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fileName
    end
    
    methods (Abstract)
        
        function obj = getDataObject(this)
            
        end
        
        function this = setFileName(this,f)
            this.fileName = f;
        end
    end
    
end

