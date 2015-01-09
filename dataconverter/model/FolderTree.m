classdef FolderTree < handle
    %FOLDERTREE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parent;
        children;
        issource;
        source;
        name;
    end
    
    methods (Access = public)
        
        function this = FolderTree(n,varargin)
            
           this.name = n;
           this.children = {};
           if isempty(varargin)
               this.issource = true;
           else
               p = varargin{1};
               this.parent = p;
           end           
        end
        
        function toString(this)
            disp(this.name);
        end
        
        function child = getChild(this,index)
            child = this.children{index};
        end
        
        function this = addChild(this,child)
           this.children = [this.children,{child}]; 
        end
        
        function p = getParent(this)
            p = this.parent;
        end
        
        function childrenList = getChildren(this)
            childrenList = this.children;
        end
        
        function isparent = isParent(this)
            isparent = true;
            
            if isempty(this.children)
               isparent = false; 
            end
        end
        
    end    
end

