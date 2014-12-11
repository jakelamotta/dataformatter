classdef Constants < uint32
    %Constants enum with definitions for where important columns
    %exist in the Observation cell. When changing the place of any of these
    %columns the value needs to be changed in Constants accordingly.     
    enumeration
       %%Column position of "ID"
       IdPos (2)
       
       %%Column position of Spectro arrays
       SpectroXPos (21)
       SpectroYPos (22)
       SpectroXUpPos (23)
       SpectroYUpPos (24)
       
       %%Column position of Olfactory arrays
       OlfXPos (25)
       OlfYPos (26)
    end
end

