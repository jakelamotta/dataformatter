classdef WindowUpdater < handle
    properties(Access=private)
        textBox;
        button;
    end

    methods(Access=public)

        function this = WindowUpdater(textBox, btn)
            this.textBox = textBox;
            this.button = btn;
        end

        function Update(this,st)
            set(this.textBox,'String',st);
            drawnow();
        end     
        
        function btnCallback(this,a,b,c)
            set(this.textBox,'String','pressed');
        end
        
        
        
    end

end