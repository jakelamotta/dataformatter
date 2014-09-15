classdef AdapterFactory
    %ADAPTERFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        adapters
    end
    
    methods (Access = public)
        
        function this = AdapterFactory()
            this.adapters = containers.Map;
            this.adapters('1') = @() AbioticDataAdapter();
            this.adapters('2') = @() SpectroDataAdapter();
            this.adapters('3') = @() WeatherDataAdapter();
            this.adapters('4') = @() ImageDataAdapter();
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

