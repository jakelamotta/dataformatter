classdef ImageDataAdapter < DataAdapter
    %IMAGEDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties        
        
    end
    
    methods (Access = public)
        
        function this = ImageDataAdapter()        
            
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
                h = image(rawData);
                
                waitfor(h);
                
                x = transpose(rawData(:,1));
                y = transpose(rawData(:,2));
                
                tempStruct = struct;
                tempStruct.x = x;
                tempStruct.y = y;
                
                this.dobj.addOlfactoryData(tempStruct,id_);
                this.dobj.setID(id_);
            end
            
            obj = this.dobj;
            toc
        end
        
        function rawData = fileReader(this,path)
            image = imread('C:\Users\Public\Pictures\Sample Pictures\Chrysanthemum.jpg'); % load image
        end
        
    end    
end

