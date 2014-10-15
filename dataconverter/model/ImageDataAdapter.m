classdef ImageDataAdapter < DataAdapter
    %IMAGEDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        
    end
    
    methods (Access = public)
        
        function this = ImageDataAdapter()
        
        end
        
        function rawData = fileReader(this,path)
            rawData = fileReader@DataAdapter(this,path);
        end
        
    end    
end

