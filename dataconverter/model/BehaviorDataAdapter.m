classdef BehaviorDataAdapter < DataAdapter
    %BEHAVIORDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tempMatrix;
        varMap;
    end
    
    methods (Access = public)
        
        function this = BehaviorDataAdapter()
            global matrixColumns;
            this.tempMatrix = matrixColumns;
            this.dobj = DataObject();
            global varmap;
            this.varMap = varmap;
        end
        
        function rawData = fileReader(this,path)
            try
                [~,~,rawData] = xlsread(path);
            catch
                errordlg('Incorrect path, excel file for behavior data could not be read');
            end
        end
        
        function obj = getDataObject(this,paths)
           s = size(paths);
           
           for i=1:s(2)
               idx = strfind(paths{1,i},'\');
               try
                    id_ = paths{1,i}(idx(end-2)+1:idx(end-1)-1);
               catch
                    errordlg('Incorrect path was passed to the file reader');
               end
               
               path = paths{1,i};
               
               rawData = this.fileReader(path);
               rawData = this.parse(rawData);
               
               obj = this.dobj.setObservation(this.tempMatrix,id_);
           end            
        end
        
    end
    
    methods (Access = private)
        function this = parse(this,rawData)           
            nrOfRows = size(rawData);
            
            for i=1:nrOfRows(1)
                if isnan(rawData{i,1})
                    rawData{i,1} = '';
                end
            end
            
            idx = strfind(rawData(:,1),'Subject');
            observations = cell(1,length(idx));
            
            for i=1:length(idx)-1
                obs = [rawData(idx(i):idx(1+1),6),rawData(idx(i):idx(1+1),8:9)];
                observations{i} = obs;
            end
        end        
    end    
end

