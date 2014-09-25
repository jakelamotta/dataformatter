classdef DataObject
    %DATAOBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        xlsMatrix;
    end
    
    methods (Access = public)
        
        function this = DataObject(x,y)
            this.xlsMatrix = cell(x,y);
            this.objectList = cell(1);
        end
        
        function this = setObservation(this,matrix)
            this.xlsMatrix = matrix;
            size_ = size(this.objectList);
        end
    end    
end

