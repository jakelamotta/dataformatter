classdef Event < handle
    %EVENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods (Static)
        
        function MouseClickCallback(handle,eventdata)
            set(handle,'UserData',true);
        end
        
        function MouseMoveCallback(handle,eventdata)
            
            disp_ = get(handle,'UserData');
            if ~islogical(disp)
                disp_ = false;
            end
            disp_ = true;
            if disp_ 
                axesHandle  = get(objectHandle,'Parent');       
                coordinates = get(handle,'CurrentPoint');
                coordinates = coordinates(1,1:2)
            end
        end
        
        function MouseDragCallback(handle,eventdata)
            
        end
    end
    
end

