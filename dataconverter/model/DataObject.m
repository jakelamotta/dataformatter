classdef DataObject
    %DATAOBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        xlsMatrix;
        id;
    end
    
    methods (Access = public)
        
        function this = DataObject(x,y)
            this.xlsMatrix = cell(x,y);
        end
        
        function this = setObservation(this,matrix)
            this.xlsMatrix = matrix;
        end
        
        function s = getWidth(this)
            size_ = size(this.xlsMatrix);
            s = size_(2);
        end
        
        function id = getObjectID(this)
            
            for i=1:this.getWidth()
                if strcmp('ID',this.xlsMatrix{1,i})
                    id = this.xlsMatrix{2,i};                   
                end
            end
            
            id = '1';
        end
        
        function matrix = getMatrix(this)
            matrix = this.xlsMatrix;
        end
        
        
        
    end    
end

