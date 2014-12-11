classdef Constants < uint32
    %Constants enum with definitions for where important columns
    %exist in the Observation cell. When changing the place of any of these
    %columns the value needs to be changed in Constants accordingly.     
    enumeration
       %%Column position of "ID"
       IdPos (2)
       
       %%Column position of Spectro arrays
       SpectroXPos (20)
       SpectroYPos (21)
       SpectroXUpPos (22)
       SpectroYUpPos (23)
       
       %%Column position of Olfactory arrays
       OlfXPos (24)
       OlfYPos (25)
    end
end

