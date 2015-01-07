classdef FilterFactory
    %FILTERFACTORY 
    
    properties
        filters;
    end
    
    methods (Access = public)
        
        function this = FilterFactory()
            this.filters = containers.Map;
            this.filters('Abiotic') = @() AbioticFilter();
            this.filters('Spectro') = @() SpectroFilter();
            this.filters('Weather') = @() WeatherFilter();
            this.filters('Image') = @() ImageFilter();
            this.filters('Behavior') = @() BehaviorFilter();
            this.filters('Olfactory') = @() OlfactoryFilter();
        end
        
        function filter = createFilter(this,id)
            if this.filters.isKey(id)
                filter_ = this.filters(id);
                filter = filter_();
            else
                filter = '';
            end
        end
    end    
    
end

