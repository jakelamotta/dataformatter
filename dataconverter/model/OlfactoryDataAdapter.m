classdef OlfactoryDataAdapter < DataAdapter
    %OLFACTORYDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        
        function obj = getDataObject(this,paths)
            
            size_ = size(paths);
            
            for i=1:size_(2)              
                idx = strfind(paths{1,i},'\');
                id_ = paths{1,i}(idx(end-2)+1:idx(end-1)-1);
                
                rawData = this.fileReader(paths{1,i});
                
                
                
%                 rawData = strrep(rawData,'   ',' ');
%                 rawData = strrep(rawData,'  ',' ');
%                 temp = cellfun(@this.createDob,rawData,'UniformOutput',false);
%                 
%                 for j=1:length(temp)
%                     this.tempMatrix = [this.tempMatrix;temp{1,j}];
%                 end
%                 
%                 this.dobj = this.dobj.setObservation(this.tempMatrix,id_);
            end
            
            obj = this.dobj;
            
        end  
        
    end
    
    methods (Access = private)
        function rawData = fileReader(this,p)
           rawData = fileReader@DataAdapter(this,p); 
        end
    end
    
end

