classdef DataObject < handle
    %DATAOBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        xlsMatrix;
        spectroData;
        olfactoryData;
    end
    
    methods (Access = public)
        
        function this = DataObject()
            this.xlsMatrix = {'Flower','ID','Date','temperature(c)','Humidity','Pressure','wind speed (m/s)','direction(degrees)','Temperature(c)','lux1','lux2','Comment'};
            [a,b,tempMat] = xlsread(Utilities.getpath('behavior_variables'));%xlsread('C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\data\behavior_variables');
            this.xlsMatrix = [this.xlsMatrix,tempMat];
            
            this.spectroData = struct;
            this.olfactoryData = struct;
            %this = this.initStructFields();
        end
        
        function this = addSpectroData(this,inStruct,id_)
            if ~isfield(this.spectroData,id_)
                id_ = strrep(id_,'.','');
                this.spectroData.(id_) = inStruct;            
            end
        end
        
        function this = setSpectroData(this,inStruct)
            this.spectroData = inStruct;
        end
            
        function this = setOlfactory(this,inStruct,id)
            if ~isempty(this.spectroData)
                mex = MException('awa');
                throw(mex);
            end
            id = strrep(id,'.','');
            this.spectroData.id = inStruct;
        end
        
        function row = getRowFromID(this,id)
            
            height = this.getNumRows();
            width = this.getWidth();
            row = [];
            
            for i=2:height
               for j=1:width
                   if strcmp(this.xlsMatrix{1,j},'ID') 
                       if strcmp(this.xlsMatrix{i,j},id)
                           row = [this.xlsMatrix(1,:);this.xlsMatrix(i,:)];
                           break;
                       end
                   end
               end                
            end           
        end
        
        function this = deleteRowFromID(this,id)
            mat = this.getMatrix();
            height = this.getNumRows();
            rowNr = -1;
            for i=2:height
                if strcmp(id,mat{i,2})
                    rowNr = i;
                    break;
                end
            end
            
            if rowNr ~= -1
                mat = [mat(1:rowNr-1,:);mat(rowNr+1:end,:)];
            end
            this.setMatrix(mat);
        end
        
        function this = setObservation(this,matrix,id)
            s = size(matrix);
            
            appendCell = cell(s(1),this.getWidth());
            
            start = 1;
            
            counter = 0;
            
%             for i=1:this.getWidth()
%                 
%                 if strcmp(this.xlsMatrix{1,i},matrix{1,1})
%                     for k=2:s(1)
%                         appendCell{k,i} = matrix{k,1};
%                         start = i+1;
%                         counter = counter +1;
%                     end
%                     break;
%                 end
%                 counter = counter +1;
%             end
%             
            
            for i=1:s(2)                
                for j=start:this.getWidth()
                    
                    if strcmp(this.xlsMatrix{1,j},matrix{1,i})
                        for k=2:s(1);
                            counter = counter +1;
                            appendCell{k,2} = id;
                            appendCell{k,j} = matrix{k,i};
                        end
                        break;
                    end
                    counter = counter+1;
                end
            end
            
            disp(['Loop ran for ',num2str(counter),' times']);
            
            [this.xlsMatrix,appendCell] = Utilities.padMatrix(this.xlsMatrix,appendCell);
            
            this.xlsMatrix = [this.xlsMatrix;appendCell(2:end,:)];
            
%           for i=1:s(2)
%               for j=1:this.getWidth()
%                   for k=2:s(1);
%                       this.xlsMatrix{k,2} = id;
%                         
%                       if strcmp(this.xlsMatrix{1,j},matrix{1,i})
%                             this.xlsMatrix{k,j} = matrix{k,i};
%                             
%                         end
%                     end
%                 end
%             end            
        end
        
        function s = getWidth(this)
            size_ = size(this.xlsMatrix);
            s = size_(2);
        end
        
        function s = getNumRows(this)
            size_ = size(this.xlsMatrix);
            s = size_(1);
        end
        
        function id = getObjectID(this)
            id = cell(1,1);
            
            for i=1:this.getWidth()
                if strcmp('ID',this.xlsMatrix{1,i})
                    id{1,1} = this.xlsMatrix{2,i};                   
                end
            end
            
            for i=3:this.getNumRows()
                for j=1:this.getWidth()
                  if strcmp('ID',this.xlsMatrix{1,j})
                      id{1,i-1} = this.xlsMatrix{i,j};
                  end
                end
            end
        end
        
        function matrix = getMatrix(this)
            matrix = this.xlsMatrix;
        end
        
        function this = setMatrix(this,m)
            this.xlsMatrix = m;
        end
        
        function sout = getSpectroData(this)
            sout = this.spectroData;
        end
        
        function oout = getOlfactoryData(this)
            oout = this.olfactoryData;
        end
        
        
    end    
    
    methods (Access = private)                
        function this = initStructFields(this)
            this.spectroData = struct;
            this.olfactoryData = struct;
%             this.spectroData.obs1.x = [];
%             this.spectroData.obs1.y = [];
%             this.spectroData.obs2.x = [];
%             this.spectroData.obs2.y = [];
%             this.spectroData.time = '';
%             this.spectroData.id = '';
%             
%             this.olfactoryData.x = [];
%             this.olfactoryData.y = [];
        end
    end
    
end

