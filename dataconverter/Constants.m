classdef Constants < uint32
    %Constants enum with definitions for where important columns
    %exist in the Observation cell. When changing the place of any of these
    %columns the value needs to be changed in Constants accordingly.
    %Their placement is easily found by opening the program, clearing data
    %and look for each position to the far right.
    
    enumeration
       %%Column position of "ID"
       IdPos (2)
       
       %%Column position of Spectro arrays
       SpectroXPos (48)
       SpectroYPos (49)
       SpectroXUpPos (50)
       SpectroYUpPos (51)
       
       %%Column position of Olfactory arrays
       OlfXPos (52)
       OlfYPos (53)
    end
end

