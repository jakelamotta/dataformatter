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
                    this.filtered = filter@Filter(this,this.filtered,10,this.filtered.getWidth());
            end
            
            this.downSample2(dsrate);
            this.expandSpectrumPoints();
            
            filtered = this.filtered;
        end
    end
    
    methods (Access = private)
        
        function this = downSample2(this,dsrate)
            y1pos = uint32(Constants.SpectroYPos);
            y2pos = uint32(Constants.SpectroYUpPos);
            x1newpos = uint32(Constants.SpectroXPos);
            x2newpos = uint32(Constants.SpectroXUpPos);
            
            matrix = this.filtered.getMatrix();
            height = this.filtered.getNumRows();
            
            for i=2:height
                y1 = matrix{i,y1pos};
                x1 = matrix{i,x1newpos};
                y2 = matrix{i,y2pos};
                x2 = matrix{i,x2newpos};

                x1new = round(linspace(380,600,dsrate));
                x2new = round(linspace(380,600,dsrate));

                y1 = interp1(x1,y1,x1new);
                y2 = interp1(x2,y2,x2new);
                
                matrix{i,y1pos} = y1;
                matrix{i,y2pos} = y2;
                matrix{i,x1newpos} = x1new;
                matrix{i,x2newpos} = x2new;                
            end
            
            this.filtered.setMatrix(matrix);
        end
                
        function this = expandSpectrumPoints(this)
           matrix = this.filtered.getMatrix();
           height = this.filtered.getNumRows();
           
           spectroXpos = uint32(Constants.SpectroXPos);
           spectroXuppos = uint32(Constants.SpectroXUpPos);
           
           y1 = matrix{2,spectroXpos};
           y2 = matrix{2,spectroXuppos};
           
           appendee = cell(height,2*length(y1));
           
           for j=2:height
               row = matrix(j,:);
               
               x1 = row{uint32(Constants.SpectroYPos)};               
               x2 = row{uint32(Constants.SpectroYUpPos)};
               
               for k=1:length(x1)
                  
                  if j==2
                    appendee{1,k} = [num2str(y1(k)),'_f'];
                    appendee{1,k+length(x1)} = [num2str(y2(k)),'_u'];
                  end
                  
                  appendee{j,k} = x1(k);
                  appendee{j,k+length(x1)} = x2(k);
               end               
           end
           
           matrix = [matrix(:,1:spectroXpos-1),matrix(:,uint32(Constants.OlfYPos)+1:end)];
           matrix = [matrix,appendee];
           
           this.filtered.setMatrix(matrix);
        end
    end
    
end

