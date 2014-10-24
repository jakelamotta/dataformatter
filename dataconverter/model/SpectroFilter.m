classdef SpectroFilter < Filter
    %SPECTROFILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        
        function filtered = filter(this,unfiltered,type,varargin)
            dsrate = varargin{1};
            this.filtered = unfiltered;
            
            switch type
                
                case 'nofilter'
                    
                    
                    
                case 'average'                    
                    this.filtered = filter@Filter(this,unfiltered,7,9);
            end
            this = this.downSample(dsrate);
            this = this.addSpectrumPoints();
            filtered = this.filtered;
        end
    end
    
    methods (Access = private)
        
        function this = downSample(this,dsrate)
            tempStruct = this.filtered.getSpectroData();
            
            x1 = [tempStruct.obs1.x];
            y1 = [tempStruct.obs1.y];
            x2 = [tempStruct.obs2.x];
            y2 = [tempStruct.obs2.y];
            
            x1new = round(linspace(380,600,dsrate));
            x2new = round(linspace(380,600,dsrate));
            
            y1 = interp1(x1,y1,x1new);
            y2 = interp1(x2,y2,x2new);
            
            tempStruct.obs1.x = x1new;
            tempStruct.obs1.y = y1;
            tempStruct.obs2.x = x2new;
            tempStruct.obs2.y = y2;
            
            this.filtered.addSpectroData(tempStruct);
            
%             matrix = filtered.getMatrix();
%             
%             len_ = length(x1new);
%             
%             for i=1:len_
%                 matrix{1,end+1} = x1new(i);
%                 matrix{2,end+1} = y1(i);
%             end
%             
%             for i=1:len_
%                 matrix{1,end+1} =  x2new(i);
%                 matrix{2,end+1} = y2(i);
%             end
%             
%             filtered = filtered.setMatrix(matrix);
        end
        
        
        function this = addSpectrumPoints(this)
            
            spectro = this.filtered.getSpectroData();
            x1 = [spectro.obs1.x];
            y1 = [spectro.obs1.y];
            x2 = [spectro.obs2.x];
            y2 = [spectro.obs2.y];
            
            width = size(x1);
            
            tempMatrix = this.filtered.getMatrix();
            s = size(tempMatrix);
            
            height = s(1);
            
            spectroMatrix = cell(height,width(2)*2);
            
            for i=1:width(2)
                spectroMatrix{1,i} = x1(i);
                spectroMatrix{2,i} = y1(i);
                spectroMatrix{1,i+width(2)} = x2(i);
                spectroMatrix{2,i+width(2)} = y2(i);
            end
            
            tempMatrix = [tempMatrix,spectroMatrix];
            
            this.filtered = this.filtered.setMatrix(tempMatrix);
            
        end
    end
    
end

