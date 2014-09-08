classdef AdapterFactory
    %ADAPTERFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        adapters
    end
    
    methods (Access = public)
        
        function this = AdapterFactory()
            this.adapters = containers.Map;
            this.adapters('1') = 'AbioticDataAdapter';
        end
        
        function adapter = createAdapter(this,id)
            adapter = this.adapters(id);
        end
    end
    
end

