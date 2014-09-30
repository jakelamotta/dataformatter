classdef DataObject
    %DATAOBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        xlsMatrix;
        id;
    end
    
    methods (Access = public)
        
        function this = DataObject()
            this.xlsMatrix = {'Date','ID','Flower','Year','month','day','hour','min','wind speed (m/s)','direction(degrees)','temperature(c)','relative humidity','pressure'};
            this.xlsMatrix = [this.xlsMatrix;{'','','',0,0,0,0,0,0,0,0,0,0}];
        end
        
        function this = setObservation(this,matrix)
            
            s = size(matrix);            
            
            for i=1:s(2)
                for j=1:this.getWidth()
                    for k=2:s(1);
                        if strcmp(this.xlsMatrix{1,j},matrix{1,i})
                            this.xlsMatrix{k,j} = matrix{k,i};
                        end
                    end
                end                
            end
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
            
            %id = '1';
            id = num2str(round(rand*100));
        end
        
        function matrix = getMatrix(this)
            matrix = this.xlsMatrix;
        end
        
        function this = setMatrix(this,m)
            this.xlsMatrix = m;
        end
        
        
    end    
end

