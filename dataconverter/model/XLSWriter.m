classdef XLSWriter
    %XLSWRITER Class responsible for writing dataobjects to a xls-file
    %(excel)
    
    properties
    end
    
    methods (Access = public)
        
        function success = writeToXLS(this,fileName,obj)
            try
                fullname = [fileName,'.xlsx'];
                xlswrite(fullname,obj.getMatrix());
                success = exist(fullname,'file');
            
            catch e
                errordlg(e.getReport(),'Error');
            end
        end
        
        function success = appendXLS(this,fname,obj)
            toSave = obj;
            
            try
                if exist(fname,'file');
                    [~,~,old] = xlsread(fname);

                    toAppend = obj.getMatrix();
%                     
                    
                    [toAppend,old] = Utilities.padMatrix(toAppend,old);
                    s = size(toAppend);
                    temp = [];

                    for i=2:s(1)
                        temp(end+1) = i;
                    end

                    toAppend = toAppend(temp,:);
%                     if length(toAppend) > length(old)
%                         diff = abs(length(toAppend)-length(old));
%                         s = size(old);
%                         height = s(1);
%                             
%                         newMat = cell(height,diff);
%                         old = [old,newMat];
%                         old(1,:) = toAppend(1,:);
%                     elseif length(toAppend) < length(old)
%                         diff = abs(length(toAppend)-length(old));
%                         s = size(toAppend);
%                         height = s(1);
%                             
%                         newMat = cell(height,diff);
%                         toAppend = [toAppend,newMat];
%                         toAppend(1,:) = old(1,:);
%                     end

                    toSave = toSave.setMatrix([old;toAppend]);
                end
            catch e
                errordlg(e.getReport(),'Error!');
            end
            success = this.writeToXLS(fname,toSave);            
        end        
    end    
end