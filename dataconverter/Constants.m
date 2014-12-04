classdef Constants < uint32
    %Constants Enumeration with definitions for where important columns
    %exist in the Observation cell. When changing the place of any of these
    %columns the value needs to be changed in Constants accordingly.     
    enumeration
       %%Column position of "ID"
       IdPos (2)
       
       %%Column position of Spectro arrays
       SpectroXPos (22)
       SpectroYPos (23)
       SpectroXUpPos (24)
       SpectroYUpPos (25)
       
       %%Column position of Olfactory arrays
       OlfXPos (26)
       OlfYPos (27)
    end
end

