function [net2 , a] = getPrediction(data,W1,W2)
        % Input times Weights + Bias
        net1 = W1 * data;
         
        %Sigmoid and adding a bias
        a = sigmoidHidden(net1);
            
        %Linear output
        net2 = W2 * a;
end
