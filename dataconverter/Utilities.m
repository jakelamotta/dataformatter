classdef Utilities
    %UTILITIES Utility class contaning som static methods for generic tasks
    %that are useful for many different classes
    
    methods (Static)
        

        function [first,second] = padMatrix(first, second)
            [h1,w1] = size(first);
            [h2,w2] = size(second);
            
            diff = abs(w1-w2);
            
            if w1 < w2
                newMat = cell(h1,diff);
                first = [first,newMat];
                first(1,:) = second(1,:);
            elseif w1 > w2
                newMat = cell(h2,diff);
                second = [second,newMat];
                second(1,:) = first(1,:);
            end
        end
        
        %%
        function [path] = getpath(file)
            %Returns correct path for given file and type, only the relative paths are
            %hardcoded because they are not subjects of change
            tmp = mfilename('fullpath'); %Returns path of current m-file
            
            prefixpy = [tmp(1:end-length(mfilename)),'data\'];
            path = [prefixpy,file];
        end
        
        %%Pad a string with the input string padWidth so that the input is
        %%of length len
        function outStr = padString(inVal,padWith,len)
            outStr = inVal;
            while length(outStr) < len
                outStr = [padWith,outStr];
            end
        end
        
        %%
        function [outX,outY] = countSort(this,x,y)
            size_ = ceil(max(x)*100);
            
            x_ = zeros(1,size_);
            y_ = zeros(1,size_);
            
            len = length(x);
            
            for i=1:len
                x_(round(x(i)*100)+1) = x(i);
                y_(round(x(i)*100)+1) = y(i);
            end
            
            outX = [];
            outY = [];
            
            for i=1:length(x_)
                if x_(i) ~= 0
                    outX(end+1) = x_(i);
                    outY(end+1) = y_(i);
                end
            end
            
        end
    end
end

