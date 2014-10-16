s = size(b);            
id = '3'
            
            if s(2) < 50
            
                for i=1:s(2)
                    for j=1:length(a)
                        for k=2:s(1);
                            %a{k,2} = id;
                            if strcmp(a{1,j},b{1,i})
                                a{k,j} = b{k,i};
                            end
                        end
                    end                
                end
                
            else
                
                
                
            end