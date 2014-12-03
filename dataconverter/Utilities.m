classdef Utilities
    %UTILITIES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    
    end
       
    methods (Static)
        
        %%
        function [first,second] = padMatrix(first, second)
            lenFirst = size(first);
            lenSecond = size(second);
            lenFirst = lenFirst(2);
            lenSecond = lenSecond(2);
            
            if lenFirst < lenSecond
                diff = abs(lenFirst-lenSecond);
                s = size(first);
                height = s(1);
                
                newMat = cell(height,diff);
                first = [first,newMat];
                first(1,:) = second(1,:);
            elseif lenFirst > lenSecond
                diff = abs(lenFirst-lenSecond);
                s = size(second);
                height = s(1);
                
                newMat = cell(height,diff);
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
        
        %%
        function row = findRowFromTime(matrix,time)
            %Time in format 'yyyymmddhhmm'
        end
        
        %%
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

