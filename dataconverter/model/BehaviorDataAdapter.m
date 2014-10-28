classdef BehaviorDataAdapter < DataAdapter
    %BEHAVIORDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tempMatrix;
        dobj;
    end
    
    methods (Access = public)
        
        function this = BehaviorDataAdapter()
            [~,~,out] = xlsread('C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\data\behavior_variables');
            this.tempMatrix = out;
            this.dobj = DataObject();
        end
        
        function rawData = fileReader(this,path)
            [~,~,rawData] = xlsread(path,2);
        end
        
        function obj = getDataObject(this,paths)
           s = size(paths);
           
           for i=1:s(2)
               idx = strfind(paths{1,i},'\');
               id_ = paths{1,i}(idx(end-2)+1:idx(end-1)-1);
               
               path = paths{1,i};
               
               rawData = this.fileReader(path);
               this = this.addVars(rawData);
               
               obj = this.dobj.setObservation(this.tempMatrix,id_);
           end
            
        end
        
    end
    
    methods (Access = private)
        
        function this = addVars(this,rawData)           
            this.tempMatrix{2,17} = rawData{3,3};
            this.tempMatrix{2,16} = rawData{3,2};
            
            this.tempMatrix{2,14} = rawData{4,2};
            this.tempMatrix{2,15} = rawData{4,3};
            
            this.tempMatrix{2,6} = rawData{5,2};
            this.tempMatrix{2,7} = rawData{5,3};           
        end
        
    end
    
end

