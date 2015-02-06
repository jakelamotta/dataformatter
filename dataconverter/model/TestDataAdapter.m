classdef TestDataAdapter < DataAdapter
    %TESTDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        
        function this = TestDataAdapter(this,paths)
           this.tempMatrix = {'var1','var2','var3'}; 
        end
        
        function obs = getObservation(this,paths)
            obs = Observation();
            id = 'tests';
            
            this.tempMatrix = [this.tempMatrix;{1,2,'somethingsomething'}];
            
            obs.setObservation(this.tempMatrix,id);
        end
    end
    
end

