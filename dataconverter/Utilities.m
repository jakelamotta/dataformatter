classdef Utilities
    %UTILITIES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Static)
        
        function [first,second] = padMatrix(first, second)
            if length(first) < length(second)
                diff = abs(length(first)-length(second));
                s = size(first);
                height = s(1);
                
                newMat = cell(height,diff);
                first = [first,newMat];
                first(1,:) = second(1,:);
            elseif length(first) > length(second)
                diff = abs(length(first)-length(second));
                s = size(second);
                height = s(1);
                
                newMat = cell(height,diff);
                second = [second,newMat];
                second(1,:) = first(1,:);
            end
            
        end
        
        function [path] = getpath(file)
            %Returns correct path for given file and type, only the relative paths are
            %hardcoded because they are not subjects of change
            
            tmp = mfilename('fullpath'); %Returns path of current m-file
            
            prefixpy = [tmp(1:end-length(mfilename)),'data\'];
              path = [prefixpy,file];
        end
        
    end
end

