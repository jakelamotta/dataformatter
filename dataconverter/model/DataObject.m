classdef DataObject
    %DATAOBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        xlsMatrix
    end
    
    methods (Access=Public)
        
        function this = DataObject(x,y)
            this.xlsMatrix = cell(x,y);
        end
        
    end
    
end

