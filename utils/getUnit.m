function output = getUnit(unit)    
    NM = 1e-9;
    UM = 1e-6;
    MM = 1e-3;
    CM = 1e-2;
    
    if unit == "nm"
        output = NM;
    elseif unit == "um"
        output = UM;
    elseif unit == "mm"
        output = MM;
    elseif unit == "cm"
        output = CM;
    elseif unit == "deg"
        output = pi/180;
    elseif unit == "rad"
        output = 1;
    end
end
