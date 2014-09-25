classdef Organizer
    %ORGANIZER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        sources;
        target;
    end
    
    methods (Access = public)
    
        function this = Organizer()
            this.sources = struct;
            this.target = '';
        end
        
        function path = getPath(this,type)
            path = this.paths.(type);
        end        
        
        function this = launchGUI(this)
            
            out_ = loaddata(this.sources);
            
            if isstruct(out_)
                this.sources = out_.sources;
                this.target = out_.target;
            end
        end
        
    end
    
end