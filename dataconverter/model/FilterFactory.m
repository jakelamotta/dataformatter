classdef FilterFactory
    %FILTERFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
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

