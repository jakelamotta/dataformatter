classdef Organizer
    %ORGANIZER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        sources;
        targets;
    end
    
    methods (Access = public)
    
        function this = Organizer()
            this.paths = struct;
            this.targets = struct;
        end
        
        function path = getPath(this,type)
            path = this.paths.(type);
        end        
        
        function this = launchGUI(this)
            
            t = loaddata(this.sources);
            this.sources = t;
        end
        
    end
    
end