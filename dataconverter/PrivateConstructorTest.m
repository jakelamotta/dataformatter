classdef PrivateConstructorTest
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        aValue;
    end
    
    methods (Static)
        function obj = createPCT()
           obj = PrivateConstructorTest(); 
        end
    end
    
    methods (Access = private)
        
        function this = PrivateConstructorTest()
            this.aValue = 3;
        end
        
    end
    
end

