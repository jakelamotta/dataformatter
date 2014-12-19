classdef BehaviorFilter < Filter
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        
        function output = filter(this,unfiltered,type,varargin)
            this.filtered = unfiltered;
            
%             switch type
%                 case 'average'                      
%                     this.filtered = filter@Filter(this,unfiltered,5,this.filtered.getWidth());
%             end        
            this.filtered = filter@Filter(this,unfiltered,5,this.filtered.getWidth());
            output = this.filtered;
                    
        end
        
    end
    
end

