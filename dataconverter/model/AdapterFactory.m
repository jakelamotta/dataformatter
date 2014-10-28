classdef AdapterFactory
    %ADAPTERFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        adapters
    end
    
    methods (Access = public)
        
        function this = AdapterFactory()
            this.adapters = containers.Map;
            this.adapters('Abiotic') = @() AbioticDataAdapter();
            this.adapters('Spectro') = @() SpectroDataAdapter();
            this.adapters('Weather') = @() WeatherDataAdapter();
            this.adapters('Image') = @() ImageDataAdapter();
            this.adapters('Behavior') = @() BehaviorDataAdapter();
        end
        
        function adapter = createAdapter(this,id)
            if this.adapters.isKey(id)
                adapter = this.adapters(id);
                adapter = adapter();
            else
                adapter = '';
            end
        end
    end    
end

