classdef SpectroFilter < Filter
    %SPECTROFILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        
        function filtered = filter(this,unfiltered,type,varargin)
            dsrate = varargin{1};
            filtered = unfiltered;
            
            switch type
                
                case 'sample'
                    
                    tempStruct = filtered.getSpectroData();
                    
                    tempStruct.obs1.x = downsample(tempStruct.obs1.x,dsrate);
                    tempStruct.obs1.y = downsample(tempStruct.obs1.y,dsrate);
                    tempStruct.obs2.x = downsample(tempStruct.obs2.x,dsrate);
                    tempStruct.obs2.y = downsample(tempStruct.obs2.y,dsrate);
                    
                    filtered.addSpectroData(tempStruct2);
                    
                    matrix = filtered.getMatrix();
                    
                    len_ = length(tempStruct.obs1.x);
                    
                    for i=1:len_
                        matrix{1,end+1} = tempStruct.obs1.x(i);
                        matrix{2,end+1} = tempStruct.obs1.y(i);
                    end
                    
                    for i=1:len_
                        matrix{1,end+1} = tempStruct.obs2.x(i);
                        matrix{2,end+1} = tempStruct.obs2.y(i);
                    end
                    
                    filtered = filtered.setMatrix(matrix);
                    
                case 'average'                    
                    filtered = filter@Filter(this,unfiltered,7,9);
            end
            
        end
    end
    
end

