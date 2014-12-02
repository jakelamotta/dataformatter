classdef OlfactoryDataAdapter < DataAdapter
    %OLFACTORYDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        
        function this = OlfactoryDataAdapter()
            this.dobj = Observation();
        end
        
        function obj = getDataObject(this,paths)
            tic;
            size_ = size(paths);
            
            for i=1:size_(2)
                idx = strfind(paths{1,i},'\');
                
                try
                    id_ = paths{1,i}(idx(end-2)+1:idx(end-1)-1);
                catch e
                    errordlg(['Incorrect path was passed to the file reader. Matlab error: ',e.message()]);
                end
                
                rawData = this.fileReader(paths{1,i});
                
                x = transpose(rawData(:,1));
                y = transpose(rawData(:,2));
                
                tempStruct = struct;
                tempStruct.x = x;
                tempStruct.y = y;
                
               % this.dobj.addOlfactoryData(tempStruct,id_);
                this.dobj.setID(id_);
            end
            
            obj = this.dobj;
            toc            
        end
        
        function rawData = fileReader(this,p)
            rawData = csvread(p,3,0);
        end
    end
    
    methods (Access = private)
        
        function [outX,outY] = countSort(this,x,y)
            size_ = ceil(max(x)*100);
            
            x_ = zeros(1,size_);
            y_ = zeros(1,size_);
            
            len = length(x);
            
            for i=1:len
                x_(round(x(i)*100)+1) = x(i);
                y_(round(x(i)*100)+1) = y(i);
            end
            
            outX = [];
            outY = [];
            
            for i=1:length(x_)
                if x_(i) ~= 0
                    outX(end+1) = x_(i);
                    outY(end+1) = y_(i);
                end
            end
            
        end
    end
    
end

