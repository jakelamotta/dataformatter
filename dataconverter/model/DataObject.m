classdef DataObject < handle
    %DATAOBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        xlsMatrix;
        id;
        spectroData;
    end
    
    methods (Access = public)
        
        function this = DataObject()
            %this.xlsMatrix = cell(1,414);
            this.xlsMatrix = {'Date','ID','Flower','wind speed (m/s)','direction(degrees)','Temperature(c)','temperature(c)','Humidity','Pressure','lux1','lux2'};
            this.spectroData = struct;
            
            this = this.initStructFields();
            
            %temp = cell(1,401);
            
            %for i=1:401
            %    temp{1,i} = num2str(379+i);
            %end
            
            %this.xlsMatrix = [this.xlsMatrix,temp];
            %this.xlsMatrix = [this.xlsMatrix;{'','','',0,0,0,0,0,0,0,0,0,0}];
        end
        
        function this = addSpectroData(this,inStruct)
            this.spectroData = mergestruct(this.spectroData,inStruct);
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
        
        function this = setObservation(this,matrix,id)
            
            s = size(matrix);
            
            
            for i=1:s(2)
                for j=1:this.getWidth()
                    for k=2:s(1);
                        this.xlsMatrix{k,2} = id;
                        
                        if strcmp(this.xlsMatrix{1,j},matrix{1,i})
                            this.xlsMatrix{k,j} = matrix{k,i};
                            
                        end
                    end
                end
            end
%             for i=1:s(2)
%                 for k=2:s(1);
%                     this.xlsMatrix{k,2} = id;
%                     for j=1:this.getWidth()
%                         if strcmp(this.xlsMatrix{1,j},matrix{1,i})
%                             this.xlsMatrix{k,j} = matrix{k,i};
%                             break;
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
            
            %Temporary id generator
            %id = num2str(round(rand*100));
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
        
    end    
    
    methods (Access = private)        
        
        function this = initStructFields(this)
            this.spectroData.obs1.x = [];
            this.spectroData.obs1.y = [];
            this.spectroData.obs2.x = [];
            this.spectroData.obs2.y = [];         
            this.spectroData.id = '';
        end
    end
    
end

