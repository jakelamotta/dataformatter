classdef (Abstract) AbstractDataAdapter
    %ABSTRACTDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Abstract)
        obj = getDataObject(this,paths)
    end
    
end

