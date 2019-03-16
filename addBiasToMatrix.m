function a = addBiasToMatrix(x)
        % Add bias one to a the input Layer
        add = ones(1,size(x,2));
        a = [x; add];
end